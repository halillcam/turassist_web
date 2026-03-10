import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/participant_user_entity.dart';

part 'participant_user_dto.freezed.dart';

@freezed
class ParticipantUserDto with _$ParticipantUserDto {
  const factory ParticipantUserDto({
    String? uid,
    required String fullName,
    required String phone,
    required String loginId,
    required String tcNo,
    required bool isPanelManagedCustomer,
  }) = _ParticipantUserDto;

  factory ParticipantUserDto.fromFirestore(Map<String, dynamic> map, String docId) {
    return ParticipantUserDto(
      uid: docId,
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      loginId: map['loginId'] as String? ?? '',
      tcNo: map['tcNo'] as String? ?? '',
      isPanelManagedCustomer: map['isPanelManagedCustomer'] as bool? ?? false,
    );
  }
}

extension ParticipantUserDtoMapper on ParticipantUserDto {
  ParticipantUserEntity toEntity() {
    return ParticipantUserEntity(
      uid: uid,
      fullName: fullName,
      phone: phone,
      loginId: loginId,
      tcNo: tcNo,
      isPanelManagedCustomer: isPanelManagedCustomer,
    );
  }
}
