import 'package:dartz/dartz.dart';
import 'package:miles/core/failure.dart';
import 'package:quiver/strings.dart';

import '../../../repositories/repository.dart';

/// Validate the block name.
/// If it is empty or already exists, return a Failure.
Future<Either<Failure, void>> validateBlockName({
  required Repository repository,
  required String name
}) async {
  if (isBlank(name)) return Left(BlockNameEmptyFailure());

  final blockByNameResult = await repository.getBlockByName(name);
  return blockByNameResult.fold(
    (failure) => Left(failure),
    (block) {
      if (block != null) {
        return Left(BlockNameAlreadyExistsFailure());
      } else {
        return const Right(null);
      }
    }
  );
}

class BlockNameEmptyFailure extends Failure {}
class BlockNameAlreadyExistsFailure extends Failure {}