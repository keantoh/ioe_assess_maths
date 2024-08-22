import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:math_assessment/src/models/user.dart';
import 'package:math_assessment/src/notifiers/token_state_provider.dart';
import 'package:math_assessment/src/repositories/user_repository.dart';
import 'package:math_assessment/src/services/user_service.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';

class MockUserService extends Mock implements UserService {}

class MockUserRepository extends Mock implements UserRepository {}

class MockTokenManager extends Mock implements TokenManager {}

void main() {
  late MockUserService mockUserService;
  late MockUserRepository mockUserRepository;
  late MockTokenManager mockTokenManager;
  late ProviderContainer container;

  setUp(() {
    mockUserService = MockUserService();
    mockUserRepository = MockUserRepository();
    mockTokenManager = MockTokenManager();
    container = ProviderContainer(overrides: [
      userServiceProvider.overrideWithValue(mockUserService),
      userRepositoryProvider.overrideWithValue(mockUserRepository),
      tokenManagerProvider.overrideWithValue(mockTokenManager),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  test('loginUser sets state and saves token on successful login', () async {
    final user = UserLogin(email: 'test@test.com', password: 'password');
    final userLoginState = UserLoginState(
      userId: 'testId',
      email: 'test@test.com',
      firstName: 'tester',
      lastName: 'tester',
      country: 'GBR',
      isActive: true,
      isAdmin: true,
    );
    final response = {
      'status': 200,
      'response': {'token': 'mock_token'},
    };

    when(() => mockUserRepository.loginUser(user))
        .thenAnswer((_) async => response);
    when(() => mockTokenManager.saveToken(any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockUserRepository.userLoginState).thenReturn(userLoginState);

    final userStateNotifier = container.read(userStateProvider.notifier);
    await userStateNotifier.loginUser(user);

    verify(() => mockTokenManager.saveToken('mock_token')).called(1);
    expect(userStateNotifier.state, userLoginState);
    expect(container.read(userStateResponseCodeProvider), 200);
  });

  test('loginUser does not change state on failed login', () async {
    final user = UserLogin(email: 'unkown@test.com', password: 'password');
    final response = {'status': 404};

    when(() => mockUserRepository.loginUser(user))
        .thenAnswer((_) async => response);

    final userStateNotifier = container.read(userStateProvider.notifier);

    await userStateNotifier.loginUser(user);

    verifyNever(() => mockTokenManager.saveToken(any()));
    expect(userStateNotifier.state, isNull);
    expect(container.read(userStateResponseCodeProvider), 404);
  });
}
