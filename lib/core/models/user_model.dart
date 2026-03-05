import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, superAdmin, guide, participant }

class UserModel {
  final String? id;
  final String email;
  final String fullName;
  final String phone;
  final UserRole role;
  final String? companyId;
  final String? tourId;
  final bool isActive;
  final Timestamp? createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.companyId,
    this.tourId,
    this.isActive = true,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      id: docId,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.participant,
      ),
      companyId: map['companyId'],
      tourId: map['tourId'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role.name,
      'companyId': companyId,
      'tourId': tourId,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
