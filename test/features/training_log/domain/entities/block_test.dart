import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';

void main() {
  test(
    'BlockWithDays should override props correctly',
    () {
      const days = [
        Day(id: 1),
        Day(id: 2),
        Day(id: 3),
      ];
      const block = BlockWithDays(
        id: 1,
        name: 'Block 1',
        days: days,
      );
      expect(block.props, [1, 'Block 1', days]);
    },
  );
}
