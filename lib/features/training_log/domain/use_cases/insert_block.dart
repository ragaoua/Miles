import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:quiver/strings.dart';

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
    if(isBlank(name)) {
      return const Left(
          Failure("block_name_cannot_be_empty")
      );
    }

    final blockByNameResult = await repository.getBlockByName(name);
    return blockByNameResult.fold(
        (failure) => Left(failure),
        (block) async {
          if(block != null) {
            return const Left(Failure("block_name_is_already_used"));
          }

          final insertBlockResult = await repository.insertBlockAndDays(name, nbDays);

          return insertBlockResult.fold(
              (failure) => Left(failure),
              (block) => Right(block)
          );
        }
    );
  }
}