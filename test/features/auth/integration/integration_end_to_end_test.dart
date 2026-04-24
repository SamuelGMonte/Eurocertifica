import 'package:flutter_test/flutter_test.dart';
import 'package:eurocertifica_web/core/network/mock_http_client.dart';
import 'package:eurocertifica_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:eurocertifica_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eurocertifica_web/features/auth/domain/usecases/login_usecase.dart';

void main() {
  test(
      'Integração completa: LoginUsecase -> Repository -> Datasource -> MockClient',
      () async {
    final mockClient = MockHttpClient();
    final datasource = AuthRemoteDatasource(httpClient: mockClient);
    final repository = AuthRepositoryImpl(remoteDatasource: datasource);
    final usecase = LoginUsecase(repository);

    final user = await usecase('colaborador@teste.com', '123456');

    expect(user.name, 'Colaborador User');
    expect(user.extraData, containsPair('points', 1000));
  });
}
