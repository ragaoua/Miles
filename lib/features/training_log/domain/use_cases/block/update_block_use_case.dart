import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';

import '../../../../../core/failure.dart';

/// Use Case : insert a block and its days and return the block.
/// If the name is blank or already used, return a Failure.
class UpdateBlockUseCase {
  final Repository repository;
  final BlockNameValidator blockNameValidator;

  UpdateBlockUseCase({
    required this.repository,
    required this.blockNameValidator,
  });

  Future<Failure?> call(Block block) async {
    final blockNameValidationFailure =
        await blockNameValidator.validate(block.name);

    return blockNameValidationFailure ?? await repository.updateBlock(block);
  }
}
