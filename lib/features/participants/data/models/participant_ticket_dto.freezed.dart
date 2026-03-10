// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_ticket_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ParticipantTicketDto {
  String? get id => throw _privateConstructorUsedError;
  String get tourId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get slotId => throw _privateConstructorUsedError;
  String get passengerName => throw _privateConstructorUsedError;
  String get tcNo => throw _privateConstructorUsedError;
  double get pricePaid => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get qrToken => throw _privateConstructorUsedError;
  bool get isScanned => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get scannedAt => throw _privateConstructorUsedError;
  DateTime? get departureDate => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantTicketDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantTicketDtoCopyWith<ParticipantTicketDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantTicketDtoCopyWith<$Res> {
  factory $ParticipantTicketDtoCopyWith(
    ParticipantTicketDto value,
    $Res Function(ParticipantTicketDto) then,
  ) = _$ParticipantTicketDtoCopyWithImpl<$Res, ParticipantTicketDto>;
  @useResult
  $Res call({
    String? id,
    String tourId,
    String userId,
    String companyId,
    String slotId,
    String passengerName,
    String tcNo,
    double pricePaid,
    String status,
    String? qrToken,
    bool isScanned,
    DateTime? purchaseDate,
    DateTime? scannedAt,
    DateTime? departureDate,
  });
}

/// @nodoc
class _$ParticipantTicketDtoCopyWithImpl<
  $Res,
  $Val extends ParticipantTicketDto
>
    implements $ParticipantTicketDtoCopyWith<$Res> {
  _$ParticipantTicketDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantTicketDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tourId = null,
    Object? userId = null,
    Object? companyId = null,
    Object? slotId = null,
    Object? passengerName = null,
    Object? tcNo = null,
    Object? pricePaid = null,
    Object? status = null,
    Object? qrToken = freezed,
    Object? isScanned = null,
    Object? purchaseDate = freezed,
    Object? scannedAt = freezed,
    Object? departureDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            tourId: null == tourId
                ? _value.tourId
                : tourId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: null == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String,
            slotId: null == slotId
                ? _value.slotId
                : slotId // ignore: cast_nullable_to_non_nullable
                      as String,
            passengerName: null == passengerName
                ? _value.passengerName
                : passengerName // ignore: cast_nullable_to_non_nullable
                      as String,
            tcNo: null == tcNo
                ? _value.tcNo
                : tcNo // ignore: cast_nullable_to_non_nullable
                      as String,
            pricePaid: null == pricePaid
                ? _value.pricePaid
                : pricePaid // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            qrToken: freezed == qrToken
                ? _value.qrToken
                : qrToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            isScanned: null == isScanned
                ? _value.isScanned
                : isScanned // ignore: cast_nullable_to_non_nullable
                      as bool,
            purchaseDate: freezed == purchaseDate
                ? _value.purchaseDate
                : purchaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            scannedAt: freezed == scannedAt
                ? _value.scannedAt
                : scannedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            departureDate: freezed == departureDate
                ? _value.departureDate
                : departureDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParticipantTicketDtoImplCopyWith<$Res>
    implements $ParticipantTicketDtoCopyWith<$Res> {
  factory _$$ParticipantTicketDtoImplCopyWith(
    _$ParticipantTicketDtoImpl value,
    $Res Function(_$ParticipantTicketDtoImpl) then,
  ) = __$$ParticipantTicketDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String tourId,
    String userId,
    String companyId,
    String slotId,
    String passengerName,
    String tcNo,
    double pricePaid,
    String status,
    String? qrToken,
    bool isScanned,
    DateTime? purchaseDate,
    DateTime? scannedAt,
    DateTime? departureDate,
  });
}

