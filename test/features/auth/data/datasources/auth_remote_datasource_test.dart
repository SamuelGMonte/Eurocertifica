import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:eurocertifica_web/core/network/http_client.dart';
import 'package:eurocertifica_web/features/auth/data/datasources/auth_remote_datasource.dart';

@GenerateMocks([CustomHttpClient])
import 'auth_remote_datasource_test.mocks.dart';

void main() {
  late MockCustomHttpClient mockHttpClient;
  late AuthRemoteDatasource datasource;

  setUp(() {
    mockHttpClient = MockCustomHttpClient();
    datasource = AuthRemoteDatasource(httpClient: mockHttpClient);
  });

  group('login', () {
    test('deve retornar User quando login for bem-sucedido', () async {
      when(mockHttpClient.post('/auth/login', data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 200,
                data: {
                  'data': {
                    'id': 10,
                    'email': 'joao@email.com',
                    'name': 'João',
                    'type': 'collaborator',
                    'idDepartment': 2,
                    'extraData': null,
                  }
                },
              ));

      final user = await datasource.login('joao@email.com', '123');

      expect(user.id, 10);
      expect(user.name, 'João');
    });

    test('deve lançar Exception quando statusCode não for 200', () async {
      when(mockHttpClient.post('/auth/login', data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/auth/login'),
                statusCode: 401,
                data: {'message': 'Credenciais inválidas'},
              ));

      expect(
        () => datasource.login('errado', 'senha'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'mensagem',
            contains('Credenciais inválidas'))),
      );
    });
  });
}
