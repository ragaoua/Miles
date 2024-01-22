import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entities/block.dart';

abstract class Repository {
  Future<Either<Failure, Block>> insertBlockAndDays(String name, int nbDays);
  Future<Failure?> updateBlock(Block block);
  Future<void> deleteBlock(Block block);
  Future<Either<Failure, List<BlockWithSessions>>> getAllBlocks();
  Future<Either<Failure, Block?>> getBlockByName(String name);
}