import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_repository_failure.dart';
import '../../repository/mock_repository.dart';

void main() {
  late Repository mockRepository;
  late GetAllBlocksUseCase getAllBlocks;

  setUp(() {
    mockRepository = MockRepository();
    getAllBlocks = GetAllBlocksUseCase(mockRepository);
  });

  test(
      "should get all blocks from the repository sorted by latest session's date descending then by id descending",
      () async {
        // arrange
        final blocks = [
          // This block should be sorted 2nd because its last session's date
          // (25/01/2021) is shared with "Block 3" but the block id is lower.
          BlockWithSessions(id: 1, name: 'Block 1', sessions: [
            Session(id: 1, date: DateTime(2021, 1, 15)),
            Session(id: 3, date: DateTime(2021, 1, 25)),
            Session(id: 2, date: DateTime(2021, 1, 20))
          ]..shuffle()),
          // This block should be the 3rd block returned because its last session
          // (16/01/2021) is the oldest of all blocks (that have sessions).
          BlockWithSessions(id: 2, name: 'Block 2', sessions: [
            Session(id: 3, date: DateTime(2021, 1, 5)),
            Session(id: 4, date: DateTime(2021, 1, 8)),
            Session(id: 2, date: DateTime(2021, 1, 8)),
            Session(id: 1, date: DateTime(2021, 1, 16))
          ]..shuffle()),
          // This block should be sorted 1st because its last session's date
          // (25/01/2021) is shared with "Block 1" but the block id is higher.
          BlockWithSessions(id: 3, name: 'Block 3', sessions: [
            Session(id: 3, date: DateTime(2021, 1, 20)),
            Session(id: 1, date: DateTime(2021, 1, 10)),
            Session(id: 2, date: DateTime(2021, 1, 25)),
            Session(id: 4, date: DateTime(2021, 1, 10))
          ]..shuffle()),
          // This block should be sorted last because it has no sessions.
          const BlockWithSessions(id: 4, name: 'Block 4', sessions: <Session>[])
        ];
        when(() => mockRepository.getAllBlocks())
            .thenAnswer((_) => Stream.value(Right(blocks)));

        // act
        final result = await getAllBlocks().first;

        // assert
        result.fold(
          (failure) => fail('Should not return a failure'),
          (repositoryBlocks) {
            // Check the blocks are sorted by latest session's date descending then by id descending
            expect(repositoryBlocks, [ blocks[2], blocks[0], blocks[1], blocks[3] ]);

            // Check the sessions of each block are sorted by date
            for (final block in repositoryBlocks) {
              for(final i in Iterable.generate(block.sessions.length - 1)) {
                expect(
                  block.sessions[i].date.isBefore(block.sessions[i + 1].date) ||
                    (block.sessions[i].date.isAtSameMomentAs(block.sessions[i + 1].date) &&
                        block.sessions[i].id < block.sessions[i + 1].id),
                  true
                );
              }
            }
          }
        );
        verify(() => mockRepository.getAllBlocks());
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when updating a block",
      () async {
        final repositoryFailure = MockRepositoryFailure();

        // arrange
        when(() => mockRepository.getAllBlocks())
            .thenAnswer((_) => Stream.value(Left(repositoryFailure)));

        // act
        final result = await getAllBlocks().first;

        // assert
        expect(result, Left(repositoryFailure));
        verify(() => mockRepository.getAllBlocks());
        verifyNoMoreInteractions(mockRepository);
      }
  );
}