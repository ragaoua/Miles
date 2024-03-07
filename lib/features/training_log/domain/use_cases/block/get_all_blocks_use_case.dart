import 'package:dartz/dartz.dart';

import '../../../../../core/failure.dart';
import '../../entities/block.dart';
import '../../repositories/repository.dart';

/// Use Case : get all blocks with their sessions
/// The block are sorted by latest session descending then by id descending.
/// For each block, sessions are sorted by date then by id.
class GetAllBlocksUseCase {
  final Repository repository;

  GetAllBlocksUseCase(this.repository);

  Stream<Either<Failure, List<BlockWithSessions>>> call() {
    final stream = repository.getAllBlocks();

    return stream.map(
      (either) => either.fold(
        (failure) => Left(failure),
        (blocks) => Right(blocks),
      ),
    );
  }
}
