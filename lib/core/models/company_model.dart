import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  final String? id;
  final String title;
  final String phone;
  final String fullName;
  final String email;
  final bool isActive;
  final Timestamp? createdAt;

  CompanyModel({
    this.id,
    required this.title,
    required this.phone,
    required this.fullName,
    required this.email,
    this.isActive = true,
    this.createdAt,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map, String docId) {
    return CompanyModel(
      id: docId,
      title: map['title'] ?? '',
      phone: map['phone'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'phone': phone,
      'fullName': fullName,
      'email': email,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
