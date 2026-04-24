import 'package:dio/dio.dart';
import 'package:eurocertifica_web/core/network/http_client.dart';
import 'package:eurocertifica_web/features/auth/data/models/user_model.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';

class AuthRemoteDatasource {
  final CustomHttpClient httpClient;

  AuthRemoteDatasource({required this.httpClient});

  Future<User> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromMap(response.data['data'] as Map<String, dynamic>);
      } else {
        throw Exception(response.data['message'] ?? 'Erro no login');
      }
    } catch (e) {
      throw Exception('Falha na comunicação: $e');
    }
  }

  Future<void> logout() async {
    try {
      await httpClient.put('/auth/logout');
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
