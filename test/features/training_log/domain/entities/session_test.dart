import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

void main() {
  test(
    'SessionWithExercises should override props correctly',
    () {
      const exercises = [
        Exercise(
          id: 3,
          sessionId: 6,
          order: 2,
          supersetOrder: 4,
          movementId: 8,
          ratingType: RatingType.rpe,
        ),
        Exercise(
          id: 4,
          sessionId: 6,
          order: 3,
          supersetOrder: 5,
          movementId: 9,
          ratingType: RatingType.rir,
        ),
      ];
      final session = SessionWithExercises(
        id: 3,
        dayId: 6,
        date: DateTime.now(),
        exercises: exercises,
      );
      expect(session.props, [3, 'Squat', exercises]);
    },
  );

  test(
    'Session should override stringify correctly',
    () {
      final session = Session(date: DateTime.now());
      expect(session.stringify, true);
    },
  );
}
