part of 'training_log_bloc.dart';

class TrainingLogUseCases {
  final GetAllBlocksUseCase getAllBlocks;
  final InsertBlockUseCase insertBlock;
  final UpdateBlockUseCase updateBlock;
  final DeleteBlockUseCase deleteBlock;
  final RestoreBlockUseCase restoreBlock;

  TrainingLogUseCases({
    required Repository repository,
    required BlockNameValidator blockNameValidator,
  })  : getAllBlocks = GetAllBlocksUseCase(repository),
        insertBlock = InsertBlockUseCase(
          repository: repository,
          blockNameValidator: blockNameValidator,
        ),
        updateBlock = UpdateBlockUseCase(
          repository: repository,
          blockNameValidator: blockNameValidator,
        ),
        deleteBlock = DeleteBlockUseCase(repository),
        restoreBlock = RestoreBlockUseCase(repository);
}
