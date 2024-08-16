import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:math_assessment/src/models/user.dart';
import 'package:math_assessment/src/notifiers/user_state_notifier.dart';

class UserUpdateNotifier extends StateNotifier<UserUpdate> {
  UserUpdateNotifier(super.state);

  void updateEmail(String email) {
    state = UserUpdate(
      email: email,
      firstName: state.firstName,
      lastName: state.lastName,
      country: state.country,
    );
  }

  void updateFirstName(String firstName) {
    state = UserUpdate(
      email: state.email,
      firstName: firstName,
      lastName: state.lastName,
      country: state.country,
    );
  }

  void updateLastName(String lastName) {
    state = UserUpdate(
      email: state.email,
      firstName: state.firstName,
      lastName: lastName,
      country: state.country,
    );
  }

  void updateCountry(String country) {
    state = UserUpdate(
      email: state.email,
      firstName: state.firstName,
      lastName: state.lastName,
      country: country,
    );
  }

  bool get hasChanges => state.hasChanges(originalDetails);

  UserUpdate originalDetails = UserUpdate(
    email: '',
    firstName: '',
    lastName: '',
    country: '',
  );

  void setOriginalDetails(UserUpdate details) {
    originalDetails = details;
  }
}

final userUpdateProvider =
    StateNotifierProvider<UserUpdateNotifier, UserUpdate>(
  (ref) {
    final userState = ref.watch(userStateProvider);
    final initialDetails = UserUpdate(
      email: userState?.email ?? '',
      firstName: userState?.firstName ?? '',
      lastName: userState?.lastName ?? '',
      country: userState?.country ?? '',
    );
    final notifier = UserUpdateNotifier(initialDetails);
    notifier.setOriginalDetails(initialDetails);
    return notifier;
  },
);
