import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/validate_block_name.dart';

import '../../../../../core/failure.dart';

/// Use Case : insert a block and its days and return the block.
/// If the name is blank or already used, return a Failure.
class InsertBlockUseCase {
  final Repository repository;

  InsertBlockUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required String name,
    required int nbDays
  }) async {
    final blockNameValidation = await validateBlockName(
        repository: repository,
        name: name
    );

    return blockNameValidation.fold(
      (failure) => Left(failure),
      (_) => repository.insertBlockAndDays(name, nbDays)
    );
  }
}