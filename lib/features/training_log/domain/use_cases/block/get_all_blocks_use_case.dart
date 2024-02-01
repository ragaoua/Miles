import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:miles/core/sorting.dart';

import '../../../../../core/failure.dart';
import '../../entities/block.dart';
import '../../repositories/repository.dart';

/// Use Case : get all blocks with their sessions
/// Inside each block, sessions are sorted by date then by id.
/// The block are sorted by latest session's date descending then by id descending.
class GetAllBlocksUseCase {
  final Repository repository;

  GetAllBlocksUseCase(this.repository);

  Stream<Either<Failure, List<BlockWithSessions>>> call() {
    final stream = repository.getAllBlocks();

    return stream.map((either) =>
      either.fold(
          (failure) => Left(failure),
          (blocks) => Right(
              blocks.map((block) => block.copy(
                  sessions: block.sessions.sortedByList([
                        (session) => session.date,
                        (session) => session.id
                  ]).toList()
              ))
              // Sort blocks by latest session's date descending then by id descending
                  .sortedByListDescending([
                    (block) => maxBy(block.sessions, (session) => session.date)?.date,
                    (block) => block.id
                  ]).toList()
          )
      )
    );
  }
}