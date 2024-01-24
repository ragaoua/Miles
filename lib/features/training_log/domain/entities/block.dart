import 'package:equatable/equatable.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

import 'day.dart';

class Block extends Equatable {
  static const int defaultId = 0;
  static const String defaultName = "";

  final int id;
  final String name;

  const Block({
    this.id = defaultId,
    this.name = defaultName
  });

  Block copy({
    int? id,
    String? name
  }) => Block(
    id: id ?? this.id,
    name: name ?? this.name
  );

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}

class BlockWithDays<T extends Day> extends Block {
  final List<T> days;

  const BlockWithDays({
    id = Block.defaultId,
    name = Block.defaultName,
    required this.days
  }): super(id: id, name: name);
}

class BlockWithSessions<T extends Session> extends Block {
  final List<T> sessions;

  const BlockWithSessions({
    id = Block.defaultId,
    name = Block.defaultName,
    required this.sessions
  }): super(id: id, name: name);

  @override
  BlockWithSessions<T> copy({
    int? id,
    String? name,
    List<T>? sessions
  }) => BlockWithSessions(
    id: id ?? this.id,
    name: name ?? this.name,
    sessions: sessions ?? this.sessions
  );
}