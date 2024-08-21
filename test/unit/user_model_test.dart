import 'package:math_assessment/src/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('UserLoginState Class', () {
    test('fromJson works correctly', () {
      final json = {
        'userId': 'testId',
        'email': 'test@test.com',
        'firstName': 'Bob',
        'lastName': 'Ross',
        'country': 'GBR',
        'isActive': true,
        'isAdmin': true
      };

      final fromJsonUser = UserLoginState.fromJson(json);

      expect(fromJsonUser.firstName, equals('Bob'));
      expect(fromJsonUser.isActive, equals(true));
    });

    test('copyWith creates a copy with specified values', () {
      final user1 = UserLoginState(
          userId: 'testId',
          email: 'test@test.com',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR',
          isActive: true,
          isAdmin: true);

      final user2 = user1.copyWith(firstName: 'Chris');

      expect(user2.firstName, equals('Chris'));
      expect(user2.userId, equals(user1.userId));
    });
  });

  group('UserCreate Class', () {
    test('toJson works correctly', () {
      final user = UserCreate(
          email: 'test@test.com',
          password: 'securedpw',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR',
          isAdmin: true);

      final json = user.toJson();
      expect(json, {
        'email': 'test@test.com',
        'password': 'securedpw',
        'firstName': 'Bob',
        'lastName': 'Ross',
        'country': 'GBR',
        'isAdmin': true
      });
    });
  });

  group('UserLogin Class', () {
    test('toJson works correctly', () {
      final user = UserLogin(email: 'test@test.com', password: 'securedpw');

      final json = user.toJson();
      expect(json, {
        'email': 'test@test.com',
        'password': 'securedpw',
      });
    });
  });

  group('UserUpdate Class', () {
    test('hasChanges returns true if any field is different', () {
      final user1 = UserUpdate(
          email: 'test@test.com',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR');

      final user2 = UserUpdate(
          email: 'test@test.com',
          firstName: 'Chris',
          lastName: 'Ross',
          country: 'GBR');

      expect(user1.hasChanges(user2), isTrue);
    });

    test('hasChanges returns false if all fields are identical', () {
      final user1 = UserUpdate(
          email: 'test@test.com',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR');

      final user2 = UserUpdate(
          email: 'test@test.com',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR');

      expect(user1.hasChanges(user2), isFalse);
    });
    test('toJson works correctly', () {
      final user = UserUpdate(
          email: 'test@test.com',
          firstName: 'Bob',
          lastName: 'Ross',
          country: 'GBR');

      final json = user.toJson();
      expect(json, {
        'email': 'test@test.com',
        'firstName': 'Bob',
        'lastName': 'Ross',
        'country': 'GBR',
      });
    });
  });

  group('UserPasswordChange Class', () {
    test('toJson works correctly', () {
      final user = UserPasswordChange(
          password: 'securedpw', newPassword: 'moresecuredpw');

      final json = user.toJson();
      expect(json, {'password': 'securedpw', 'newPassword': 'moresecuredpw'});
    });
  });

  group('UserPasswordUpdate Class', () {
    test('toJson works correctly', () {
      final user = UserPasswordUpdate(
          email: 'test@test.com',
          token: 'ABCDEFGH',
          newPassword: 'moresecuredpw');

      final json = user.toJson();
      expect(json, {
        'email': 'test@test.com',
        'token': 'ABCDEFGH',
        'newPassword': 'moresecuredpw'
      });
    });
  });

  group('UserAccountDelete Class', () {
    test('toJson works correctly', () {
      final user = UserAccountDelete(userId: 'testId', password: 'securedpw');

      final json = user.toJson();
      expect(json, {'userId': 'testId', 'password': 'securedpw'});
    });
  });

  group('UserSearch Class', () {
    test('fromjson works correctly', () {
      final json = {
        'userId': 'testId',
        'email': 'test@test.com',
        'firstName': 'Bob',
        'lastName': 'Ross',
        'country': 'GBR',
        'isActive': true,
        'isAdmin': true,
        'createdAt': '2024-07-25 10:25:36.3778330',
      };

      final fromJsonUserSearch = UserSearch.fromJson(json);
      expect(fromJsonUserSearch.firstName, equals('Bob'));
      expect(fromJsonUserSearch.isAdmin, equals(true));
    });
  });
}
