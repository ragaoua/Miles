import 'package:equatable/equatable.dart';

/// Failure class
/// [msgKey] is the key of the message to display to the user.
/// The message is localized in the UI layer.
class Failure extends Equatable {
  final String msgKey;

  const Failure(this.msgKey);

  @override
  List<Object?> get props => [msgKey];
}