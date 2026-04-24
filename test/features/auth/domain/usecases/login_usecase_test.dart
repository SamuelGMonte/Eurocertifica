import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';
import 'package:eurocertifica_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:eurocertifica_web/features/auth/domain/usecases/login_usecase.dart';

@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late LoginUsecase usecase;

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = LoginUsecase(mockRepo);
  });

  test('deve retornar User com sucesso', () async {
    const tEmail = 'x@x.com';
    const tPassword = '123';
    const tUser = User(
        id: 99,
        email: tEmail,
        name: 'User',
        type: UserType.manager,
        idDepartment: 1);

    when(mockRepo.login(tEmail, tPassword)).thenAnswer((_) async => tUser);

    final result = await usecase(tEmail, tPassword);
    expect(result, tUser);
  });
}
