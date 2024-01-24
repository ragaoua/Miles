import 'package:equatable/equatable.dart';

class Movement extends Equatable {
  static const int defaultId = 0;
  static const String defaultName = "";

  final int id;
  final String name;

  const Movement({
    this.id = defaultId,
    this.name = defaultName
  });

  Movement copy({
    int? id,
    String? name
  }) {
    return Movement(
      id: id ?? this.id,
      name: name ?? this.name
    );
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}