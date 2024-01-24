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
    this.order = defaultOrder
  });

  Day copy({
    int? id,
    int? blockId,
    int? order
  }) => Day(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    order: order ?? this.order
  );

  @override
  List<Object?> get props => [id, blockId, order];

  @override
  bool get stringify => true;
}

class DayWithSessions<T extends Session> extends Day {
  final List<T> sessions;

  const DayWithSessions({
    id = Day.defaultId,
    blockId = Day.defaultBlockId,
    order = Day.defaultOrder,
    required this.sessions
  }): super(id: id, blockId: blockId, order: order);

  @override
  DayWithSessions<T> copy({
    int? id,
    int? blockId,
    int? order,
    List<T>? sessions
  }) => DayWithSessions(
    id: id ?? this.id,
    blockId: blockId ?? this.blockId,
    order: order ?? this.order,
    sessions: sessions ?? this.sessions
  );
}