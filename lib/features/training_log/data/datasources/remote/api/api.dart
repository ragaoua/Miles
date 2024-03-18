import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/session.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';
part '../dto/block_dto.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @GET('/all_blocks')
  Future<List<BlockAndSessionDTO>> getAllBlocks();
}
