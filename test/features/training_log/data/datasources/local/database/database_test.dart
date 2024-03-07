import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:miles/features/training_log/data/datasources/local/database/database.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

void main() {
  group('Database', () {
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
  });
}