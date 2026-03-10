import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/company_entity.dart';

part 'company_dto.freezed.dart';

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

DateTime? _asDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return null;
}

@freezed
class CompanyDto with _$CompanyDto {
  const factory CompanyDto({
    String? id,
    required String companyName,
    required String city,
    required String contactPhone,
    required String logo,
    required String adminUid,
    required bool status,
    DateTime? createdAt,
  }) = _CompanyDto;

  factory CompanyDto.fromFirestore(Map<String, dynamic> map, String docId) {
    return CompanyDto(
      id: docId,
      companyName: map['companyName'] as String? ?? '',
      city: map['city'] as String? ?? '',
      contactPhone: map['contactPhone'] as String? ?? '',
      logo: map['logo'] as String? ?? '',
      adminUid: map['admin_uid'] as String? ?? '',
      status: _asBool(map['status']),
      createdAt: _asDateTime(map['createdAt']),
    );
  }
}

extension CompanyDtoMapper on CompanyDto {
  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id,
      companyName: companyName,
      city: city,
      contactPhone: contactPhone,
      logo: logo,
      adminUid: adminUid,
      status: status,
      createdAt: createdAt,
    );
  }
}
