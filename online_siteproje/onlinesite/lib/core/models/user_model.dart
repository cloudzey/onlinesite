class UserModel {
  final int userId; // Diyagrama göre user_id (int)
  final String name;
  final String surname;
  final String email;
  final String role; // isAdmin yerine 'admin' veya 'customer' string rolü

  UserModel({
    required this.userId,
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
  });

  // Admin olup olmadığını kolayca kontrol etmek için yardımcı bir fonksiyon
  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'surname': surname,
      'email': email,
      'role': role,
    };
  }
}