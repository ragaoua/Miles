import 'package:dartz/dartz.dart';
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
      return db.insertBlockAndDays(name, nbDays).then(Right.new);
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

  @override
  Future<
          Either<
              Failure,
              List<
                  DayWithSessions<
                      SessionWithExercises<ExerciseWithMovementAndSets>>>>>
      getDaysByBlockId(blockId) {
    // TODO: implement getDaysByBlockId
    throw UnimplementedError();
  }
}
