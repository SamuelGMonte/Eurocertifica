import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:eurocertifica_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:eurocertifica_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';

@GenerateMocks([AuthRemoteDatasource])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(remoteDatasource: mockDatasource);
  });

  test('login deve chamar remoteDatasource.login', () async {
    const tEmail = 'a@a.com';
    const tPassword = '123';
    final tUser = User(
      id: 1,
      email: tEmail,
      name: 'Any',
      type: UserType.collaborator,
      idDepartment: 1,
    );

    when(mockDatasource.login(tEmail, tPassword))
        .thenAnswer((_) async => tUser);

    final result = await repository.login(tEmail, tPassword);

    expect(result, tUser);
    verify(mockDatasource.login(tEmail, tPassword)).called(1);
  });
}
