import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entities/block.dart';

abstract class Repository {
  Future<Either<Failure, List<BlockWithSessions>>> getAllBlocks();

  Future<Either<Failure, Block?>> getBlockByName(String name);
  Future<Either<Failure, Block>> insertBlockAndDays(String name, int nbDays);
}