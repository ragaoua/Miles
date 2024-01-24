import 'package:equatable/equatable.dart';
import 'package:miles/features/training_log/domain/entities/set.dart';

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

  Exercise copy({
    int? id,
    int? sessionId,
    int? order,
    int? supersetOrder,
    int? movementId,
    RatingType? ratingType
  }) => Exercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    order: order ?? this.order,
    supersetOrder: supersetOrder ?? this.supersetOrder,
    movementId: movementId ?? this.movementId,
    ratingType: ratingType ?? this.ratingType
  );

  @override
  List<Object?> get props =>
      [id, sessionId, order, supersetOrder, movementId, ratingType];

  @override
  bool get stringify => true;
}

class ExerciseWithMovementAndSets extends Exercise {
  final Movement movement;
  final List<Set> sets;

  const ExerciseWithMovementAndSets({
    id = Exercise.defaultId,
    sessionId = Exercise.defaultSessionId,
    order = Exercise.defaultOrder,
    supersetOrder = Exercise.defaultSupersetOrder,
    movementId = Exercise.defaultMovementId,
    ratingType = Exercise.defaultRatingType,
    required this.movement,
    required this.sets
  }): super(
    id: id,
    sessionId: sessionId,
    order: order,
    supersetOrder: supersetOrder,
    movementId: movementId,
    ratingType: ratingType
  );

  @override
  ExerciseWithMovementAndSets copy({
    int? id,
    int? sessionId,
    int? order,
    int? supersetOrder,
    int? movementId,
    RatingType? ratingType,
    Movement? movement,
    List<Set>? sets
  }) => ExerciseWithMovementAndSets(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    order: order ?? this.order,
    supersetOrder: supersetOrder ?? this.supersetOrder,
    movementId: movementId ?? this.movementId,
    ratingType: ratingType ?? this.ratingType,
    movement: movement ?? this.movement,
    sets: sets ?? this.sets
  );
}

enum RatingType {
  rpe, rir
}