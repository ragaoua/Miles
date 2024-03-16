import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  static const int defaultId = 0;
  static const int defaultExerciseId = 0;
  static const int defaultOrder = 0;

  final int id;
  final int exerciseId;
  final int order;
  final int? reps;
  final double? load;
  final double? rating;

  const ExerciseSet({
    this.id = defaultId,
    this.exerciseId = defaultExerciseId,
    this.order = defaultOrder,
    this.reps,
    this.load,
    this.rating,
  });

  @override
  List<Object?> get props => [id, exerciseId, order, reps, load, rating];

  @override
  bool get stringify => true;
}
