import 'package:dartz/dartz.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:miles/features/training_log/domain/entities/exercise.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';

import '../../../../core/failure.dart';
import '../entities/block.dart';

abstract class Repository {
  Future<Either<Failure, Block>> insertBlockAndDays(String name, int nbDays);
  Future<Failure?> updateBlock(Block block);
  Future<Failure?> deleteBlock(Block block);
  Future<Failure?> restoreBlock(BlockWithDays block);
  Stream<Either<Failure, List<BlockWithSessions>>> getAllBlocks();
  Future<Either<Failure, Block?>> getBlockByName(String name);

  Future<Either<
      Failure,
      List<DayWithSessions<SessionWithExercises<ExerciseWithMovementAndSets>>>
  >> getDaysByBlockId(blockId);
}