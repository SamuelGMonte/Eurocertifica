import '../entities/user.dart';
import '../repositories/learning_repository.dart';

class LoginUser {
  const LoginUser(this._repository);

  final LearningRepository _repository;

  Future<User> call({required String email, required String password}) {
    return _repository.login(email, password);
  }
}
