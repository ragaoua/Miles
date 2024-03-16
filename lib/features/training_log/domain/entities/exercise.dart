import 'package:equatable/equatable.dart';
import 'package:miles/features/training_log/domain/entities/exercise_set.dart';

import 'movement.dart';

class Exercise extends Equatable {
  static const int defaultId = 0;
  static const int defaultSessionId = 0;
  static const int defaultOrder = 0;
  static const int defaultSupersetOrder = 0;
  static const int defaultMovementId = 0;
  static const RatingType defaultRatingType = RatingType.rpe;

  final int id;
  final int sessionId;
  final int order;
  final int supersetOrder;
  final int movementId;
  final RatingType ratingType;

  const Exercise({
    this.id = defaultId,
    this.sessionId = defaultSessionId,
    this.order = defaultOrder,
    this.supersetOrder = defaultSupersetOrder,
    this.movementId = defaultMovementId,
    this.ratingType = defaultRatingType,
  });

  @override
  List<Object?> get props =>
      [id, sessionId, order, supersetOrder, movementId, ratingType];

  @override
  bool get stringify => true;
}

class ExerciseWithMovementAndSets extends Exercise {
  final Movement movement;
  final List<ExerciseSet> sets;

  const ExerciseWithMovementAndSets({
    super.id = Exercise.defaultId,
    super.sessionId = Exercise.defaultSessionId,
    super.order = Exercise.defaultOrder,
    super.supersetOrder = Exercise.defaultSupersetOrder,
    super.movementId = Exercise.defaultMovementId,
    super.ratingType = Exercise.defaultRatingType,
    required this.movement,
    required this.sets,
  });

  @override
  List<Object?> get props => [...super.props, movement, sets];
}

enum RatingType { rpe, rir }
