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

  TrainingLogBloc({required this.useCases}) : super(Loading()) {
    on<LoadBlocks>(_onLoadBlocks);

    add(LoadBlocks());
  }

  Future<void> _onLoadBlocks(LoadBlocks event, Emitter<TrainingLogState> emit) async {
    emit(Loading());
    final getAllBlocksEither = await useCases.getAllBlocks.call();
    emit(
        getAllBlocksEither.fold(
          (failure) => Error(),
          (blocks) => Loaded(blocks: blocks)
        )
    );
  }
}