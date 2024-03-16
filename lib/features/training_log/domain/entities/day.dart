import 'package:equatable/equatable.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

class Day extends Equatable {
  static const int defaultId = 0;
  static const int defaultBlockId = 0;
  static const int defaultOrder = 0;

  final int id;
  final int blockId;
  final int order;

  const Day({
    this.id = defaultId,
    this.blockId = defaultBlockId,
    this.order = defaultOrder,
  });

  @override
  List<Object?> get props => [id, blockId, order];

  @override
  bool get stringify => true;
}

class DayWithSessions<T extends Session> extends Day {
  final List<T> sessions;

  const DayWithSessions({
    super.id = Day.defaultId,
    super.blockId = Day.defaultBlockId,
    super.order = Day.defaultOrder,
    required this.sessions,
  });

  @override
  List<Object?> get props => [...super.props, sessions];
}
