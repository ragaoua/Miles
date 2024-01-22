import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/restore_block.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'get_all_blocks_test.mocks.dart';

void main() {
  late Repository mockRepository;
  late RestoreBlock restoreBlock;

  setUp(() {
    mockRepository = MockRepository();
    restoreBlock = RestoreBlock(mockRepository);
  });

  const block = BlockWithSessions<Session>(id: 1, name: 'Block 1', sessions: []);

  test(
      'should restore the block from the repository',
      () async {
        // arrange
        when(mockRepository.restoreBlock(block))
            .thenAnswer((_) async => const Right(null));

        // act
        await restoreBlock(block: block);

        // assert
        verify(mockRepository.restoreBlock(block));
        verifyNoMoreInteractions(mockRepository);
      }
  );
}