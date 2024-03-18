import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:miles/features/training_log/data/datasources/remote/api/api.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';

import '../features/training_log/data/datasources/local/database/database.dart';
import '../features/training_log/data/repositories/repository_impl.dart';
import '../features/training_log/presentation/bloc/training_log_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(
    () => TrainingLogBloc(useCases: sl()),
  );
  sl.registerLazySingleton(
    () => TrainingLogUseCases(repository: sl(), blockNameValidator: sl()),
  );
  sl.registerLazySingleton(
    () => BlockNameValidator(repository: sl()),
  );

  // Repository, database and API
  sl.registerLazySingleton<Repository>(
    () => RepositoryImpl(db: sl(), api: sl()),
  );
  sl.registerLazySingleton<Database>(
    () => Database(openConnection()),
  );
  sl.registerLazySingleton(
    () => Api(Dio(BaseOptions(baseUrl: "http://127.0.0.1:3000/"))),
  );
}
