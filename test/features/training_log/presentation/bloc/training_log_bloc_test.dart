import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';
import 'package:miles/features/training_log/presentation/bloc/training_log_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/mock_repository_failure.dart';

class GetAllBlocksUseCaseMock extends Mock implements GetAllBlocksUseCase {}
class TrainingLogUseCasesMock extends Mock implements TrainingLogUseCases {
  @override
  final GetAllBlocksUseCaseMock getAllBlocks;
  TrainingLogUseCasesMock({required this.getAllBlocks});
}

void main() {

  late TrainingLogUseCases useCases;

  setUp(() {
    useCases = TrainingLogUseCasesMock(
      getAllBlocks: GetAllBlocksUseCaseMock()
    );
  });

  const blocks = [
    BlockWithSessions(id: 1, name: 'Block 1', sessions: <Session>[]),
    BlockWithSessions(id: 2, name: 'Block 2', sessions: <Session>[]),
    BlockWithSessions(id: 3, name: 'Block 3', sessions: <Session>[]),
  ];

  blocTest<TrainingLogBloc, TrainingLogState>(
    'initial state should be Loading then Loaded',
    build: () {
      when(() => useCases.getAllBlocks())
          .thenAnswer((_) => Stream.value(const Right(blocks)));
      return TrainingLogBloc(useCases: useCases);
    },
    expect: () => [Loading(), const Loaded(blocks: blocks)]
  );

  blocTest<TrainingLogBloc, TrainingLogState>(
      'initial state should be Loading then Error when repository fails',
      build: () {
        final failure = MockRepositoryFailure();
        when(() => useCases.getAllBlocks())
            .thenAnswer((_) => Stream.value(Left(failure)));
        return TrainingLogBloc(useCases: useCases);
      },
      expect: () => [Loading(), Error()]
  );

}