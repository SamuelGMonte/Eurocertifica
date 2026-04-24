import 'package:eurocertifica_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';
import 'package:eurocertifica_web/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> login(String email, String password) async {
    return await remoteDatasource.login(email, password);
  }

  @override
  Future<void> logout() async {
    return await remoteDatasource.logout();
  }
}
