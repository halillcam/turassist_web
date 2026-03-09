import '../../domain/entities/user_entity.dart';

/// Firebase / Firestore'dan gelen ham veriyi temsil eden DTO.
/// Domain katmanındaki [UserEntity]'den bağımsızdır; [toEntity()] ile dönüştürülür.
class AuthUserModel {
  final String id;
  final String email;
  final String name;

  /// Firestore'daki ham rol string'i: 'admin' | 'super_admin'
  final String roleRaw;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.roleRaw,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json, String docId) {
    return AuthUserModel(
      id: docId,
      email: json['email'] as String? ?? '',
      name: json['fullName'] as String? ?? '',
      roleRaw: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'email': email, 'fullName': name, 'role': roleRaw};

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, name: name, role: _mapRole(roleRaw));
  }

  static UserRole _mapRole(String raw) {
    switch (raw) {
      case 'super_admin':
        return UserRole.superAdmin;
      default:
        return UserRole.admin;
    }
  }
}
