import 'package:flutter_test/flutter_test.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

void main() {
  test(
    'DayWithSessions should override props correctly',
    () {
      final sessions = [
        Session(date: DateTime.parse('2021-08-02')),
        Session(date: DateTime.parse('2021-11-06')),
        Session(date: DateTime.parse('2021-05-02')),
      ];
      final day = DayWithSessions(
        id: 56,
        blockId: 45,
        order: 89,
        sessions: sessions,
      );
      expect(day.props, [56, 45, 89, sessions]);
    },
  );

  test(
    'Day should override stringify correctly',
    () {
      const day = Day();
      expect(day.stringify, true);
    },
  );
}
