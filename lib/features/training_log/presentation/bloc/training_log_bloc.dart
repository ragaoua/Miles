import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';

import '../../domain/entities/block.dart';
import '../../domain/repositories/repository.dart';
import '../../domain/use_cases/block/delete_block_use_case.dart';
import '../../domain/use_cases/block/insert_block_use_case.dart';
import '../../domain/use_cases/block/restore_block_use_case.dart';
import '../../domain/use_cases/block/update_block_use_case.dart';

part 'training_log_event.dart';
part 'training_log_state.dart';
part 'training_log_use_cases.dart';

class TrainingLogBloc extends Bloc<TrainingLogEvent, TrainingLogState> {
  final TrainingLogUseCases useCases;

  StreamSubscription? _blocksSubscription ;

  TrainingLogBloc({required this.useCases}) : super(Loading()) {
    on<LoadBlocks>(_onLoadBlocks);
    on<AddBlock>(_onAddBlock);
    on<UpdateBlocks>(_onUpdateBlocks);
    on<ShowError>(_onShowError);

    add(LoadBlocks());
  }

  void _onLoadBlocks(LoadBlocks event, Emitter<TrainingLogState> emit) {
    emit(Loading());

    _blocksSubscription?.cancel();
    _blocksSubscription = useCases.getAllBlocks().listen(
        (getAllBlocksEither) => getAllBlocksEither.fold(
            (failure) => add(const ShowError()), // TODO : handle error
            (blocks) => add(UpdateBlocks(blocks: blocks))
        ),
        onError: (_) => add(const ShowError()) // TODO : handle error
    );
  }

  void _onUpdateBlocks(UpdateBlocks event, Emitter<TrainingLogState> emit) {
    emit(Loaded(blocks: event.blocks));
  }

  void _onShowError(ShowError event, Emitter<TrainingLogState> emit) {
    emit(Error()); // TODO : handle error
  }

  Future<void> _onAddBlock(AddBlock event, Emitter<TrainingLogState> emit) async {
    final insertBlockEither = await useCases.insertBlock(
        name: event.blockName,
        nbDays: event.nbDays
    );
    insertBlockEither.fold(
        (failure) => add(const ShowError()), // TODO : handle error
        (blockId) {} // TODO : navigate to this block's page
    );
  }

  @override
  Future<void> close() {
    _blocksSubscription?.cancel(); // Cancel the subscription
    return super.close();
  }
}