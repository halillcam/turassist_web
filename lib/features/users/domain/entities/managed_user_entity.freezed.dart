// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ManagedUserEntity {
  String? get uid => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  List<String> get registeredCompanies => throw _privateConstructorUsedError;
  String get tcNo => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String get selectedCity => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get guidePassword => throw _privateConstructorUsedError;
  String? get loginId => throw _privateConstructorUsedError;
  String? get customerPassword => throw _privateConstructorUsedError;
  bool get isPanelManagedCustomer => throw _privateConstructorUsedError;

  /// Create a copy of ManagedUserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagedUserEntityCopyWith<ManagedUserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagedUserEntityCopyWith<$Res> {
  factory $ManagedUserEntityCopyWith(
    ManagedUserEntity value,
    $Res Function(ManagedUserEntity) then,
  ) = _$ManagedUserEntityCopyWithImpl<$Res, ManagedUserEntity>;
  @useResult
  $Res call({
    String? uid,
    String fullName,
    String email,
    String phone,
    String role,
    String companyId,
    List<String> registeredCompanies,
    String tcNo,
    String? profileImage,
    String selectedCity,
    bool isDeleted,
    DateTime? createdAt,
    String? guidePassword,
    String? loginId,
    String? customerPassword,
    bool isPanelManagedCustomer,
  });
}

