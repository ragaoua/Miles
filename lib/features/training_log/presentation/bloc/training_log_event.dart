part of 'training_log_bloc.dart';

abstract class TrainingLogEvent extends Equatable {
  const TrainingLogEvent();

  @override
  List<Object> get props => [];
}

class ShowNewBlockSheet extends TrainingLogEvent {}

class HideNewBlockSheet extends TrainingLogEvent {}

// class UpdateNewBlockName extends TrainingLogEvent {
//   final String newBlockName;
//
//   const UpdateNewBlockName({required this.newBlockName});
//   @override
//   List<Object> get props => [newBlockName];
// }

class ToggleMicroCycleSettings extends TrainingLogEvent {}

// class UpdateDaysPerMicroCycle extends TrainingLogEvent {
//   final String nbDays;
//
//   const UpdateDaysPerMicroCycle({required this.nbDays});
//   @override
//   List<Object> get props => [nbDays];
// }

class AddBlock extends TrainingLogEvent {
  final String blockName;

  const AddBlock({required this.blockName});
  @override
  List<Object> get props => [blockName];
}

class DeleteBlock extends TrainingLogEvent {
  final Block block;

  const DeleteBlock({required this.block});
  @override
  List<Object> get props => [block];
}