/// @nodoc
class __$$ParticipantTicketDtoImplCopyWithImpl<$Res>
    extends _$ParticipantTicketDtoCopyWithImpl<$Res, _$ParticipantTicketDtoImpl>
    implements _$$ParticipantTicketDtoImplCopyWith<$Res> {
  __$$ParticipantTicketDtoImplCopyWithImpl(
    _$ParticipantTicketDtoImpl _value,
    $Res Function(_$ParticipantTicketDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParticipantTicketDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? tourId = null,
    Object? userId = null,
    Object? companyId = null,
    Object? slotId = null,
    Object? passengerName = null,
    Object? tcNo = null,
    Object? pricePaid = null,
    Object? status = null,
    Object? qrToken = freezed,
    Object? isScanned = null,
    Object? purchaseDate = freezed,
    Object? scannedAt = freezed,
    Object? departureDate = freezed,
  }) {
    return _then(
      _$ParticipantTicketDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        tourId: null == tourId
            ? _value.tourId
            : tourId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        slotId: null == slotId
            ? _value.slotId
            : slotId // ignore: cast_nullable_to_non_nullable
                  as String,
        passengerName: null == passengerName
            ? _value.passengerName
            : passengerName // ignore: cast_nullable_to_non_nullable
                  as String,
        tcNo: null == tcNo
            ? _value.tcNo
            : tcNo // ignore: cast_nullable_to_non_nullable
                  as String,
        pricePaid: null == pricePaid
            ? _value.pricePaid
            : pricePaid // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        qrToken: freezed == qrToken
            ? _value.qrToken
            : qrToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        isScanned: null == isScanned
            ? _value.isScanned
            : isScanned // ignore: cast_nullable_to_non_nullable
                  as bool,
        purchaseDate: freezed == purchaseDate
            ? _value.purchaseDate
            : purchaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scannedAt: freezed == scannedAt
            ? _value.scannedAt
            : scannedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        departureDate: freezed == departureDate
            ? _value.departureDate
            : departureDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$ParticipantTicketDtoImpl implements _ParticipantTicketDto {
  const _$ParticipantTicketDtoImpl({
    this.id,
    required this.tourId,
    required this.userId,
    required this.companyId,
    required this.slotId,
    required this.passengerName,
    required this.tcNo,
    required this.pricePaid,
    required this.status,
    this.qrToken,
    required this.isScanned,
    this.purchaseDate,
    this.scannedAt,
    this.departureDate,
  });

  @override
  final String? id;
  @override
  final String tourId;
  @override
  final String userId;
  @override
  final String companyId;
  @override
  final String slotId;
  @override
  final String passengerName;
  @override
  final String tcNo;
  @override
  final double pricePaid;
  @override
  final String status;
  @override
  final String? qrToken;
  @override
  final bool isScanned;
  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? scannedAt;
  @override
  final DateTime? departureDate;

  @override
  String toString() {
    return 'ParticipantTicketDto(id: $id, tourId: $tourId, userId: $userId, companyId: $companyId, slotId: $slotId, passengerName: $passengerName, tcNo: $tcNo, pricePaid: $pricePaid, status: $status, qrToken: $qrToken, isScanned: $isScanned, purchaseDate: $purchaseDate, scannedAt: $scannedAt, departureDate: $departureDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantTicketDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tourId, tourId) || other.tourId == tourId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.slotId, slotId) || other.slotId == slotId) &&
            (identical(other.passengerName, passengerName) ||
                other.passengerName == passengerName) &&
            (identical(other.tcNo, tcNo) || other.tcNo == tcNo) &&
            (identical(other.pricePaid, pricePaid) ||
                other.pricePaid == pricePaid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.qrToken, qrToken) || other.qrToken == qrToken) &&
            (identical(other.isScanned, isScanned) ||
                other.isScanned == isScanned) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt) &&
            (identical(other.departureDate, departureDate) ||
                other.departureDate == departureDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tourId,
    userId,
    companyId,
    slotId,
    passengerName,
    tcNo,
    pricePaid,
    status,
    qrToken,
    isScanned,
    purchaseDate,
    scannedAt,
    departureDate,
  );

  /// Create a copy of ParticipantTicketDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantTicketDtoImplCopyWith<_$ParticipantTicketDtoImpl>
  get copyWith =>
      __$$ParticipantTicketDtoImplCopyWithImpl<_$ParticipantTicketDtoImpl>(
        this,
        _$identity,
      );
}

abstract class _ParticipantTicketDto implements ParticipantTicketDto {
  const factory _ParticipantTicketDto({
    final String? id,
    required final String tourId,
    required final String userId,
    required final String companyId,
    required final String slotId,
    required final String passengerName,
    required final String tcNo,
    required final double pricePaid,
    required final String status,
    final String? qrToken,
    required final bool isScanned,
    final DateTime? purchaseDate,
    final DateTime? scannedAt,
    final DateTime? departureDate,
  }) = _$ParticipantTicketDtoImpl;

  @override
  String? get id;
  @override
  String get tourId;
  @override
  String get userId;
  @override
  String get companyId;
  @override
  String get slotId;
  @override
  String get passengerName;
  @override
  String get tcNo;
  @override
  double get pricePaid;
  @override
  String get status;
  @override
  String? get qrToken;
  @override
  bool get isScanned;
  @override
  DateTime? get purchaseDate;
  @override
  DateTime? get scannedAt;
  @override
  DateTime? get departureDate;

  /// Create a copy of ParticipantTicketDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantTicketDtoImplCopyWith<_$ParticipantTicketDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
