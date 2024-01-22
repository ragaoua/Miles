import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/delete_block.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'get_all_blocks_test.mocks.dart';

void main() {
  late Repository mockRepository;
  late DeleteBlock deleteBlock;

  setUp(() {
    mockRepository = MockRepository();
    deleteBlock = DeleteBlock(mockRepository);
  });

  const block = Block(id: 1, name: 'Block 1');

  test(
      'should delete the block from the repository',
      () async {
        // arrange
        when(mockRepository.deleteBlock(block))
            .thenAnswer((_) async => const Right(null));

        // act
        await deleteBlock(block: block);

        // assert
        verify(mockRepository.deleteBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}