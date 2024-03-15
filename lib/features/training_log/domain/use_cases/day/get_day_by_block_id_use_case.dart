import 'package:dartz/dartz.dart';

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
/// Returns a [Failure] if something went wrong when fetching the data
class GetDaysByBlockIdUseCase {
  final Repository repository;

  GetDaysByBlockIdUseCase(this.repository);

  Future<
      Either<
          Failure,
          List<
              DayWithSessions<
                  SessionWithExercises<ExerciseWithMovementAndSets>>>>> call(
    int blockId,
  ) =>
      repository.getDaysByBlockId(blockId);
}
