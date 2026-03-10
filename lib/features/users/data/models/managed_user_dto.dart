import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/managed_user_entity.dart';

part 'managed_user_dto.freezed.dart';

@freezed
class ManagedUserDto with _$ManagedUserDto {
  const factory ManagedUserDto({
    String? uid,
    required String fullName,
    required String email,
    required String phone,
    required String role,
    required String companyId,
    required List<String> registeredCompanies,
    required String tcNo,
    String? profileImage,
    required String selectedCity,
    required bool isDeleted,
    DateTime? createdAt,
    String? guidePassword,
    String? loginId,
    String? customerPassword,
    required bool isPanelManagedCustomer,
  }) = _ManagedUserDto;

  factory ManagedUserDto.fromFirestore(Map<String, dynamic> map, String docId) {
    return ManagedUserDto(
      uid: docId,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'customer',
      companyId: map['companyId'] as String? ?? '',
      registeredCompanies: List<String>.from(map['registeredCompanies'] ?? const []),
      tcNo: map['tcNo'] as String? ?? '',
      profileImage: map['profileImage'] as String?,
      selectedCity: map['selectedCity'] as String? ?? '',
      isDeleted: map['isDeleted'] == true,
      createdAt: map['createdAt'] is Timestamp ? (map['createdAt'] as Timestamp).toDate() : null,
      guidePassword: map['guidePassword'] as String?,
      loginId: map['loginId'] as String?,
      customerPassword: map['customerPassword'] as String?,
      isPanelManagedCustomer: map['isPanelManagedCustomer'] == true,
    );
  }

  factory ManagedUserDto.fromEntity(ManagedUserEntity entity) {
    return ManagedUserDto(
      uid: entity.uid,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
      companyId: entity.companyId,
      registeredCompanies: entity.registeredCompanies,
      tcNo: entity.tcNo,
      profileImage: entity.profileImage,
      selectedCity: entity.selectedCity,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      guidePassword: entity.guidePassword,
      loginId: entity.loginId,
      customerPassword: entity.customerPassword,
      isPanelManagedCustomer: entity.isPanelManagedCustomer,
    );
  }
}

extension ManagedUserDtoMapper on ManagedUserDto {
  ManagedUserEntity toEntity() {
    return ManagedUserEntity(
      uid: uid,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      companyId: companyId,
      registeredCompanies: registeredCompanies,
      tcNo: tcNo,
      profileImage: profileImage,
      selectedCity: selectedCity,
      isDeleted: isDeleted,
      createdAt: createdAt,
      guidePassword: guidePassword,
      loginId: loginId,
      customerPassword: customerPassword,
      isPanelManagedCustomer: isPanelManagedCustomer,
    );
  }

  Map<String, dynamic> toFirestore() {
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
      if (guidePassword != null) 'guidePassword': guidePassword,
      if (loginId != null) 'loginId': loginId,
      if (customerPassword != null) 'customerPassword': customerPassword,
      'isPanelManagedCustomer': isPanelManagedCustomer,
    };
  }
}
