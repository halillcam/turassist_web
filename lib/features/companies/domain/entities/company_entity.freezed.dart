// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CompanyEntity {
  String? get id => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get contactPhone => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;
  String get adminUid => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CompanyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyEntityCopyWith<CompanyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyEntityCopyWith<$Res> {
  factory $CompanyEntityCopyWith(
    CompanyEntity value,
    $Res Function(CompanyEntity) then,
  ) = _$CompanyEntityCopyWithImpl<$Res, CompanyEntity>;
  @useResult
  $Res call({
    String? id,
    String companyName,
    String city,
    String contactPhone,
    String logo,
    String adminUid,
    bool status,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$CompanyEntityCopyWithImpl<$Res, $Val extends CompanyEntity>
    implements $CompanyEntityCopyWith<$Res> {
  _$CompanyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyName = null,
    Object? city = null,
    Object? contactPhone = null,
    Object? logo = null,
    Object? adminUid = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            contactPhone: null == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            logo: null == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String,
            adminUid: null == adminUid
                ? _value.adminUid
                : adminUid // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyEntityImplCopyWith<$Res>
    implements $CompanyEntityCopyWith<$Res> {
  factory _$$CompanyEntityImplCopyWith(
    _$CompanyEntityImpl value,
    $Res Function(_$CompanyEntityImpl) then,
  ) = __$$CompanyEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String companyName,
    String city,
    String contactPhone,
    String logo,
    String adminUid,
    bool status,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$CompanyEntityImplCopyWithImpl<$Res>
    extends _$CompanyEntityCopyWithImpl<$Res, _$CompanyEntityImpl>
    implements _$$CompanyEntityImplCopyWith<$Res> {
  __$$CompanyEntityImplCopyWithImpl(
    _$CompanyEntityImpl _value,
    $Res Function(_$CompanyEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyName = null,
    Object? city = null,
    Object? contactPhone = null,
    Object? logo = null,
    Object? adminUid = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CompanyEntityImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        contactPhone: null == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        logo: null == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String,
        adminUid: null == adminUid
            ? _value.adminUid
            : adminUid // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CompanyEntityImpl implements _CompanyEntity {
  const _$CompanyEntityImpl({
    this.id,
    required this.companyName,
    required this.city,
    required this.contactPhone,
    required this.logo,
    required this.adminUid,
    required this.status,
    this.createdAt,
  });

  @override
  final String? id;
  @override
  final String companyName;
  @override
  final String city;
  @override
  final String contactPhone;
  @override
  final String logo;
  @override
  final String adminUid;
  @override
  final bool status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CompanyEntity(id: $id, companyName: $companyName, city: $city, contactPhone: $contactPhone, logo: $logo, adminUid: $adminUid, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.adminUid, adminUid) ||
                other.adminUid == adminUid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    companyName,
    city,
    contactPhone,
    logo,
    adminUid,
    status,
    createdAt,
  );

  /// Create a copy of CompanyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyEntityImplCopyWith<_$CompanyEntityImpl> get copyWith =>
      __$$CompanyEntityImplCopyWithImpl<_$CompanyEntityImpl>(this, _$identity);
}

abstract class _CompanyEntity implements CompanyEntity {
  const factory _CompanyEntity({
    final String? id,
    required final String companyName,
    required final String city,
    required final String contactPhone,
    required final String logo,
    required final String adminUid,
    required final bool status,
    final DateTime? createdAt,
  }) = _$CompanyEntityImpl;

  @override
  String? get id;
  @override
  String get companyName;
  @override
  String get city;
  @override
  String get contactPhone;
  @override
  String get logo;
  @override
  String get adminUid;
  @override
  bool get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of CompanyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyEntityImplCopyWith<_$CompanyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
