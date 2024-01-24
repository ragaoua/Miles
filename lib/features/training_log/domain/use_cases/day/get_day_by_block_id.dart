import 'package:dartz/dartz.dart';
import 'package:miles/core/sorting.dart';

import '../../../../../core/failure.dart';
import '../../entities/day.dart';
import '../../entities/exercise.dart';
import '../../entities/session.dart';
import '../../repositories/repository.dart';

/// Use Case : Retrieve a list of days for a given block
/// Days are sorted by order.
/// Each day's sessions are sorted by date then by id
/// Each session's exercises are sorted by order then by supersetOrder
/// Each exercise's sets are sorted by order
class GetDaysByBlockId {
  final Repository repository;

  GetDaysByBlockId(this.repository);

  Future<Either<
      Failure,
      List<DayWithSessions<SessionWithExercises<ExerciseWithMovementAndSets>>>
  >> call(int blockId) async {
    final result = await repository.getDaysByBlockId(blockId);

    return result.fold(
      (failure) => Left(failure),
      (days) => Right(
        // Sort days by order
        days.sortedByList([
          (day) => day.order
        ]).map((day) => day.copy(
          // Sort sessions by date then by id
          sessions: day.sessions.sortedByList([
            (session) => session.date,
            (session) => session.id
          ]).map((session) => session.copy(
            // Sort exercises by order then by supersetOrder
            exercises: session.exercises.sortedByList([
              (exercise) => exercise.order,
              (exercise) => exercise.supersetOrder
            ]).map((exercise) => exercise.copy(
              // Sort sets by order
              sets: exercise.sets.sortedByList([
                (set) => set.order
              ]).toList()
            )).toList()
          )).toList()
        )).toList()
      )
    );
  }
}