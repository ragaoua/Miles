import 'package:get_it/get_it.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';

import '../features/training_log/data/datasources/local/database/database.dart';
import '../features/training_log/data/repositories/repository_impl.dart';
import '../features/training_log/presentation/bloc/training_log_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() =>
      TrainingLogBloc(useCases: sl())
  );
  sl.registerLazySingleton(() =>
      TrainingLogUseCases(repository: sl())
  );

  // Repository and database
  sl.registerLazySingleton<Repository>(() => RepositoryImpl(db: sl()));
  sl.registerLazySingleton<Database>(() => Database(openConnection()));
}