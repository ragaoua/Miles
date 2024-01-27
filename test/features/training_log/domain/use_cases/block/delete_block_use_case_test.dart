import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/delete_block_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_repository_failure.dart';
import '../../repository/mock_repository.dart';

void main() {
  late Repository mockRepository;
  late DeleteBlockUseCase deleteBlock;

  setUp(() {
    mockRepository = MockRepository();
    deleteBlock = DeleteBlockUseCase(mockRepository);
  });

  const block = Block(id: 1, name: 'Block 1');

  test(
      'should delete the block from the repository',
      () async {
        // arrange
        when(() => mockRepository.deleteBlock(block))
            .thenAnswer((_) async => null);

        // act
        await deleteBlock(block);

        // assert
        verify(() => mockRepository.deleteBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when updating a block",
      () async {
        final repositoryFailure = MockRepositoryFailure();

        // arrange
        when(() => mockRepository.deleteBlock(block))
            .thenAnswer((_) async => repositoryFailure);

        // act
        final result = await deleteBlock(block);

        // assert
        expect(result, repositoryFailure);
        verify(() => mockRepository.deleteBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}