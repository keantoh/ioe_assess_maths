class UserDetails {
  final String email;
  final String username;

  UserDetails({
    required this.email,
    required this.username,
  });
}

class UserState {
  final UserDetails? userDetails;
  final bool isLoading;

  UserState({
    this.userDetails,
    this.isLoading = false,
  });

  UserState copyWith({UserDetails? userDetails, bool? isLoading}) {
    return UserState(
      userDetails: userDetails ?? this.userDetails,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
