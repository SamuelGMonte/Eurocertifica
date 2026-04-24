import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';
import 'package:eurocertifica_web/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
