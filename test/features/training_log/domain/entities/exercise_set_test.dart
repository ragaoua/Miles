import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/exercise_set.dart';

void main() {
  const set = ExerciseSet(
    id: 3,
    exerciseId: 6,
    order: 2,
    reps: 4,
    load: 8,
    rating: 7,
  );

  test(
    'ExerciseSet should override props correctly',
    () {
      expect(set.props, [3, 6, 2, 4, 8, 7]);
    },
  );

  test(
    'ExerciseSet should override stringify correctly',
    () => expect(set.stringify, true),
  );
}
