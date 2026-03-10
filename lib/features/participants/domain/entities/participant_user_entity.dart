import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_user_entity.freezed.dart';

@freezed
class ParticipantUserEntity with _$ParticipantUserEntity {
  const factory ParticipantUserEntity({
    String? uid,
    required String fullName,
    required String phone,
    required String loginId,
    required String tcNo,
    required bool isPanelManagedCustomer,
  }) = _ParticipantUserEntity;
}
