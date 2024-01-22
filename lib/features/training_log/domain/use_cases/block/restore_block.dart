import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

/// Use Case : restore a block and any cascading relationships.
class RestoreBlock {
  final Repository repository;

  RestoreBlock(this.repository);

  Future<void> call({required BlockWithSessions block}) async {
    repository.restoreBlock(block);
  }
}