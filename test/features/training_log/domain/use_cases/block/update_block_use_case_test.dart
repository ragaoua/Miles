import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/validate_block_name.dart';
import 'package:miles/features/training_log/domain/use_cases/block/update_block_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'get_all_blocks_use_case_test.mocks.dart';

class _MockRepositoryFailure extends Failure {}

void main() {
  late Repository mockRepository;
  late UpdateBlockUseCase updateBlock;

  setUp(() {
    mockRepository = MockRepository();
    updateBlock = UpdateBlockUseCase(mockRepository);
  });

  test(
      "should fail when updating a block with an empty name",
      () async {
        // act
        final result = await updateBlock(const Block(name: " "));
        // assert
        expect(result, isA<BlockNameEmptyFailure>());

        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should fail when updating a block with a name that already exists",
      () async {
        const blockName = "Block 1";
        const updatedBlock = Block(id: 2, name: blockName);

        // arrange
        when(mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(Block(id: 1, name: blockName)));

        // act
        final result = await updateBlock(updatedBlock);

        // assert
        expect(result, isA<BlockNameAlreadyExistsFailure>());

        verify(mockRepository.getBlockByName(blockName));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should update a block with a name that does not exist yet",
      () async {
        const blockName = "Block 5";
        const updatedBlock = Block(id: 5, name: blockName);

        // arrange
        when(mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(null));
        when(mockRepository.updateBlock(updatedBlock))
            .thenAnswer((_) async => null);

        // act
        final result = await updateBlock(updatedBlock);

        // assert
        expect(result, null);
        verify(mockRepository.getBlockByName(blockName));
        verify(mockRepository.updateBlock(updatedBlock));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when updating a block",
      () async {
        const blockName = "Block 5";
        const updatedBlock = Block(id: 5, name: blockName);
        final repositoryFailure = _MockRepositoryFailure();

        // arrange
        when(mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(null));
        when(mockRepository.updateBlock(updatedBlock))
            .thenAnswer((_) async => repositoryFailure);

        // act
        final result = await updateBlock(updatedBlock);

        // assert
        expect(result, repositoryFailure);
        verify(mockRepository.getBlockByName(blockName));
        verify(mockRepository.updateBlock(updatedBlock));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}