import 'package:equatable/equatable.dart';

import 'exercise.dart';

class Session extends Equatable {
  static const int defaultId = 0;
  static const int defaultDayId = 0;

  final int id;
  final int dayId;
  final DateTime date;

  const Session({
    this.id = defaultId,
    this.dayId = defaultDayId,
    required this.date,
  });

  @override
  List<Object?> get props => [id, dayId, date];

  @override
  bool get stringify => true;
}

class SessionWithExercises<T extends Exercise> extends Session {
  final List<T> exercises;

  const SessionWithExercises({
    super.id = Session.defaultId,
    super.dayId = Session.defaultDayId,
    required super.date,
    required this.exercises,
  });
}
