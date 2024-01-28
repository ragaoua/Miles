part of 'training_log_bloc.dart';

class TrainingLogUseCases {
  final GetAllBlocksUseCase getAllBlocks;
  final InsertBlockUseCase insertBlock;
  final UpdateBlockUseCase updateBlock;
  final DeleteBlockUseCase deleteBlock;
  final RestoreBlockUseCase restoreBlock;

  TrainingLogUseCases({required Repository repository}) :
        getAllBlocks = GetAllBlocksUseCase(repository),
        insertBlock = InsertBlockUseCase(repository),
        updateBlock = UpdateBlockUseCase(repository),
        deleteBlock = DeleteBlockUseCase(repository),
        restoreBlock = RestoreBlockUseCase(repository);
}