import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks.dart';
import 'package:miles/features/training_log/presentation/bloc/training_log_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/mock_repository_failure.dart';
@GenerateNiceMocks([MockSpec<Repository>()])
import 'training_log_bloc_test.mocks.dart';

void main() {

  late Repository mockRepository;
  late GetAllBlocks getAllBlocks;

  setUp(() {
    mockRepository = MockRepository();
    getAllBlocks = GetAllBlocks(mockRepository);
  });

  test(
      'initial state should be Loading then Loaded',
      () {
        // arrange
        const blocks = [
          BlockWithSessions(id: 1, name: 'Block 1', sessions: <Session>[]),
          BlockWithSessions(id: 2, name: 'Block 2', sessions: <Session>[]),
          BlockWithSessions(id: 3, name: 'Block 3', sessions: <Session>[]),
        ];
        when(mockRepository.getAllBlocks())
            .thenAnswer((_) async => const Right(blocks));

        // act
        final bloc = TrainingLogBloc(getAllBlocks);

        // assert
        final expected = [ Loading(), const Loaded(blocks: blocks) ];
        expect(bloc.stream, emitsInOrder(expected));
      }
  );

  test(
      'initial state should be Loading then Error when repository fails',
      () {
        // arrange
        final failure = MockRepositoryFailure();
        when(mockRepository.getAllBlocks())
            .thenAnswer((_) async => Left(failure));
        // act
        final bloc = TrainingLogBloc(getAllBlocks);

        // assert
        final expected = [ Loading(), Error() ];
        expect(bloc.stream, emitsInOrder(expected));
      }
  );

}