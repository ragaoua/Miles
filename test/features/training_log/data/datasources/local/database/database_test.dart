import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:miles/features/training_log/data/datasources/local/database/database.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/exercise_set.dart';
import 'package:miles/features/training_log/domain/entities/movement.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

void main() {
  late Database db;

  setUp(() {
    db = Database(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group(
    'getAllBlocks',
    () {
      test(
        'should return an empty list',
        () async {
          // Act
          final result = await db.getAllBlocks().first;
          // Assert
          expect(result, []);
        },
      );

      test(
        """
        should return all blocks sorted by latest session descending then by
        id descending. For each block, sessions should be sorted by date then
        by id.
        """,
        () async {
          // Arrange
          final blocks = {
            // This block should be sorted 2nd because its last session's date
            // (25/01/2021) is shared with "Block 3" but the block id is lower.
            const Block(id: 1, name: 'Block 1'): {
              const Day(id: 1, order: 1): [
                Session(id: 1, date: DateTime(2021, 1, 15)),
                Session(id: 2, date: DateTime(2021, 1, 25)),
                Session(id: 3, date: DateTime(2021, 1, 20))
              ]..shuffle()
            },
            // This block should be the 3rd block returned because its last session
            // (16/01/2021) is the oldest of all blocks (that have sessions).
            const Block(id: 2, name: 'Block 2'): {
              const Day(id: 2, order: 1): [
                Session(id: 4, date: DateTime(2021, 1, 5)),
                Session(id: 5, date: DateTime(2021, 1, 16))
              ]..shuffle(),
              const Day(id: 3, order: 2): [
                Session(id: 6, date: DateTime(2021, 1, 8))
              ]..shuffle(),
              const Day(id: 4, order: 3): [
                Session(id: 7, date: DateTime(2021, 1, 8))
              ]..shuffle()
            },
            // This block should be sorted 1st because its last session's date
            // (25/01/2021) is shared with "Block 1" but the block id is higher.
            const Block(id: 3, name: 'Block 3'): {
              const Day(id: 5, order: 1): [
                Session(id: 8, date: DateTime(2021, 1, 20)),
                Session(id: 9, date: DateTime(2021, 1, 10))
              ]..shuffle(),
              const Day(id: 6, order: 2): [
                Session(id: 10, date: DateTime(2021, 1, 25)),
                Session(id: 11, date: DateTime(2021, 1, 10))
              ]..shuffle()
            },
            // This block should be sorted last because it has no sessions.
            const Block(id: 4, name: 'Block 4'): {
              const Day(id: 7, order: 1): <Session>[]..shuffle()
            }
          };

          await db.batch((batch) {
            blocks.forEach((block, days) {
              batch.insert(
                db.blockDAO,
                BlockDAOCompanion.insert(
                  id: Value(block.id),
                  name: block.name,
                ),
              );

              days.forEach((day, sessions) {
                batch.insert(
                  db.dayDAO,
                  DayDAOCompanion.insert(
                    id: Value(day.id),
                    blockId: block.id,
                    order: day.order,
                  ),
                );

                for (final session in sessions) {
                  batch.insert(
                    db.sessionDAO,
                    SessionDAOCompanion.insert(
                      id: Value(session.id),
                      dayId: day.id,
                      date: session.date,
                    ),
                  );
                }
              });
            });
          });

          // Act
          final result = await db.getAllBlocks().first;

          // Assert
          // Check the blocks are sorted by latest session's date descending then by id descending
          expect(
            result
                .map((block) => Block(id: block.id, name: block.name))
                .toList(),
            [
              const Block(id: 3, name: 'Block 3'),
              const Block(id: 1, name: 'Block 1'),
              const Block(id: 2, name: 'Block 2'),
              const Block(id: 4, name: 'Block 4'),
            ],
          );

          // Check the sessions of each block are sorted by date then by id
          for (final block in result) {
            for (final i in Iterable.generate(block.sessions.length - 1)) {
              expect(
                block.sessions[i].date.isBefore(block.sessions[i + 1].date) ||
                    (block.sessions[i].date
                            .isAtSameMomentAs(block.sessions[i + 1].date) &&
                        block.sessions[i].id < block.sessions[i + 1].id),
                true,
              );
            }
          }
        },
      );
    },
  );

  group(
    'getBlockByName',
    () {
      test(
        'getBlockByName should return the block with the given name',
        () async {
          // Arrange
          const blockName = 'Block 1';
          const block = Block(id: 1, name: blockName);
          await db.into(db.blockDAO).insert(
                BlockDAOCompanion.insert(
                  id: Value(block.id),
                  name: block.name,
                ),
              );

          // Act
          final result = await db.getBlockByName(blockName);

          // Assert
          expect(result, equals(block));
        },
      );

      test(
        'getBlockByName should return null when no block matches the given name',
        () async {
          // Arrange
          const blockName = 'Non-existent Block';

          // Act
          final result = await db.getBlockByName(blockName);

          // Assert
          expect(result, null);
        },
      );
    },
  );

  group(
    'insertBlockAndDays',
    () {
      test(
        'should insert a block and the given number of days',
        () async {
          // Arrange
          const blockName = 'Block 1';
          const nbDays = 3;

          // Act
          final insertedBlockId =
              await db.insertBlockAndDays(blockName, nbDays);

          // Assert
          final block = await db.select(db.blockDAO).getSingle();
          expect(block, Block(id: insertedBlockId, name: blockName));

          final days = await db.select(db.dayDAO).get();
          expect(days.length, nbDays);
          // Check each day has the correct block id and order
          for (final dayIndex in Iterable.generate(nbDays)) {
            expect(
              days[dayIndex],
              Day(
                id: dayIndex + 1,
                blockId: insertedBlockId,
                order: dayIndex + 1,
              ),
            );
          }
        },
      );
    },
  );

  group(
    "getDaysByBlockId",
    () {
      Future<void> insertDaysWithSessionsWithExercisesWithMovementAndSets(
          List<
                  DayWithSessions<
                      SessionWithExercises<ExerciseWithMovementAndSets>>>
              days) async {
        await db.batch((batch) {
          for (final day in days) {
            batch.insert(
              db.dayDAO,
              DayDAOCompanion.insert(
                id: Value(day.id),
                blockId: day.blockId,
                order: day.order,
              ),
            );

            for (final session in day.sessions) {
              batch.insert(
                db.sessionDAO,
                SessionDAOCompanion.insert(
                  id: Value(session.id),
                  dayId: session.dayId,
                  date: session.date,
                ),
              );

              for (final exercise in session.exercises) {
                batch.insert(
                  db.movementDAO,
                  MovementDAOCompanion.insert(
                    id: Value(exercise.movement.id),
                    name: exercise.movement.name,
                  ),
                );

                batch.insert(
                  db.exerciseDAO,
                  ExerciseDAOCompanion.insert(
                    id: Value(exercise.id),
                    sessionId: exercise.sessionId,
                    order: exercise.order,
                    supersetOrder: exercise.supersetOrder,
                    movementId: exercise.movement.id,
                    ratingType: exercise.ratingType,
                  ),
                );

                for (final set in exercise.sets) {
                  batch.insert(
                    db.exerciseSetDAO,
                    ExerciseSetDAOCompanion.insert(
                      id: Value(set.id),
                      exerciseId: set.exerciseId,
                      order: set.order,
                      reps: Value(set.reps),
                      load: Value(set.load),
                      rating: Value(set.rating),
                    ),
                  );
                }
              }
            }
          }
        });
      }

      test(
        """
        should return a list of days for a given block.
        Days should be sorted by order.
        Each day's sessions should be sorted by date then by id.
        Each session's exercises should be sorted by order then by supersetOrder.
        Each exercise's sets should sorted by order.
        """,
        () async {
          // Arrange
          final random = Random();
          const blockId = 1;
          const nbDays = 3;
          const nbSessionsPerDay = 3;
          const nbExercisesPerSession = 5;
          const nbSetsPerExercise = 3;
          final days = List.generate(
            nbDays,
            (dayIndex) {
              final dayId = dayIndex + 1;
              return DayWithSessions(
                id: dayId,
                blockId: blockId,
                order: dayId,
                sessions: List.generate(
                  nbSessionsPerDay,
                  (sessionIndex) {
                    final sessionId =
                        (dayIndex * nbSessionsPerDay) + (sessionIndex + 1);
                    return SessionWithExercises(
                      id: sessionId,
                      dayId: dayId,
                      date: DateTime(2021, 1, 1 + random.nextInt(3)),
                      exercises: List.generate(
                        nbExercisesPerSession,
                        (exerciseIndex) {
                          final exerciseId =
                              ((sessionId - 1) * nbExercisesPerSession) +
                                  (exerciseIndex + 1);
                          return ExerciseWithMovementAndSets(
                            id: exerciseId,
                            sessionId: sessionId,
                            // Every pair of exercises is a superset
                            order: (exerciseIndex ~/ 2) + 1,
                            supersetOrder: (exerciseIndex % 2) + 1,
                            movement: Movement(
                              id: exerciseId,
                              name: "Example Movement $exerciseId",
                            ), // Movements are irrelevant here
                            sets: List.generate(
                              nbSetsPerExercise,
                              (setIndex) => ExerciseSet(
                                id: ((exerciseId - 1) * nbSetsPerExercise) +
                                    (setIndex + 1),
                                exerciseId: exerciseId,
                                order: setIndex + 1,
                              ),
                            )..shuffle(),
                          );
                        },
                      )..shuffle(),
                    );
                  },
                )..shuffle(),
              );
            },
          )..shuffle();
          await insertDaysWithSessionsWithExercisesWithMovementAndSets(days);

          // Act
          final databaseDays = await db.getDaysByBlockId(blockId);

          // Assert
          for (final dayIndex in Iterable.generate(databaseDays.length - 1)) {
            final day = databaseDays[dayIndex];
            final nextDay = databaseDays[dayIndex + 1];

            // Check the days are sorted by order
            expect(day.order < nextDay.order, true);

            // Check the sessions of each day are sorted by date then by id
            for (final sessionIndex
                in Iterable.generate(day.sessions.length - 1)) {
              final session = day.sessions[sessionIndex];
              final nextSession = day.sessions[sessionIndex + 1];
              expect(
                session.date.isBefore(nextSession.date) ||
                    (session.date.isAtSameMomentAs(nextSession.date) &&
                        session.id < nextSession.id),
                true,
              );

              // Check the exercises of each session are sorted by order then by supersetOrder
              for (final exerciseIndex
                  in Iterable.generate(session.exercises.length - 1)) {
                final exercise = session.exercises[exerciseIndex];
                final nextExercise = session.exercises[exerciseIndex + 1];
                expect(
                  exercise.order < nextExercise.order ||
                      (exercise.order == nextExercise.order &&
                          exercise.supersetOrder < nextExercise.supersetOrder),
                  true,
                );

                // Check the sets of each exercise are sorted by order
                for (final setIndex
                    in Iterable.generate(exercise.sets.length - 1)) {
                  final set = exercise.sets[setIndex];
                  final nextSet = exercise.sets[setIndex + 1];
                  expect(set.order < nextSet.order, true);
                }
              }
            }
          }
        },
      );
    },
  );
}
