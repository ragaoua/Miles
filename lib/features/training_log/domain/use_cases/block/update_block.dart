import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/validate_block_name.dart';

import '../../../../../core/failure.dart';

/// Use Case : insert a block and its days and return the block.
/// If the name is blank or already used, return a Failure.
class UpdateBlock {
  final Repository repository;

  UpdateBlock(this.repository);

  Future<Failure?> call(Block block) async {
    final blockNameValidation = await validateBlockName(
        repository: repository,
        name: block.name
    );

    return blockNameValidation.fold(
      (failure) => failure,
      (_) async => await repository.updateBlock(block)
    );
  }
}