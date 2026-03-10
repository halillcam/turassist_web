import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide_entity.freezed.dart';

@freezed
class GuideEntity with _$GuideEntity {
  const factory GuideEntity({
    String? uid,
    required String loginId,
    required String email,
    required String fullName,
    required String phone,
    required String companyId,
    String? guidePassword,
    required bool isDeleted,
  }) = _GuideEntity;
}
