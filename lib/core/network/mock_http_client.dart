import 'package:dio/dio.dart';
import 'package:eurocertifica_web/core/network/http_client.dart';

class MockHttpClient implements CustomHttpClient {
  final Duration mockDelay;

  MockHttpClient({this.mockDelay = const Duration(milliseconds: 500)});

  @override
  Future<Response> post(String path, {dynamic data}) async {
    // Simula delay de rede
    await Future.delayed(mockDelay);

    // Rotas mockadas
    if (path == '/auth/login') {
      final email = data['email'];
      final password = data['password'];

      if (email == 'admin@teste.com' && password == '123456') {
        return Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'id': 1,
              'email': email,
              'name': 'Admin User',
              'type': 'manager',
              'idDepartment': 101,
              'extraData': {
                'idTeams': [101, 103],
              }
            },
          },
        );
      }

      if (email == 'colaborador@teste.com' && password == '123456') {
        return Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'id': 2,
              'email': email,
              'name': 'Colaborador User',
              'type': 'collaborator',
              'idDepartment': 101,
              'extraData': {
                'points': 1000,
                'job': 'Desenvolvedor',
              }
            },
          },
        );
      }

      // Login inválido
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 401,
        data: {'success': false, 'message': 'Email ou senha inválidos'},
      );
    }

    // Rota não encontrada
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 404,
      data: {'message': 'Rota não encontrada'},
    );
  }

  @override
  Future<Response> get(String path) async {
    await Future.delayed(mockDelay);

    if (path == '/user/profile') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'id': '1',
            'email': 'admin@teste.com',
            'name': 'Admin User',
            'type': 'gestor',
          }
        },
      );
    }

    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 404,
      data: {'message': 'Rota não encontrada'},
    );
  }

  @override
  Future<Response> put(String path, {dynamic data}) async {
    await Future.delayed(mockDelay);
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'success': true, 'message': 'Atualizado com sucesso'},
    );
  }

  @override
  Future<Response> delete(String path) async {
    await Future.delayed(mockDelay);
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'success': true, 'message': 'Removido com sucesso'},
    );
  }
}
