class Users {
  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profileLink,
    required this.about,
  });

  String id;
  String username;
  String email;
  String password;
  String? profileLink;
  String about;

  /// Convert a `Users` object to a `Map<String, dynamic>`
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profileLink': profileLink,
      'about': about,
    };
  }

  /// Create a `Users` object from a `Map<String, dynamic>`
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      profileLink: map['profileLink'] as String?,
      about: map['about'] as String,
    );
  }

  /// Create a copy of the `Users` object with updated fields
  Users copyWith({
    String? username,
    String? email,
    String? password,
    String? about,
    String? profileLink,
  }) {
    return Users(
      id: id, // ID should remain unchanged
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      profileLink: profileLink ?? this.profileLink,
      about: about ?? this.about,
    );
  }
}
