import '../entities/learning_state.dart';
import '../repositories/learning_repository.dart';

class LoadLearningState {
  const LoadLearningState(this._repository);

  final LearningRepository _repository;

  Future<LearningState> call() => _repository.loadState();
}
