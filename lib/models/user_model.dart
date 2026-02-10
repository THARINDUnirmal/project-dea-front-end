class UserModel {
  final num userId;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? 0,
      name: json['userName'] ?? '',
      email: json['userEmail'] ?? '',
      role: json['role'] ?? 'User',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": name,
      "userEmail": email,
      "role": role,
    };
  }
}
