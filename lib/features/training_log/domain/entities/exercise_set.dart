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

  ExerciseSet copy({
    int? id,
    int? exerciseId,
    int? order,
    int? reps,
    double? load,
    double? rating,
  }) =>
      ExerciseSet(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        order: order ?? this.order,
        reps: reps ?? this.reps,
        load: load ?? this.load,
        rating: rating ?? this.rating,
      );

  @override
  List<Object?> get props => [id, exerciseId, order, reps, load, rating];

  @override
  bool get stringify => true;
}
