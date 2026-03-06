import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  /// Firebase Auth belge ID'si.
  final String? uid;
  final String fullName;
  final String email;
  final String phone;

  /// Kullanıcı rolü: 'customer' | 'guide' | 'admin' | 'super_admin'.
  final String role;

  /// Kullanıcının bağlı olduğu şirketin ID'si (guide ve admin için).
  final String companyId;

  /// Kullanıcının erişim yetkisi olan şirket ID listesi.
  final List<String> registeredCompanies;

  final String tcNo;

  /// Profil fotoğrafı URL'si (opsiyonel).
  final String? profileImage;

  /// Kullanıcının son seçtiği çıkış şehri.
  final String selectedCity;

  /// Soft-delete bayrağı; true ise kullanıcı silinmiş kabul edilir.
  final bool isDeleted;

  final DateTime? createdAt;

  UserModel({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.companyId = '',
    this.registeredCompanies = const [],
    this.tcNo = '',
    this.profileImage,
    this.selectedCity = '',
    this.isDeleted = false,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      companyId: map['companyId'] ?? '',
      registeredCompanies: List<String>.from(map['registeredCompanies'] ?? []),
      tcNo: map['tcNo'] ?? '',
      profileImage: map['profileImage'],
      selectedCity: map['selectedCity'] ?? '',
      isDeleted: map['isDeleted'] ?? false,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'companyId': companyId,
      'registeredCompanies': registeredCompanies,
      'tcNo': tcNo,
      'profileImage': profileImage,
      'selectedCity': selectedCity,
      'isDeleted': isDeleted,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
