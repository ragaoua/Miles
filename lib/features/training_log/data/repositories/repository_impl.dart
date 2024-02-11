import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

import '../../../../core/failure.dart';
import '../../domain/entities/block.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/local/database/database.dart';

class RepositoryImpl implements Repository {

  final Database db;

  RepositoryImpl({required this.db});

  @override
  Future<Either<Failure, int>> insertBlockAndDays(String name, int nbDays) {
    try {
      return db.transaction(() async =>
        await db.into(db.blockDAO).insert(BlockDAOCompanion(
            name: Value(name)
        )).then((blockId) {
          for (var dayOrder = 1; dayOrder <= nbDays; dayOrder++) {
            db.into(db.dayDAO).insert(DayDAOCompanion(
                blockId: Value(blockId),
                order: Value(dayOrder)
            ));
          }

          return Right(blockId);
        })
      );
    } catch (e) {
      return Future.value(Left(DatabaseFailure(e.toString())));
    }
  }

  @override
  Future<Failure?> updateBlock(Block block) {
    // TODO: implement updateBlock
    throw UnimplementedError();
  }

  @override
  Future<Failure?> deleteBlock(Block block) {
    // TODO: implement deleteBlock
    throw UnimplementedError();
  }

  @override
  Future<Failure?> restoreBlock(BlockWithDays<Day> block) {
    // TODO: implement restoreBlock
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<BlockWithSessions>>> getAllBlocks() {
    try {
      return db.select(db.blockDAO)
          .join([
            leftOuterJoin(db.dayDAO, db.dayDAO.blockId.equalsExp(db.blockDAO.id)),
            leftOuterJoin(db.sessionDAO, db.sessionDAO.dayId.equalsExp(db.dayDAO.id))
          ])
          .watch()
          .map((rows) => Right(
              _mapRowsToBlockWithSessionsList(rows)
          ));
    } catch (e) {
      return Stream.value(Left(DatabaseFailure(e.toString())));
    }
  }

  List<BlockWithSessions> _mapRowsToBlockWithSessionsList(List<TypedResult> rows) {
    final Map<Block, List<Session>> blockSessionsMap = {};
    for (final row in rows) {
      final block = row.readTable(db.blockDAO);
      final session = row.readTableOrNull(db.sessionDAO);
      if (session != null) {
        blockSessionsMap.putIfAbsent(block, () => []).add(session);
      } else {
        blockSessionsMap.putIfAbsent(block, () => []);
      }
    }

    return blockSessionsMap.entries.map((entries) {
      final block = entries.key;
      final sessions = entries.value;
      return BlockWithSessions(
          id: block.id,
          name: block.name,
          sessions: sessions
      );
    }).toList();
  }

  @override
  Future<Either<Failure, Block?>> getBlockByName(String name) {
    try {
      return (
          db.select(db.blockDAO)
            ..where((block) => block.name.equals(name))
      ).getSingleOrNull().then((block) => Right(block));
    } catch (e) {
      return Future.value(Left(DatabaseFailure(e.toString())));
    }
  }

  @override
  Future<Either<
      Failure,
      List<DayWithSessions<SessionWithExercises<ExerciseWithMovementAndSets>>>
  >> getDaysByBlockId(blockId) {
    // TODO: implement getDaysByBlockId
    throw UnimplementedError();
  }

}