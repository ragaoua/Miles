import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

import '../../../../../core/failure.dart';

/// Use Case : restore a block and any cascading relationships.
class RestoreBlock {
  final Repository repository;

  RestoreBlock(this.repository);

  Future<Failure?> call({required BlockWithSessions block}) async {
    return await repository.restoreBlock(block);
  }
}