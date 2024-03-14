import 'package:miles/core/failure.dart';
import 'package:quiver/strings.dart';

import '../../../repositories/repository.dart';

class BlockNameValidator {
  final Repository repository;

  const BlockNameValidator({required this.repository});

  /// Validate a block's name.
  /// If it is empty or already exists, return a Failure.
  /// Else, returns null
  Future<Failure?> validate(String name) async {
    if (isBlank(name)) {
      return BlockNameEmptyFailure();
    }

    final blockByNameResult = await repository.getBlockByName(name);
    return blockByNameResult.fold(
      (failure) => failure,
      (block) {
        return block != null ? BlockNameAlreadyExistsFailure() : null;
      },
    );
  }
}

class BlockNameEmptyFailure extends Failure {}

class BlockNameAlreadyExistsFailure extends Failure {}
