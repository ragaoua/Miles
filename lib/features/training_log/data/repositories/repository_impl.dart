import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/data/datasources/remote/api/api.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

import '../../../../core/failure.dart';
import '../../domain/entities/block.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/local/database/database.dart';

class RepositoryImpl implements Repository {
  final Database db;
  final Api api;

  RepositoryImpl({required this.db, required this.api});

  @override
  Future<Either<Failure, int>> insertBlockAndDays(
    String name,
    int nbDays,
  ) async {
    try {
      final block = await db.insertBlockAndDays(name, nbDays);

      // TODO - handle cases where :
      // - The API is not reachable
      // - the API call fails
      api.insertBlockWithDays(BlockWithDaysDTO.fromEntity(block));
      return Right(block.id);
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

  /// Get all blocks with their sessions
  /// The block are sorted by latest session descending then by id descending.
  /// For each block, sessions are sorted by date then by id.
  @override
  Stream<Either<Failure, List<BlockWithSessions>>> getAllBlocks() {
    try {
      return db.getAllBlocks().map(Right.new);
    } catch (e) {
      return Stream.value(Left(DatabaseFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Block?>> getBlockByName(String name) {
    try {
      return db.getBlockByName(name).then(Right.new);
    } catch (e) {
      return Future.value(Left(DatabaseFailure(e.toString())));
    }
  }

  /// Retrieve a list of days for a given block.
  /// Days are sorted by order.
  /// Each day's sessions are sorted by date then by id
  /// Each session's exercises are sorted by order then by supersetOrder
  /// Each exercise's sets are sorted by order
  /// Returns a [DatabaseFailure] if an exception is thrown by the database
  @override
  Future<
          Either<
              Failure,
              List<
                  DayWithSessions<
                      SessionWithExercises<ExerciseWithMovementAndSets>>>>>
      getDaysByBlockId(blockId) {
    try {
      return db.getDaysByBlockId(blockId).then(Right.new);
    } catch (e) {
      return Future.value(Left(DatabaseFailure(e.toString())));
    }
  }
}
