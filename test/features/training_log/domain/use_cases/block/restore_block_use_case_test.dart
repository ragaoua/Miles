import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/restore_block_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../core/mock_repository_failure.dart';
@GenerateNiceMocks([MockSpec<Repository>()])
import 'get_all_blocks_use_case_test.mocks.dart';

void main() {
  late Repository mockRepository;
  late RestoreBlockUseCase restoreBlock;

  setUp(() {
    mockRepository = MockRepository();
    restoreBlock = RestoreBlockUseCase(mockRepository);
  });

  const block = BlockWithDays<Day>(id: 1, name: 'Block 1', days: []);

  test(
      'should restore the block from the repository',
      () async {
        // arrange
        when(mockRepository.restoreBlock(block))
            .thenAnswer((_) async => null);

        // act
        await restoreBlock(block);

        // assert
        verify(mockRepository.restoreBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );

  test(
      "should propagate repository failure when updating a block",
      () async {
        final repositoryFailure = MockRepositoryFailure();

        // arrange
        when(mockRepository.restoreBlock(block))
            .thenAnswer((_) async => repositoryFailure);

        // act
        final result = await restoreBlock(block);

        // assert
        expect(result, repositoryFailure);
        verify(mockRepository.restoreBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}