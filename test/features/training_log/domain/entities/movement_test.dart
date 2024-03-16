import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/movement.dart';

void main() {
  const movement = Movement(
    id: 3,
    name: 'Squat',
  );

  test(
    'Movement should override props correctly',
    () {
      expect(movement.props, [3, 'Squat']);
    },
  );

  test(
    'Movement should override stringify correctly',
    () => expect(movement.stringify, true),
  );
}
