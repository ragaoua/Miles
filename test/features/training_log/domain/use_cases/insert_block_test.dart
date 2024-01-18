import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/insert_block.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'get_all_blocks_test.mocks.dart';

void main() {
  late Repository mockRepository;
  late InsertBlock insertBlock;

  setUp(() {
    mockRepository = MockRepository();
    insertBlock = InsertBlock(mockRepository);
  });

  test(
      "should fail when inserting a block with an empty name",
      () async {
        // act
        final result = await insertBlock(name: " ", nbDays: 1);
        // assert
        expect(result, const Left(Failure("block_name_cannot_be_empty")));

        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should fail when inserting a block with a name that already exists",
      () async {
        const blockName = "Block 3";

        // arrange
        when(mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(Block(id: 1, name: blockName)));

        // act
        final result = await insertBlock(name: blockName, nbDays: 1);

        // assert
        expect(result, const Left(Failure("block_name_is_already_used")));

        verify(mockRepository.getBlockByName(blockName));
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
        when(mockRepository.getBlockByName(blockName))
            .thenAnswer((_) async => const Right(null));
        when(mockRepository.insertBlockAndDays(blockName, nbDays))
            .thenAnswer((_) async => const Right(Block(id: blockId, name: blockName)));

        // act
        final result = await insertBlock(name: blockName, nbDays: nbDays);

        // assert
        expect(result, const Right(Block(id: blockId, name: blockName)));

        verify(mockRepository.getBlockByName(blockName));
        verify(mockRepository.insertBlockAndDays(blockName, nbDays));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}