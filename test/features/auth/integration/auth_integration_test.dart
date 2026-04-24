import 'package:flutter_test/flutter_test.dart';
import 'package:eurocertifica_web/core/network/mock_http_client.dart';
import 'package:eurocertifica_web/features/auth/data/datasources/auth_remote_datasource.dart';

void main() {
  group('Integração AuthRemoteDatasource + MockHttpClient', () {
    final mockClient = MockHttpClient(mockDelay: Duration.zero);
    final datasource = AuthRemoteDatasource(httpClient: mockClient);

    test('login com credenciais corretas de manager', () async {
      final user = await datasource.login('admin@teste.com', '123456');

      expect(user.email, 'admin@teste.com');
      expect(user.type.toString(), 'UserType.manager');
      expect(user.extraData, containsPair('idTeams', [101, 103]));
    });

    test('login com credenciais inválidas lança exceção', () {
      expect(
        () => datasource.login('x@x.com', 'senhaerrada'),
        throwsA(isA<Exception>()
            .having((e) => e.toString(), 'msg', contains('inválidos'))),
      );
    });
  });
}
