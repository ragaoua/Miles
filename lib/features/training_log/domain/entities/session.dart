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
    required this.date
  });

  Session copy({
    int? id,
    int? dayId,
    DateTime? date
  }) => Session(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    date: date ?? this.date
  );

  @override
  List<Object?> get props => [id, dayId, date];

  @override
  bool get stringify => true;
}

class SessionWithExercises<T extends Exercise> extends Session {
  final List<T> exercises;

  const SessionWithExercises({
    id = Session.defaultId,
    dayId = Session.defaultDayId,
    required date,
    required this.exercises
  }): super(id: id, dayId: dayId, date: date);

  @override
  SessionWithExercises<T> copy({
    int? id,
    int? dayId,
    DateTime? date,
    List<T>? exercises
  }) => SessionWithExercises(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    date: date ?? this.date,
    exercises: exercises ?? this.exercises
  );
}