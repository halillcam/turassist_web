import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

enum UserRole { admin, superAdmin }

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String name,
    required String companyId,
    required UserRole role,
  }) = _UserEntity;
}
