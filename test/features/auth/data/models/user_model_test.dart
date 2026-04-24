import 'package:flutter_test/flutter_test.dart';
import 'package:eurocertifica_web/features/auth/data/models/user_model.dart';
import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    final tMap = {
      'id': 1,
      'email': 'teste@email.com',
      'name': 'João',
      'type': 'manager',
      'idDepartment': 5,
      'extraData': {'key': 'value'}
    };

    test('deve criar UserModel corretamente a partir de um Map', () {
      final model = UserModel.fromMap(tMap);

      expect(model.id, 1);
      expect(model.email, 'teste@email.com');
      expect(model.type, UserType.manager);
      expect(model.extraData, {'key': 'value'});
    });

    test('deve converter UserModel para Map', () {
      final model = UserModel.fromMap(tMap);
      final map = model.toMap();

      expect(map['id'], 1);
      expect(map['type'], 'UserType.manager');
    });

    test('deve suportar UserModel.fromEntity', () {
      const entity = User(
        id: 2,
        email: 'b@b.com',
        name: 'Maria',
        type: UserType.collaborator,
        idDepartment: 3,
      );
      final model = UserModel.fromEntity(entity);

      expect(model.id, 2);
      expect(model.name, 'Maria');
    });
  });
}
