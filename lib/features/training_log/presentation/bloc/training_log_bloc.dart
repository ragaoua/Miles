import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/block.dart';
import '../../domain/repositories/repository.dart';

part 'training_log_event.dart';
part 'training_log_state.dart';

class TrainingLogBloc extends Bloc<TrainingLogEvent, TrainingLogState> {
  final Repository _repository;

  TrainingLogBloc(this._repository) : super(Loading());

  Stream<TrainingLogState> mapEventToState(TrainingLogEvent event) async* {
    throw UnimplementedError();
  }
}