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
    this.name = defaultName,
  });

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}

class BlockWithDays<T extends Day> extends Block {
  final List<T> days;

  const BlockWithDays({
    super.id = Block.defaultId,
    super.name = Block.defaultName,
    required this.days,
  });

  @override
  List<Object?> get props => [...super.props, days];
}

class BlockWithSessions<T extends Session> extends Block {
  final List<T> sessions;

  const BlockWithSessions({
    super.id = Block.defaultId,
    super.name = Block.defaultName,
    required this.sessions,
  });

  @override
  List<Object?> get props => [...super.props, sessions];
}
