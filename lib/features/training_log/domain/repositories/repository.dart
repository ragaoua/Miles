import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entities/block.dart';

abstract class Repository {
  Future<Either<Failure, List<BlockWithSessions>>> getAllBlocks();
}