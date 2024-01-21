import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/helpers/validate_block_name.dart';

import '../../../../core/failure.dart';

/// Use Case : insert a block and its days and return the block.
/// If the name is blank or already used, return a Failure.
class InsertBlock {
  final Repository repository;

  InsertBlock(this.repository);

  Future<Either<Failure, Block>> call({
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