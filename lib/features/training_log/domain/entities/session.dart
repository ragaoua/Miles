import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final int id;
  final int dayId;
  final DateTime date;

  const Session({
    this.id = 0,
    this.dayId = 0,
    required this.date
  });

  @override
  List<Object?> get props => [id, dayId, date];
}