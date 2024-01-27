import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/movement.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/entities/set.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/day/get_day_by_block_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_repository_failure.dart';
import '../../repository/mock_repository.dart';

void main() {
  late Repository mockRepository;
  late GetDaysByBlockIdUseCase getDaysByBlockId;
  final random = Random();

  setUp(() {
    mockRepository = MockRepository();
    getDaysByBlockId = GetDaysByBlockIdUseCase(mockRepository);
  });

  const blockId = 1;
  final days = List.generate(
    3, // 3 days
    (dayIndex) => DayWithSessions(
      id: random.nextInt(1000),
      blockId: blockId,
      order: dayIndex + 1,
      sessions: List.generate(
        3, // 3 sessions per day
        (sessionIndex) => SessionWithExercises(
          id: sessionIndex + 1,
          dayId: dayIndex + 1,
          date: DateTime(2021, 1, 1+random.nextInt(3)),
          exercises: List.generate(
            5, // 5 exercises per session
            (exerciseIndex) => ExerciseWithMovementAndSets(
              id: random.nextInt(1000),
              sessionId: sessionIndex + 1,
              order: exerciseIndex + 1,
              supersetOrder: 1, // Adjust as needed
              movement: const Movement(id: 1, name: "Example Movement"), // Irrelevant
              sets: List.generate(
                3, // 3 sets per exercise
                (setIndex) => Set(
                  id: random.nextInt(1000),
                  exerciseId: exerciseIndex + 1,
                  order: setIndex + 1
                ),
              )..shuffle(),
            ),
          )..shuffle(),
        ),
      )..shuffle(),
    ),
  )..shuffle();

  test(
      "should get all blocks from the repository sorted by latest session's date descending then by id descending",
      () async {
        // arrange
        when(() => mockRepository.getDaysByBlockId(blockId))
            .thenAnswer((_) async => Right(days));

        // act
        final result = await getDaysByBlockId(blockId);

        // assert
        result.fold(
          (failure) => fail('Should not return a failure'),
          (repositoryDays) {
            // Check the days are sorted by order
            for (final dayIndex in Iterable.generate(repositoryDays.length - 1)) {
              final day = repositoryDays[dayIndex];
              final nextDay = repositoryDays[dayIndex + 1];
              expect(day.order < nextDay.order, true);

              // Check the sessions of each day are sorted by date then by id
              for(final sessionIndex in Iterable.generate(day.sessions.length - 1)) {
                final session = day.sessions[sessionIndex];
                final nextSession = day.sessions[sessionIndex + 1];
                expect(
                    session.date.isBefore(nextSession.date) ||
                        (session.date.isAtSameMomentAs(nextSession.date) &&
                         session.id < nextSession.id),
                    true
                );

                // Check the exercises of each session are sorted by order then by supersetOrder
                for(final exerciseIndex in Iterable.generate(session.exercises.length - 1)) {
                  final exercise = session.exercises[exerciseIndex];
                  final nextExercise = session.exercises[exerciseIndex + 1];
                  expect(
                      exercise.order < nextExercise.order ||
                          (exercise.order == nextExercise.order &&
                           exercise.supersetOrder < nextExercise.supersetOrder),
                      true
                  );

                  // Check the sets of each exercise are sorted by order
                  for(final setIndex in Iterable.generate(exercise.sets.length - 1)) {
                    final set = exercise.sets[setIndex];
                    final nextSet = exercise.sets[setIndex + 1];
                    expect(set.order < nextSet.order, true);
                  }
                }
              }
            }
          }
        );
        verify(() => mockRepository.getDaysByBlockId(blockId));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when updating a block",
      () async {
        final repositoryFailure = MockRepositoryFailure();

        // arrange
        when(() => mockRepository.getDaysByBlockId(blockId))
            .thenAnswer((_) async => Left(repositoryFailure));

        // act
        final result = await getDaysByBlockId(blockId);

        // assert
        expect(result, Left(repositoryFailure));
        verify(() => mockRepository.getDaysByBlockId(blockId));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}