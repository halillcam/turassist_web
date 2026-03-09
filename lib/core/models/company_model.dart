import 'package:cloud_firestore/cloud_firestore.dart';

bool _asBool(dynamic value, {bool fallback = true}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'evet':
        return true;
      case 'false':
      case '0':
      case 'no':
      case 'hayir':
      case 'hayır':
        return false;
    }
  }
  return fallback;
}

class CompanyModel {
  final String? id;
  final String companyName;
  final String city;
  final String contactPhone;
  final String logo;
  final String adminUid;
  final bool status;
  final Timestamp? createdAt;

  CompanyModel({
    this.id,
    required this.companyName,
    required this.city,
    required this.contactPhone,
    this.logo = '',
    required this.adminUid,
    this.status = true,
    this.createdAt,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map, String docId) {
    return CompanyModel(
      id: docId,
      companyName: map['companyName'] ?? '',
      city: map['city'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      logo: map['logo'] ?? '',
      adminUid: map['admin_uid'] ?? '',
      status: _asBool(map['status']),
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'city': city,
      'contactPhone': contactPhone,
      'logo': logo,
      'admin_uid': adminUid,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
