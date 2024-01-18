import 'package:equatable/equatable.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

class Block extends Equatable {
  static const int defaultId = 0;
  static const String defaultName = "";

  final int id;
  final String name;

  const Block({
    this.id = defaultId,
    this.name = defaultName
  });

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}

class BlockWithSessions<T extends Session> extends Block {
  final List<T> sessions;

  const BlockWithSessions({
    id = Block.defaultId,
    name = Block.defaultName,
    required this.sessions
  }): super(id: id, name: name);
}