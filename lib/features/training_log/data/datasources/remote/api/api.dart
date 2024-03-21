import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/entities/day.dart';
import 'package:retrofit/retrofit.dart';

part '../dto/block_dto.dart';
part '../dto/day_dto.dart';
part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @POST('/rpc/insert_block_with_days')
  @Headers({'Prefer': 'params=single-object'})
  Future<void> insertBlockWithDays(@Body() BlockWithDaysDTO block);
}
