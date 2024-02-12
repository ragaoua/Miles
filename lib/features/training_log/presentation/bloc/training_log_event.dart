part of 'training_log_bloc.dart';

@immutable
abstract class TrainingLogEvent extends Equatable {
  const TrainingLogEvent();

  @override
  List<Object> get props => [];
}

class LoadBlocks extends TrainingLogEvent {}

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
  final int nbDays;

  const AddBlock({
    required this.blockName,
    required this.nbDays
  });
  @override
  List<Object> get props => [blockName, nbDays];
}

class DeleteBlock extends TrainingLogEvent {
  final Block block;

  const DeleteBlock({required this.block});
  @override
  List<Object> get props => [block];
}

class UpdateBlocks extends TrainingLogEvent {
  final List<BlockWithSessions> blocks;

  const UpdateBlocks({required this.blocks});
  @override
  List<Object> get props => [blocks];
}

class ShowError extends TrainingLogEvent {
  final String message;

  const ShowError({this.message=""});
  @override
  List<Object> get props => [message];
}