import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

/// Use Case : delete a block and any cascading relationships.
class DeleteBlock {
  final Repository repository;

  DeleteBlock(this.repository);

  Future<void> call({required Block block}) async {
    repository.deleteBlock(block);
  }
}