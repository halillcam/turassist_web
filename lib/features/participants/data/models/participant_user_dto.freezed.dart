// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ParticipantUserDto {
  String? get uid => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get loginId => throw _privateConstructorUsedError;
  String get tcNo => throw _privateConstructorUsedError;
  bool get isPanelManagedCustomer => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantUserDtoCopyWith<ParticipantUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantUserDtoCopyWith<$Res> {
  factory $ParticipantUserDtoCopyWith(
    ParticipantUserDto value,
    $Res Function(ParticipantUserDto) then,
  ) = _$ParticipantUserDtoCopyWithImpl<$Res, ParticipantUserDto>;
  @useResult
  $Res call({
    String? uid,
    String fullName,
    String phone,
    String loginId,
    String tcNo,
    bool isPanelManagedCustomer,
  });
}

/// @nodoc
class _$ParticipantUserDtoCopyWithImpl<$Res, $Val extends ParticipantUserDto>
    implements $ParticipantUserDtoCopyWith<$Res> {
  _$ParticipantUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = null,
    Object? phone = null,
    Object? loginId = null,
    Object? tcNo = null,
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
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            loginId: null == loginId
                ? _value.loginId
                : loginId // ignore: cast_nullable_to_non_nullable
                      as String,
            tcNo: null == tcNo
                ? _value.tcNo
                : tcNo // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ParticipantUserDtoImplCopyWith<$Res>
    implements $ParticipantUserDtoCopyWith<$Res> {
  factory _$$ParticipantUserDtoImplCopyWith(
    _$ParticipantUserDtoImpl value,
    $Res Function(_$ParticipantUserDtoImpl) then,
  ) = __$$ParticipantUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? uid,
    String fullName,
    String phone,
    String loginId,
    String tcNo,
    bool isPanelManagedCustomer,
  });
}

/// @nodoc
class __$$ParticipantUserDtoImplCopyWithImpl<$Res>
    extends _$ParticipantUserDtoCopyWithImpl<$Res, _$ParticipantUserDtoImpl>
    implements _$$ParticipantUserDtoImplCopyWith<$Res> {
  __$$ParticipantUserDtoImplCopyWithImpl(
    _$ParticipantUserDtoImpl _value,
    $Res Function(_$ParticipantUserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParticipantUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = null,
    Object? phone = null,
    Object? loginId = null,
    Object? tcNo = null,
    Object? isPanelManagedCustomer = null,
  }) {
    return _then(
      _$ParticipantUserDtoImpl(
        uid: freezed == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        loginId: null == loginId
            ? _value.loginId
            : loginId // ignore: cast_nullable_to_non_nullable
                  as String,
        tcNo: null == tcNo
            ? _value.tcNo
            : tcNo // ignore: cast_nullable_to_non_nullable
                  as String,
        isPanelManagedCustomer: null == isPanelManagedCustomer
            ? _value.isPanelManagedCustomer
            : isPanelManagedCustomer // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ParticipantUserDtoImpl implements _ParticipantUserDto {
  const _$ParticipantUserDtoImpl({
    this.uid,
    required this.fullName,
    required this.phone,
    required this.loginId,
    required this.tcNo,
    required this.isPanelManagedCustomer,
  });

  @override
  final String? uid;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String loginId;
  @override
  final String tcNo;
  @override
  final bool isPanelManagedCustomer;

  @override
  String toString() {
    return 'ParticipantUserDto(uid: $uid, fullName: $fullName, phone: $phone, loginId: $loginId, tcNo: $tcNo, isPanelManagedCustomer: $isPanelManagedCustomer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantUserDtoImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.loginId, loginId) || other.loginId == loginId) &&
            (identical(other.tcNo, tcNo) || other.tcNo == tcNo) &&
            (identical(other.isPanelManagedCustomer, isPanelManagedCustomer) ||
                other.isPanelManagedCustomer == isPanelManagedCustomer));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    fullName,
    phone,
    loginId,
    tcNo,
    isPanelManagedCustomer,
  );

  /// Create a copy of ParticipantUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantUserDtoImplCopyWith<_$ParticipantUserDtoImpl> get copyWith =>
      __$$ParticipantUserDtoImplCopyWithImpl<_$ParticipantUserDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _ParticipantUserDto implements ParticipantUserDto {
  const factory _ParticipantUserDto({
    final String? uid,
    required final String fullName,
    required final String phone,
    required final String loginId,
    required final String tcNo,
    required final bool isPanelManagedCustomer,
  }) = _$ParticipantUserDtoImpl;

  @override
  String? get uid;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get loginId;
  @override
  String get tcNo;
  @override
  bool get isPanelManagedCustomer;

  /// Create a copy of ParticipantUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantUserDtoImplCopyWith<_$ParticipantUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
