import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

import '../../../../../core/failure.dart';

/// Use Case : restore a block and any cascading relationships.
class RestoreBlockUseCase {
  final Repository repository;

  RestoreBlockUseCase(this.repository);

  Future<Failure?> call(BlockWithDays block) async {
    return await repository.restoreBlock(block);
  }
}