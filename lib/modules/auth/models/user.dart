class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int? favoriteTeamId;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final double balance;
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.favoriteTeamId,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.balance,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      favoriteTeamId: json['favoriteTeamId'] as int?,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      balance: (json['balance'] as num).toDouble(),
      token: json['token'] as String?,
    );
  }

  // Convert from API response
  factory User.fromApi(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? 0,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      favoriteTeamId: data['favoriteTeamId'],
      phoneNumber: data['phoneNumber'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null 
          ? DateTime.parse(data['dateOfBirth'].toString())
          : DateTime.now(),
      balance: (data['balance'] ?? 0.0).toDouble(),
      token: data['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'favoriteTeamId': favoriteTeamId,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'balance': balance,
      'token': token,
    };
  }

  // Getter for backward compatibility
  String get nickname => username;
}
