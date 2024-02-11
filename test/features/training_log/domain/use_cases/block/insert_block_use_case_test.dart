import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/validate_block_name.dart';
import 'package:miles/features/training_log/domain/use_cases/block/insert_block_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../repository/mock_repository.dart';

class _MockRepositoryFailure extends Failure {}

void main() {
  late Repository mockRepository;
  late InsertBlockUseCase insertBlock;

  setUp(() {
    mockRepository = MockRepository();
    insertBlock = InsertBlockUseCase(mockRepository);
  });

  test(
      "should fail when inserting a block with an empty name",
      () async {
        // act
        final result = await insertBlock(name: " ", nbDays: 1);
        // assert
        result.fold(
          (failure) => expect(failure, isA<BlockNameEmptyFailure>()),
          (_) => fail("should have returned a BlockNameEmptyFailure")
        );

        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should fail when inserting a block with a name that already exists",
      () async {
        const blockName = "Block 3";

        // arrange
        when(() => mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(Block(id: 1, name: blockName)));

        // act
        final result = await insertBlock(name: blockName, nbDays: 1);

        // assert
        result.fold(
          (failure) => expect(failure, isA<BlockNameAlreadyExistsFailure>()),
          (_) => fail("should have returned a BlockNameAlreadyExistsFailure")
        );

        verify(() => mockRepository.getBlockByName(blockName));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should insert a block with a name that does not exist yet",
          () async {
        const blockId = 5;
        const blockName = "Block 5";
        const nbDays = 3;

        // arrange
        when(() => mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.insertBlockAndDays(blockName, nbDays))
            .thenAnswer((_) async => const Right(blockId));

        // act
        final result = await insertBlock(name: blockName, nbDays: nbDays);

        // assert
        expect(result, const Right(blockId));

        verify(() => mockRepository.getBlockByName(blockName));
        verify(() => mockRepository.insertBlockAndDays(blockName, nbDays));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when inserting a block",
      () async {
        const blockName = "Block 5";
        const nbDays = 3;
        final repositoryFailure = _MockRepositoryFailure();

        // arrange
        when(() => mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.insertBlockAndDays(blockName, nbDays))
            .thenAnswer((_) async => Left(repositoryFailure));

        // act
        final result = await insertBlock(name: blockName, nbDays: nbDays);

        // assert
        expect(result, Left(repositoryFailure));

        verify(() => mockRepository.getBlockByName(blockName));
        verify(() => mockRepository.insertBlockAndDays(blockName, nbDays));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}