import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_assessment/src/api/user_api.dart';
import 'package:math_assessment/src/models/user.dart';

class UserSearchNotifier extends StateNotifier<UserSearchResponse> {
  UserSearchNotifier()
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

  void search() async {
    state = UserSearchResponse(
      isSearching: true,
      searchQuery: state.searchQuery,
      users: state.users,
    );
    final List<UserSearch> retrievedUsers = [];
    final result = await searchUsers(state.searchQuery);
    if (result['status'] == 200 && result['message'] is List) {
      final List<dynamic> usersList = result['message'];
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

  void deleteUser(String userId) {
    state = UserSearchResponse(
      isSearching: state.isSearching,
      searchQuery: state.searchQuery,
      responseCode: state.responseCode,
      users: state.users.where((user) => user.userId != userId).toList(),
    );
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, UserSearchResponse>(
  (ref) => UserSearchNotifier(),
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
