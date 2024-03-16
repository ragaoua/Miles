import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/exercise_set.dart';
import 'package:miles/features/training_log/domain/entities/movement.dart';

void main() {
  test(
    'ExerciseWithMovementAndSets should override props correctly',
    () {
      const sets = [
        ExerciseSet(id: 1),
        ExerciseSet(id: 2),
        ExerciseSet(id: 3),
      ];
      const movement = Movement(id: 1, name: 'Squat');
      const exercise = ExerciseWithMovementAndSets(
        id: 3,
        sessionId: 6,
        order: 2,
        supersetOrder: 4,
        movementId: 8,
        ratingType: RatingType.rpe,
        movement: movement,
        sets: sets,
      );
      expect(exercise.props, [3, 6, 2, 4, 8, RatingType.rpe, movement, sets]);
    },
  );

  test(
    'Exercise should override stringify correctly',
    () {
      const exercise = Exercise();
      expect(exercise.stringify, true);
    },
  );
}
