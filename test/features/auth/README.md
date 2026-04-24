# Testes de Autenticação - Eurocertifica

## 📋 Estrutura de Testes

```
test/features/auth/
├── domain/
│   ├── entities/
│   │   └── user_entity_test.dart          # Testes da entidade User
│   └── usecases/
│       └── login_usecase_test.dart        # Testes do caso de uso Login
├── data/
│   ├── models/
│   │   └── user_model_test.dart           # Testes do modelo UserModel
│   ├── repositories/
│   │   └── auth_repository_impl_test.dart # Testes da implementação do repositório
│   └── datasources/
│       └── auth_remote_datasource_test.dart # Testes da fonte de dados remota
└── integration/
    └── auth_integration_test.dart         # Testes end-to-end
```

## 🧪 Tipos de Testes

### 1. **Testes Unitários**
- `user_entity_test.dart` - Validação de criação e igualdade de usuários
- `login_usecase_test.dart` - Validação da lógica de negócio de login
- `user_model_test.dart` - Conversão de dados (toMap, fromMap, toJson, fromJson)
- `auth_repository_impl_test.dart` - Delegação correta ao datasource
- `auth_remote_datasource_test.dart` - Chamadas HTTP corretas

### 2. **Testes de Integração**
- `auth_integration_test.dart` - Fluxo completo de autenticação (login + logout)

## ⚙️ Executar Testes

### Todos os testes de autenticação:
```bash
flutter test test/features/auth/
```

### Apenas testes unitários:
```bash
flutter test test/features/auth/domain/
flutter test test/features/auth/data/
```

### Apenas testes de integração:
```bash
flutter test test/features/auth/integration/
```

### Teste específico:
```bash
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

### Com cobertura de testes:
```bash
flutter test test/features/auth/ --coverage
```

## 📊 Casos de Teste Cobertos

### User Entity
- ✅ Criação de usuário colaborador com factory
- ✅ Criação de usuário gerente com factory
- ✅ Validação de igualdade entre usuários
- ✅ Validação de diferença entre usuários

### Login Usecase
- ✅ Retorna User ao fazer login com sucesso
- ✅ Lança exceção em credenciais inválidas
- ✅ Passa parâmetros corretos ao repositório
- ✅ Trata erros de rede

### User Model
- ✅ É uma subclasse de User
- ✅ Converte para Map corretamente
- ✅ Cria instância a partir de Map
- ✅ Cria instância a partir de User entity
- ✅ Método copyWith funciona corretamente
- ✅ Serialização JSON funciona

### Auth Repository Impl
- ✅ Login retorna User do datasource
- ✅ Login trata exceções
- ✅ Logout chama datasource
- ✅ Logout trata exceções

### Auth Remote Datasource
- ✅ Login com status 200 retorna UserModel
- ✅ Status de erro lança exceção
- ✅ Erros de rede lançam exceção
- ✅ Logout chama endpoint correto

### Integração
- ✅ Fluxo completo de login funciona
- ✅ Credenciais inválidas falham
- ✅ Múltiplas tentativas de login
- ✅ Fluxo login + logout
- ✅ Erros de rede se propagam
- ✅ Email vazio falha
- ✅ Senha vazia falha

## 🔧 Dependências Necessárias

Adicione ao `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^6.0.0
  build_runner: ^2.0.0
```

Gere os mocks:
```bash
flutter pub run build_runner build
```

## 📝 Exemplo de Execução

```bash
$ flutter test test/features/auth/

✓ User Entity › User.collaborator factory creates user with correct data
✓ User Entity › User.manager factory creates user with correct data
✓ User Entity › User equality works correctly
✓ User Entity › User with different IDs are not equal
✓ LoginUsecase › should return User when login is successful
✓ LoginUsecase › should throw Exception when login fails
✓ LoginUsecase › should pass correct parameters to repository
✓ UserModel › should be a subclass of User entity
✓ UserModel › toMap should return a map with correct data
✓ UserModel › fromMap should create a UserModel from map
✓ AuthRepositoryImpl › login › should return User when datasource returns a user
✓ AuthRepositoryImpl › logout › should call datasource logout
✓ AuthRemoteDatasource › login › should return UserModel when login is successful
✓ AuthRemoteDatasource › logout › should call http client PUT /auth/logout
✓ Auth Integration Tests › Complete login flow should succeed
✓ Auth Integration Tests › Multiple login attempts should work
✓ Auth Integration Tests › Login followed by logout flow

All tests passed! (17 tests)
```

## 🎯 Coverage Esperado

- **User Entity**: 95%+
- **Login Usecase**: 100%
- **User Model**: 90%+
- **Auth Repository**: 100%
- **Auth Remote Datasource**: 90%+
- **Integração**: 85%+

## 🚀 Próximos Passos

1. Execute os testes: `flutter test test/features/auth/`
2. Verifique a cobertura: `flutter test test/features/auth/ --coverage`
3. Corrija qualquer falha
4. Integre com CI/CD para testes automáticos

## 📚 Referências

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Clean Architecture Testing](https://resocoder.com/flutter-clean-architecture)
