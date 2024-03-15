import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_failure.dart';
import '../../repository/mock_repository.dart';

void main() {
  late Repository mockRepository;
  late GetAllBlocksUseCase getAllBlocks;

  setUp(() {
    mockRepository = MockRepository();
    getAllBlocks = GetAllBlocksUseCase(mockRepository);
  });

  test(
    "should get all blocks from the repository",
    () async {
      // arrange
      const repositoryBlocks = [
        BlockWithSessions(id: 1, name: "Block 1", sessions: <Session>[]),
        BlockWithSessions(id: 2, name: "Block 2", sessions: <Session>[])
      ];
      when(
        () => mockRepository.getAllBlocks(),
      ).thenAnswer(
        (_) => Stream.value(const Right(repositoryBlocks)),
      );

      // act
      final result = await getAllBlocks().first;

      // assert
      result.fold(
        (failure) => fail('Should not return a failure'),
        (useCaseBlocks) {
          // Check that the use case returns the exact same list of blocks
          // as the repository
          expect(useCaseBlocks, repositoryBlocks);
        },
      );
      verify(() => mockRepository.getAllBlocks());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    "should propagate repository failure when updating a block",
    () async {
      final repositoryFailure = MockFailure();

      // arrange
      when(
        () => mockRepository.getAllBlocks(),
      ).thenAnswer(
        (_) => Stream.value(Left(repositoryFailure)),
      );

      // act
      final result = await getAllBlocks().first;

      // assert
      expect(result, Left(repositoryFailure));
      verify(() => mockRepository.getAllBlocks());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
