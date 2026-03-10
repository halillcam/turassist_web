import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_entity.freezed.dart';

@freezed
class CompanyEntity with _$CompanyEntity {
  const factory CompanyEntity({
    String? id,
    required String companyName,
    required String city,
    required String contactPhone,
    required String logo,
    required String adminUid,
    required bool status,
    DateTime? createdAt,
  }) = _CompanyEntity;
}
