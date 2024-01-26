part of 'training_log_bloc.dart';

abstract class TrainingLogState extends Equatable {
  const TrainingLogState();

  @override
  List<Object> get props => [];
}

class Loading extends TrainingLogState {}

class Loaded extends TrainingLogState {
  final List<BlockWithSessions> blocks;

  const Loaded({required this.blocks});
  @override
  List<Object> get props => [blocks];
}

class ShowingNewBlockSheet extends TrainingLogState {
  final String blockName;
  final String blockNameError;
  final bool areMicroCycleSettingsShown;
  final String nbDaysPerMicroCycle;

  const ShowingNewBlockSheet({
    required this.blockName,
    required this.blockNameError,
    required this.areMicroCycleSettingsShown,
    required this.nbDaysPerMicroCycle,
  });
  @override
  List<Object> get props => [
    blockName,
    blockNameError,
    areMicroCycleSettingsShown,
    nbDaysPerMicroCycle,
  ];
}