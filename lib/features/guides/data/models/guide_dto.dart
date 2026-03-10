import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/guide_entity.dart';

part 'guide_dto.freezed.dart';

@freezed
class GuideDto with _$GuideDto {
  const factory GuideDto({
    String? uid,
    required String loginId,
    required String email,
    required String fullName,
    required String phone,
    required String companyId,
    String? guidePassword,
    required bool isDeleted,
  }) = _GuideDto;
}

extension GuideDtoMapper on GuideDto {
  GuideEntity toEntity() {
    return GuideEntity(
      uid: uid,
      loginId: loginId,
      email: email,
      fullName: fullName,
      phone: phone,
      companyId: companyId,
      guidePassword: guidePassword,
      isDeleted: isDeleted,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'loginId': loginId,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': 'guide',
      'companyId': companyId,
      if (guidePassword != null) 'guidePassword': guidePassword,
      'isDeleted': isDeleted,
    };
  }
}
