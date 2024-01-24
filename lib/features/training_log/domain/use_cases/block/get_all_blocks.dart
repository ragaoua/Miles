import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:miles/core/sorting.dart';

import '../../../../../core/failure.dart';
import '../../entities/block.dart';
import '../../repositories/repository.dart';

/// Use Case : get all blocks with their sessions
/// Inside each block, sessions are sorted by date then by id.
/// The block are sorted by latest session's date descending then by id descending.
class GetAllBlocks {
  final Repository repository;

  GetAllBlocks(this.repository);

  Future<Either<Failure, List<BlockWithSessions>>> call() async {
    final result = await repository.getAllBlocks();

    return result.fold(
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
    );
  }
}