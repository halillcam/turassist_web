import 'package:freezed_annotation/freezed_annotation.dart';

part 'managed_user_entity.freezed.dart';

@freezed
class ManagedUserEntity with _$ManagedUserEntity {
  const factory ManagedUserEntity({
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
  }) = _ManagedUserEntity;
}
