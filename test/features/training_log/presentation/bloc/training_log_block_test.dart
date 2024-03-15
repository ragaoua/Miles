import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:miles/features/training_log/domain/use_cases/block/delete_block_use_case.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';
import 'package:miles/features/training_log/domain/use_cases/block/insert_block_use_case.dart';
import 'package:miles/features/training_log/presentation/bloc/training_log_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/mock_failure.dart';

class GetAllBlocksUseCaseMock extends Mock implements GetAllBlocksUseCase {}

class InsertBlockUseCaseMock extends Mock implements InsertBlockUseCase {}

class DeleteBlockUseCaseMock extends Mock implements DeleteBlockUseCase {}

class TrainingLogUseCasesMock extends Mock implements TrainingLogUseCases {
  @override
  final GetAllBlocksUseCaseMock getAllBlocks;
  @override
  final InsertBlockUseCaseMock insertBlock;
  @override
  final DeleteBlockUseCaseMock deleteBlock;
  TrainingLogUseCasesMock(
      {required this.getAllBlocks,
      required this.insertBlock,
      required this.deleteBlock});
}

void main() {
  final TrainingLogUseCases useCases = TrainingLogUseCasesMock(
      getAllBlocks: GetAllBlocksUseCaseMock(),
      insertBlock: InsertBlockUseCaseMock(),
      deleteBlock: DeleteBlockUseCaseMock());

  const blocks = [
    BlockWithSessions(id: 1, name: 'Block 1', sessions: <Session>[]),
    BlockWithSessions(id: 2, name: 'Block 2', sessions: <Session>[]),
    BlockWithSessions(id: 3, name: 'Block 3', sessions: <Session>[]),
  ];

  /// -----------------------------------------------
  /// Test the initial state of the bloc
  /// -----------------------------------------------
  group("Test the initial state of the bloc", () {
    blocTest<TrainingLogBloc, TrainingLogState>(
        'initial states should be Loading then Loaded',
        build: () {
          when(() => useCases.getAllBlocks())
              .thenAnswer((_) => Stream.value(const Right(blocks)));

          return TrainingLogBloc(useCases: useCases);
        },
        expect: () => [const Loading(), const Loaded(blocks: blocks)]);

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Error state should be emitted when repository fails',
        build: () {
          when(() => useCases.getAllBlocks())
              .thenAnswer((_) => Stream.value(Left(MockFailure())));

          return TrainingLogBloc(useCases: useCases);
        },
        expect: () => [const Loading(), const Error()]);

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Error state should be emitted when stream fails',
        build: () {
          when(() => useCases.getAllBlocks())
              .thenAnswer((_) => Stream.error(Exception()));

          return TrainingLogBloc(useCases: useCases);
        },
        expect: () => [const Loading(), const Error()]);
  });

  /// -----------------------------------------------
  /// Test the bloc when a new block is added
  /// -----------------------------------------------
  group("Test the bloc when a new block is added", () {
    late StreamController<Either<Failure, List<BlockWithSessions>>>
        blocksStreamController;
    const newBlock =
        BlockWithSessions(id: 4, name: 'Block 4', sessions: <Session>[]);

    setUp(() {
      blocksStreamController =
          StreamController<Either<Failure, List<BlockWithSessions>>>();
      blocksStreamController.add(const Right(blocks));
      when(() => useCases.getAllBlocks())
          .thenAnswer((_) => blocksStreamController.stream);
    });

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Loaded state should get updated when a new block is added',
        build: () {
          when(() => useCases.insertBlock(
              name: any(named: 'name'),
              nbDays: any(named: 'nbDays'))).thenAnswer((_) async {
            blocksStreamController.add(const Right([...blocks, newBlock]));
            return Right(newBlock.id);
          });

          return TrainingLogBloc(useCases: useCases);
        },
        act: (bloc) => bloc.add(AddBlock(blockName: newBlock.name, nbDays: 1)),
        expect: () => [
              const Loading(),
              const Loaded(blocks: blocks),
              const Loaded(blocks: [...blocks, newBlock])
            ]);

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Error state should be emitted when a new block fails to be added',
        build: () {
          when(() => useCases.insertBlock(
                  name: any(named: 'name'), nbDays: any(named: 'nbDays')))
              .thenAnswer((_) async => Left(MockFailure()));

          return TrainingLogBloc(useCases: useCases);
        },
        act: (bloc) => bloc.add(AddBlock(blockName: newBlock.name, nbDays: 1)),
        expect: () =>
            [const Loading(), const Loaded(blocks: blocks), const Error()]);
  });

  /// -----------------------------------------------
  /// Test the bloc when a block is deleted
  /// -----------------------------------------------
  group("Test the bloc when a block is deleted", () {
    late StreamController<Either<Failure, List<BlockWithSessions>>>
        blocksStreamController;
    const blockToDelete =
        BlockWithSessions(id: 2, name: 'Block 2', sessions: <Session>[]);

    setUp(() {
      blocksStreamController =
          StreamController<Either<Failure, List<BlockWithSessions>>>();
      blocksStreamController.add(const Right(blocks));
      when(() => useCases.getAllBlocks())
          .thenAnswer((_) => blocksStreamController.stream);
    });

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Loaded state should get updated when a block is deleted',
        build: () {
          when(() => useCases.deleteBlock(blockToDelete)).thenAnswer((_) async {
            blocksStreamController
                .add(Right(List.from(blocks)..remove(blockToDelete)));
            return null;
          });

          return TrainingLogBloc(useCases: useCases);
        },
        act: (bloc) => bloc.add(const DeleteBlock(block: blockToDelete)),
        expect: () => [
              const Loading(),
              const Loaded(blocks: blocks),
              Loaded(blocks: List.from(blocks)..remove(blockToDelete))
            ]);

    blocTest<TrainingLogBloc, TrainingLogState>(
        'Error state should be emitted when a block fails to be deleted',
        build: () {
          when(() => useCases.deleteBlock(blockToDelete))
              .thenAnswer((_) async => MockFailure());

          return TrainingLogBloc(useCases: useCases);
        },
        act: (bloc) => bloc.add(const DeleteBlock(block: blockToDelete)),
        expect: () =>
            [const Loading(), const Loaded(blocks: blocks), const Error()]);
  });
}
