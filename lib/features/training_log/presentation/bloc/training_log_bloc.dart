import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:miles/features/training_log/domain/use_cases/block/get_all_blocks_use_case.dart';

import '../../domain/entities/block.dart';

part 'training_log_event.dart';
part 'training_log_state.dart';

class TrainingLogBloc extends Bloc<TrainingLogEvent, TrainingLogState> {
  final GetAllBlocksUseCase getAllBlocks;

  TrainingLogBloc(this.getAllBlocks) : super(Loading()) {
    on<LoadBlocks>(_onLoadBlocks);

    add(LoadBlocks());
  }

  Future<void> _onLoadBlocks(LoadBlocks event, Emitter<TrainingLogState> emit) async {
    emit(Loading());
    final getAllBlocksEither = await getAllBlocks();
    emit(
        getAllBlocksEither.fold(
          (failure) => Error(),
          (blocks) => Loaded(blocks: blocks)
        )
    );
  }
}