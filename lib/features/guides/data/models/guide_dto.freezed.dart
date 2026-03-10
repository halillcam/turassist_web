// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GuideDto {
  String? get uid => throw _privateConstructorUsedError;
  String get loginId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get guidePassword => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Create a copy of GuideDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuideDtoCopyWith<GuideDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideDtoCopyWith<$Res> {
  factory $GuideDtoCopyWith(GuideDto value, $Res Function(GuideDto) then) =
      _$GuideDtoCopyWithImpl<$Res, GuideDto>;
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
class _$GuideDtoCopyWithImpl<$Res, $Val extends GuideDto>
    implements $GuideDtoCopyWith<$Res> {
  _$GuideDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuideDto
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
abstract class _$$GuideDtoImplCopyWith<$Res>
    implements $GuideDtoCopyWith<$Res> {
  factory _$$GuideDtoImplCopyWith(
    _$GuideDtoImpl value,
    $Res Function(_$GuideDtoImpl) then,
  ) = __$$GuideDtoImplCopyWithImpl<$Res>;
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
class __$$GuideDtoImplCopyWithImpl<$Res>
    extends _$GuideDtoCopyWithImpl<$Res, _$GuideDtoImpl>
    implements _$$GuideDtoImplCopyWith<$Res> {
  __$$GuideDtoImplCopyWithImpl(
    _$GuideDtoImpl _value,
    $Res Function(_$GuideDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuideDto
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
      _$GuideDtoImpl(
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

class _$GuideDtoImpl implements _GuideDto {
  const _$GuideDtoImpl({
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
    return 'GuideDto(uid: $uid, loginId: $loginId, email: $email, fullName: $fullName, phone: $phone, companyId: $companyId, guidePassword: $guidePassword, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideDtoImpl &&
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

  /// Create a copy of GuideDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideDtoImplCopyWith<_$GuideDtoImpl> get copyWith =>
      __$$GuideDtoImplCopyWithImpl<_$GuideDtoImpl>(this, _$identity);
}

abstract class _GuideDto implements GuideDto {
  const factory _GuideDto({
    final String? uid,
    required final String loginId,
    required final String email,
    required final String fullName,
    required final String phone,
    required final String companyId,
    final String? guidePassword,
    required final bool isDeleted,
  }) = _$GuideDtoImpl;

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

  /// Create a copy of GuideDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideDtoImplCopyWith<_$GuideDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
