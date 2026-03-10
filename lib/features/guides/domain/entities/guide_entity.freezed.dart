// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GuideEntity {
  String? get uid => throw _privateConstructorUsedError;
  String get loginId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get guidePassword => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Create a copy of GuideEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuideEntityCopyWith<GuideEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideEntityCopyWith<$Res> {
  factory $GuideEntityCopyWith(
    GuideEntity value,
    $Res Function(GuideEntity) then,
  ) = _$GuideEntityCopyWithImpl<$Res, GuideEntity>;
  @useResult
  $Res call({
    String? uid,
    String loginId,
    String email,
    String fullName,
    String phone,
    String companyId,
    String? guidePassword,
    bool isDeleted,
  });
}

/// @nodoc
class _$GuideEntityCopyWithImpl<$Res, $Val extends GuideEntity>
    implements $GuideEntityCopyWith<$Res> {
  _$GuideEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuideEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? loginId = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = null,
    Object? companyId = null,
    Object? guidePassword = freezed,
    Object? isDeleted = null,
  }) {
    return _then(
      _value.copyWith(
            uid: freezed == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String?,
            loginId: null == loginId
                ? _value.loginId
                : loginId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: null == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String,
            guidePassword: freezed == guidePassword
                ? _value.guidePassword
                : guidePassword // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuideEntityImplCopyWith<$Res>
    implements $GuideEntityCopyWith<$Res> {
  factory _$$GuideEntityImplCopyWith(
    _$GuideEntityImpl value,
    $Res Function(_$GuideEntityImpl) then,
  ) = __$$GuideEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? uid,
    String loginId,
    String email,
    String fullName,
    String phone,
    String companyId,
    String? guidePassword,
    bool isDeleted,
  });
}

/// @nodoc
class __$$GuideEntityImplCopyWithImpl<$Res>
    extends _$GuideEntityCopyWithImpl<$Res, _$GuideEntityImpl>
    implements _$$GuideEntityImplCopyWith<$Res> {
  __$$GuideEntityImplCopyWithImpl(
    _$GuideEntityImpl _value,
    $Res Function(_$GuideEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuideEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? loginId = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = null,
    Object? companyId = null,
    Object? guidePassword = freezed,
    Object? isDeleted = null,
  }) {
    return _then(
      _$GuideEntityImpl(
        uid: freezed == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String?,
        loginId: null == loginId
            ? _value.loginId
            : loginId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        guidePassword: freezed == guidePassword
            ? _value.guidePassword
            : guidePassword // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$GuideEntityImpl implements _GuideEntity {
  const _$GuideEntityImpl({
    this.uid,
    required this.loginId,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.companyId,
    this.guidePassword,
    required this.isDeleted,
  });

  @override
  final String? uid;
  @override
  final String loginId;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String companyId;
  @override
  final String? guidePassword;
  @override
  final bool isDeleted;

  @override
  String toString() {
    return 'GuideEntity(uid: $uid, loginId: $loginId, email: $email, fullName: $fullName, phone: $phone, companyId: $companyId, guidePassword: $guidePassword, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideEntityImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.loginId, loginId) || other.loginId == loginId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.guidePassword, guidePassword) ||
                other.guidePassword == guidePassword) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    loginId,
    email,
    fullName,
    phone,
    companyId,
    guidePassword,
    isDeleted,
  );

  /// Create a copy of GuideEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideEntityImplCopyWith<_$GuideEntityImpl> get copyWith =>
      __$$GuideEntityImplCopyWithImpl<_$GuideEntityImpl>(this, _$identity);
}

abstract class _GuideEntity implements GuideEntity {
  const factory _GuideEntity({
    final String? uid,
    required final String loginId,
    required final String email,
    required final String fullName,
    required final String phone,
    required final String companyId,
    final String? guidePassword,
    required final bool isDeleted,
  }) = _$GuideEntityImpl;

  @override
  String? get uid;
  @override
  String get loginId;
  @override
  String get email;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get companyId;
  @override
  String? get guidePassword;
  @override
  bool get isDeleted;

  /// Create a copy of GuideEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideEntityImplCopyWith<_$GuideEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
