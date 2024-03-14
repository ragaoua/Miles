import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';

import '../../../../../core/failure.dart';

/// Use Case : insert a block and its days and return the block.
/// If the name is blank or already used, return a Failure.
class InsertBlockUseCase {
  final Repository repository;
  final BlockNameValidator blockNameValidator;

  InsertBlockUseCase({
    required this.repository,
    required this.blockNameValidator,
  });

  Future<Either<Failure, int>> call({
    required String name,
    required int nbDays,
  }) async {
    final blockNameValidationFailure = await blockNameValidator.validate(name);

    if (blockNameValidationFailure != null) {
      return Left(blockNameValidationFailure);
    }
    return repository.insertBlockAndDays(name, nbDays);
  }
}
