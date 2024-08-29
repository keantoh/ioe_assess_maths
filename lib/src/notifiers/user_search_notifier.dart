import 'package:assess_math/src/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assess_math/src/models/user.dart';
import 'package:assess_math/src/services/user_service.dart';

class UserSearchNotifier extends StateNotifier<UserSearchResponse> {
  final UserService _userService;
  final Ref ref;
  UserSearchNotifier(this._userService, this.ref)
      : super(
            UserSearchResponse(isSearching: false, searchQuery: '', users: []));

  void setDefault() {
    state = UserSearchResponse(
      isSearching: false,
      searchQuery: '',
      responseCode: null,
      users: [],
    );
  }

  void setSearchQuery(String value) {
    state = UserSearchResponse(
      isSearching: state.isSearching,
      searchQuery: value,
      responseCode: state.responseCode,
      users: state.users,
    );
  }

  Future<void> searchUsers() async {
    state = UserSearchResponse(
      isSearching: true,
      searchQuery: state.searchQuery,
      users: state.users,
    );
    final List<UserSearch> retrievedUsers = [];
    final result = await _userService.searchUsersService(
        state.searchQuery, ref.read(userRepositoryProvider).token);

    if (result['status'] == 200 && result['response'] is List) {
      final List<dynamic> usersList = result['response'];
      retrievedUsers.addAll(usersList.map((user) {
        return UserSearch.fromJson(user);
      }).toList());
    }

    state = UserSearchResponse(
      isSearching: false,
      searchQuery: state.searchQuery,
      responseCode: result['status'],
      users: retrievedUsers,
    );
  }

  Future<void> deleteUser(String userId) async {
    final result = await _userService.deleteUserService(
        userId, ref.read(userRepositoryProvider).token);
    final responseCode = result['status'];
    state = UserSearchResponse(
      isSearching: state.isSearching,
      searchQuery: state.searchQuery,
      responseCode: responseCode,
      users: state.users.where((user) => user.userId != userId).toList(),
    );
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, UserSearchResponse>(
  (ref) {
    final userService = ref.watch(userServiceProvider);
    return UserSearchNotifier(userService, ref);
  },
);

class UserSearchResponse {
  final bool isSearching;
  final String searchQuery;
  final int? responseCode;
  final List<UserSearch> users;

  UserSearchResponse({
    required this.isSearching,
    required this.searchQuery,
    this.responseCode,
    required this.users,
  });
}