/// @nodoc
class _$ManagedUserEntityCopyWithImpl<$Res, $Val extends ManagedUserEntity>
    implements $ManagedUserEntityCopyWith<$Res> {
  _$ManagedUserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagedUserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = null,
    Object? email = null,
    Object? phone = null,
    Object? role = null,
    Object? companyId = null,
    Object? registeredCompanies = null,
    Object? tcNo = null,
    Object? profileImage = freezed,
    Object? selectedCity = null,
    Object? isDeleted = null,
    Object? createdAt = freezed,
    Object? guidePassword = freezed,
    Object? loginId = freezed,
    Object? customerPassword = freezed,
    Object? isPanelManagedCustomer = null,
  }) {
    return _then(
      _value.copyWith(
            uid: freezed == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: null == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String,
            registeredCompanies: null == registeredCompanies
                ? _value.registeredCompanies
                : registeredCompanies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tcNo: null == tcNo
                ? _value.tcNo
                : tcNo // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedCity: null == selectedCity
                ? _value.selectedCity
                : selectedCity // ignore: cast_nullable_to_non_nullable
                      as String,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            guidePassword: freezed == guidePassword
                ? _value.guidePassword
                : guidePassword // ignore: cast_nullable_to_non_nullable
                      as String?,
            loginId: freezed == loginId
                ? _value.loginId
                : loginId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPassword: freezed == customerPassword
                ? _value.customerPassword
                : customerPassword // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPanelManagedCustomer: null == isPanelManagedCustomer
                ? _value.isPanelManagedCustomer
                : isPanelManagedCustomer // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagedUserEntityImplCopyWith<$Res>
    implements $ManagedUserEntityCopyWith<$Res> {
  factory _$$ManagedUserEntityImplCopyWith(
    _$ManagedUserEntityImpl value,
    $Res Function(_$ManagedUserEntityImpl) then,
  ) = __$$ManagedUserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? uid,
    String fullName,
    String email,
    String phone,
    String role,
    String companyId,
    List<String> registeredCompanies,
    String tcNo,
    String? profileImage,
    String selectedCity,
    bool isDeleted,
    DateTime? createdAt,
    String? guidePassword,
    String? loginId,
    String? customerPassword,
    bool isPanelManagedCustomer,
  });
}

/// @nodoc
class __$$ManagedUserEntityImplCopyWithImpl<$Res>
    extends _$ManagedUserEntityCopyWithImpl<$Res, _$ManagedUserEntityImpl>
    implements _$$ManagedUserEntityImplCopyWith<$Res> {
  __$$ManagedUserEntityImplCopyWithImpl(
    _$ManagedUserEntityImpl _value,
    $Res Function(_$ManagedUserEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagedUserEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = null,
    Object? email = null,
    Object? phone = null,
    Object? role = null,
    Object? companyId = null,
    Object? registeredCompanies = null,
    Object? tcNo = null,
    Object? profileImage = freezed,
    Object? selectedCity = null,
    Object? isDeleted = null,
    Object? createdAt = freezed,
    Object? guidePassword = freezed,
    Object? loginId = freezed,
    Object? customerPassword = freezed,
    Object? isPanelManagedCustomer = null,
  }) {
    return _then(
      _$ManagedUserEntityImpl(
        uid: freezed == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        registeredCompanies: null == registeredCompanies
            ? _value._registeredCompanies
            : registeredCompanies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tcNo: null == tcNo
            ? _value.tcNo
            : tcNo // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedCity: null == selectedCity
            ? _value.selectedCity
            : selectedCity // ignore: cast_nullable_to_non_nullable
                  as String,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        guidePassword: freezed == guidePassword
            ? _value.guidePassword
            : guidePassword // ignore: cast_nullable_to_non_nullable
                  as String?,
        loginId: freezed == loginId
            ? _value.loginId
            : loginId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPassword: freezed == customerPassword
            ? _value.customerPassword
            : customerPassword // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPanelManagedCustomer: null == isPanelManagedCustomer
            ? _value.isPanelManagedCustomer
            : isPanelManagedCustomer // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ManagedUserEntityImpl implements _ManagedUserEntity {
  const _$ManagedUserEntityImpl({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.companyId,
    required final List<String> registeredCompanies,
    required this.tcNo,
    this.profileImage,
    required this.selectedCity,
    required this.isDeleted,
    this.createdAt,
    this.guidePassword,
    this.loginId,
    this.customerPassword,
    required this.isPanelManagedCustomer,
  }) : _registeredCompanies = registeredCompanies;

  @override
  final String? uid;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String role;
  @override
  final String companyId;
  final List<String> _registeredCompanies;
  @override
  List<String> get registeredCompanies {
    if (_registeredCompanies is EqualUnmodifiableListView)
      return _registeredCompanies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_registeredCompanies);
  }

  @override
  final String tcNo;
  @override
  final String? profileImage;
  @override
  final String selectedCity;
  @override
  final bool isDeleted;
  @override
  final DateTime? createdAt;
  @override
  final String? guidePassword;
  @override
  final String? loginId;
  @override
  final String? customerPassword;
  @override
  final bool isPanelManagedCustomer;

  @override
  String toString() {
    return 'ManagedUserEntity(uid: $uid, fullName: $fullName, email: $email, phone: $phone, role: $role, companyId: $companyId, registeredCompanies: $registeredCompanies, tcNo: $tcNo, profileImage: $profileImage, selectedCity: $selectedCity, isDeleted: $isDeleted, createdAt: $createdAt, guidePassword: $guidePassword, loginId: $loginId, customerPassword: $customerPassword, isPanelManagedCustomer: $isPanelManagedCustomer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagedUserEntityImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            const DeepCollectionEquality().equals(
              other._registeredCompanies,
              _registeredCompanies,
            ) &&
            (identical(other.tcNo, tcNo) || other.tcNo == tcNo) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.selectedCity, selectedCity) ||
                other.selectedCity == selectedCity) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.guidePassword, guidePassword) ||
                other.guidePassword == guidePassword) &&
            (identical(other.loginId, loginId) || other.loginId == loginId) &&
            (identical(other.customerPassword, customerPassword) ||
                other.customerPassword == customerPassword) &&
            (identical(other.isPanelManagedCustomer, isPanelManagedCustomer) ||
                other.isPanelManagedCustomer == isPanelManagedCustomer));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    fullName,
    email,
    phone,
    role,
    companyId,
    const DeepCollectionEquality().hash(_registeredCompanies),
    tcNo,
    profileImage,
    selectedCity,
    isDeleted,
    createdAt,
    guidePassword,
    loginId,
    customerPassword,
    isPanelManagedCustomer,
  );

  /// Create a copy of ManagedUserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagedUserEntityImplCopyWith<_$ManagedUserEntityImpl> get copyWith =>
      __$$ManagedUserEntityImplCopyWithImpl<_$ManagedUserEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _ManagedUserEntity implements ManagedUserEntity {
  const factory _ManagedUserEntity({
    final String? uid,
    required final String fullName,
    required final String email,
    required final String phone,
    required final String role,
    required final String companyId,
    required final List<String> registeredCompanies,
    required final String tcNo,
    final String? profileImage,
    required final String selectedCity,
    required final bool isDeleted,
    final DateTime? createdAt,
    final String? guidePassword,
    final String? loginId,
    final String? customerPassword,
    required final bool isPanelManagedCustomer,
  }) = _$ManagedUserEntityImpl;

  @override
  String? get uid;
  @override
  String get fullName;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get role;
  @override
  String get companyId;
  @override
  List<String> get registeredCompanies;
  @override
  String get tcNo;
  @override
  String? get profileImage;
  @override
  String get selectedCity;
  @override
  bool get isDeleted;
  @override
  DateTime? get createdAt;
  @override
  String? get guidePassword;
  @override
  String? get loginId;
  @override
  String? get customerPassword;
  @override
  bool get isPanelManagedCustomer;

  /// Create a copy of ManagedUserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagedUserEntityImplCopyWith<_$ManagedUserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
