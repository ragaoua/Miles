import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

import '../../../../../core/failure.dart';

/// Use Case : delete a block and any cascading relationships.
class DeleteBlock {
  final Repository repository;

  DeleteBlock(this.repository);

  Future<Failure?> call(Block block) async {
    return await repository.deleteBlock(block);
  }
}