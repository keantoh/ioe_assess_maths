class UserCreate {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String country;
  final bool isAdmin;

  UserCreate({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'isAdmin': isAdmin
      };
}

class UserLogin {
  final String email;
  final String password;

  UserLogin({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class UserUpdate {
  final String email;
  final String firstName;
  final String lastName;
  final String country;

  UserUpdate({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
      };
}

class UserPasswordUpdate {
  final String password;
  final String newPassword;

  UserPasswordUpdate({
    required this.password,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'password': password,
        'newPassword': newPassword,
      };
}

class UserLoginState {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String country;
  final bool isAdmin;
  final bool isActive;

  UserLoginState(
      {required this.userId,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.country,
      required this.isAdmin,
      required this.isActive});

  factory UserLoginState.fromJson(Map<String, dynamic> json) {
    return UserLoginState(
      userId: json['userId'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      country: json['country'] as String,
      isAdmin: json['isAdmin'] as bool,
      isActive: json['isActive'] as bool,
    );
  }

  UserLoginState copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? country,
    bool? isAdmin,
  }) {
    return UserLoginState(
      userId: userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive,
    );
  }
}
