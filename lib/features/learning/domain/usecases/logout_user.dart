import '../repositories/learning_repository.dart';

class LogoutUser {
  const LogoutUser(this._repository);

  final LearningRepository _repository;

  Future<void> call() => _repository.clearUser();
}
