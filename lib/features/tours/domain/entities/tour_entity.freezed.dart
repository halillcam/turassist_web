// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BusInfoEntity {
  String get driverName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get plate => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;

  /// Create a copy of BusInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusInfoEntityCopyWith<BusInfoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusInfoEntityCopyWith<$Res> {
  factory $BusInfoEntityCopyWith(
    BusInfoEntity value,
    $Res Function(BusInfoEntity) then,
  ) = _$BusInfoEntityCopyWithImpl<$Res, BusInfoEntity>;
  @useResult
  $Res call({
    String driverName,
    String phoneNumber,
    String plate,
    int capacity,
  });
}

/// @nodoc
class _$BusInfoEntityCopyWithImpl<$Res, $Val extends BusInfoEntity>
    implements $BusInfoEntityCopyWith<$Res> {
  _$BusInfoEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driverName = null,
    Object? phoneNumber = null,
    Object? plate = null,
    Object? capacity = null,
  }) {
    return _then(
      _value.copyWith(
            driverName: null == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            plate: null == plate
                ? _value.plate
                : plate // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusInfoEntityImplCopyWith<$Res>
    implements $BusInfoEntityCopyWith<$Res> {
  factory _$$BusInfoEntityImplCopyWith(
    _$BusInfoEntityImpl value,
    $Res Function(_$BusInfoEntityImpl) then,
  ) = __$$BusInfoEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String driverName,
    String phoneNumber,
    String plate,
    int capacity,
  });
}

/// @nodoc
class __$$BusInfoEntityImplCopyWithImpl<$Res>
    extends _$BusInfoEntityCopyWithImpl<$Res, _$BusInfoEntityImpl>
    implements _$$BusInfoEntityImplCopyWith<$Res> {
  __$$BusInfoEntityImplCopyWithImpl(
    _$BusInfoEntityImpl _value,
    $Res Function(_$BusInfoEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driverName = null,
    Object? phoneNumber = null,
    Object? plate = null,
    Object? capacity = null,
  }) {
    return _then(
      _$BusInfoEntityImpl(
        driverName: null == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        plate: null == plate
            ? _value.plate
            : plate // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$BusInfoEntityImpl implements _BusInfoEntity {
  const _$BusInfoEntityImpl({
    required this.driverName,
    required this.phoneNumber,
    required this.plate,
    required this.capacity,
  });

  @override
  final String driverName;
  @override
  final String phoneNumber;
  @override
  final String plate;
  @override
  final int capacity;

  @override
  String toString() {
    return 'BusInfoEntity(driverName: $driverName, phoneNumber: $phoneNumber, plate: $plate, capacity: $capacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusInfoEntityImpl &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, driverName, phoneNumber, plate, capacity);

  /// Create a copy of BusInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusInfoEntityImplCopyWith<_$BusInfoEntityImpl> get copyWith =>
      __$$BusInfoEntityImplCopyWithImpl<_$BusInfoEntityImpl>(this, _$identity);
}

abstract class _BusInfoEntity implements BusInfoEntity {
  const factory _BusInfoEntity({
    required final String driverName,
    required final String phoneNumber,
    required final String plate,
    required final int capacity,
  }) = _$BusInfoEntityImpl;

  @override
  String get driverName;
  @override
  String get phoneNumber;
  @override
  String get plate;
  @override
  int get capacity;

  /// Create a copy of BusInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusInfoEntityImplCopyWith<_$BusInfoEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DayProgramEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<String> get activities => throw _privateConstructorUsedError;

  /// Create a copy of DayProgramEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayProgramEntityCopyWith<DayProgramEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayProgramEntityCopyWith<$Res> {
  factory $DayProgramEntityCopyWith(
    DayProgramEntity value,
    $Res Function(DayProgramEntity) then,
  ) = _$DayProgramEntityCopyWithImpl<$Res, DayProgramEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    int day,
    int order,
    List<String> activities,
  });
}

/// @nodoc
class _$DayProgramEntityCopyWithImpl<$Res, $Val extends DayProgramEntity>
    implements $DayProgramEntityCopyWith<$Res> {
  _$DayProgramEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayProgramEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? day = null,
    Object? order = null,
    Object? activities = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            activities: null == activities
                ? _value.activities
                : activities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayProgramEntityImplCopyWith<$Res>
    implements $DayProgramEntityCopyWith<$Res> {
  factory _$$DayProgramEntityImplCopyWith(
    _$DayProgramEntityImpl value,
    $Res Function(_$DayProgramEntityImpl) then,
  ) = __$$DayProgramEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    int day,
    int order,
    List<String> activities,
  });
}

/// @nodoc
class __$$DayProgramEntityImplCopyWithImpl<$Res>
    extends _$DayProgramEntityCopyWithImpl<$Res, _$DayProgramEntityImpl>
    implements _$$DayProgramEntityImplCopyWith<$Res> {
  __$$DayProgramEntityImplCopyWithImpl(
    _$DayProgramEntityImpl _value,
    $Res Function(_$DayProgramEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayProgramEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? day = null,
    Object? order = null,
    Object? activities = null,
  }) {
    return _then(
      _$DayProgramEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        activities: null == activities
            ? _value._activities
            : activities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$DayProgramEntityImpl implements _DayProgramEntity {
  const _$DayProgramEntityImpl({
    required this.id,
    required this.title,
    required this.day,
    required this.order,
    required final List<String> activities,
  }) : _activities = activities;

  @override
  final String id;
  @override
  final String title;
  @override
  final int day;
  @override
  final int order;
  final List<String> _activities;
  @override
  List<String> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  String toString() {
    return 'DayProgramEntity(id: $id, title: $title, day: $day, order: $order, activities: $activities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayProgramEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(
              other._activities,
              _activities,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    day,
    order,
    const DeepCollectionEquality().hash(_activities),
  );

  /// Create a copy of DayProgramEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayProgramEntityImplCopyWith<_$DayProgramEntityImpl> get copyWith =>
      __$$DayProgramEntityImplCopyWithImpl<_$DayProgramEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _DayProgramEntity implements DayProgramEntity {
  const factory _DayProgramEntity({
    required final String id,
    required final String title,
    required final int day,
    required final int order,
    required final List<String> activities,
  }) = _$DayProgramEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  int get day;
  @override
  int get order;
  @override
  List<String> get activities;

  /// Create a copy of DayProgramEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayProgramEntityImplCopyWith<_$DayProgramEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TourEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get extraDetail => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get guideId => throw _privateConstructorUsedError;
  String? get guideName => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  BusInfoEntity get busInfo => throw _privateConstructorUsedError;
  List<DayProgramEntity> get program => throw _privateConstructorUsedError;

  /// Haftalık tekrar günleri: 1=Pzt … 7=Pzr
  List<int> get departureDays => throw _privateConstructorUsedError;
  String get departureTime => throw _privateConstructorUsedError;
  DateTime? get departureDate => throw _privateConstructorUsedError;
  List<DateTime>? get departureDates => throw _privateConstructorUsedError;

  /// Bir seri içindeki tüm instance'ları gruplar
  String? get seriesId => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TourEntityCopyWith<TourEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TourEntityCopyWith<$Res> {
  factory $TourEntityCopyWith(
    TourEntity value,
    $Res Function(TourEntity) then,
  ) = _$TourEntityCopyWithImpl<$Res, TourEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String extraDetail,
    double price,
    String imageUrl,
    String companyId,
    String companyName,
    String guideId,
    String? guideName,
    int capacity,
    String city,
    String region,
    BusInfoEntity busInfo,
    List<DayProgramEntity> program,
    List<int> departureDays,
    String departureTime,
    DateTime? departureDate,
    List<DateTime>? departureDates,
    String? seriesId,
    bool isDeleted,
    DateTime? createdAt,
  });

  $BusInfoEntityCopyWith<$Res> get busInfo;
}

/// @nodoc
class _$TourEntityCopyWithImpl<$Res, $Val extends TourEntity>
    implements $TourEntityCopyWith<$Res> {
  _$TourEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? extraDetail = null,
    Object? price = null,
    Object? imageUrl = null,
    Object? companyId = null,
    Object? companyName = null,
    Object? guideId = null,
    Object? guideName = freezed,
    Object? capacity = null,
    Object? city = null,
    Object? region = null,
    Object? busInfo = null,
    Object? program = null,
    Object? departureDays = null,
    Object? departureTime = null,
    Object? departureDate = freezed,
    Object? departureDates = freezed,
    Object? seriesId = freezed,
    Object? isDeleted = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            extraDetail: null == extraDetail
                ? _value.extraDetail
                : extraDetail // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: null == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            guideId: null == guideId
                ? _value.guideId
                : guideId // ignore: cast_nullable_to_non_nullable
                      as String,
            guideName: freezed == guideName
                ? _value.guideName
                : guideName // ignore: cast_nullable_to_non_nullable
                      as String?,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            region: null == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String,
            busInfo: null == busInfo
                ? _value.busInfo
                : busInfo // ignore: cast_nullable_to_non_nullable
                      as BusInfoEntity,
            program: null == program
                ? _value.program
                : program // ignore: cast_nullable_to_non_nullable
                      as List<DayProgramEntity>,
            departureDays: null == departureDays
                ? _value.departureDays
                : departureDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as String,
            departureDate: freezed == departureDate
                ? _value.departureDate
                : departureDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            departureDates: freezed == departureDates
                ? _value.departureDates
                : departureDates // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>?,
            seriesId: freezed == seriesId
                ? _value.seriesId
                : seriesId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDeleted: null == isDeleted
                ? _value.isDeleted
                : isDeleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusInfoEntityCopyWith<$Res> get busInfo {
    return $BusInfoEntityCopyWith<$Res>(_value.busInfo, (value) {
      return _then(_value.copyWith(busInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TourEntityImplCopyWith<$Res>
    implements $TourEntityCopyWith<$Res> {
  factory _$$TourEntityImplCopyWith(
    _$TourEntityImpl value,
    $Res Function(_$TourEntityImpl) then,
  ) = __$$TourEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String extraDetail,
    double price,
    String imageUrl,
    String companyId,
    String companyName,
    String guideId,
    String? guideName,
    int capacity,
    String city,
    String region,
    BusInfoEntity busInfo,
    List<DayProgramEntity> program,
    List<int> departureDays,
    String departureTime,
    DateTime? departureDate,
    List<DateTime>? departureDates,
    String? seriesId,
    bool isDeleted,
    DateTime? createdAt,
  });

  @override
  $BusInfoEntityCopyWith<$Res> get busInfo;
}

/// @nodoc
class __$$TourEntityImplCopyWithImpl<$Res>
    extends _$TourEntityCopyWithImpl<$Res, _$TourEntityImpl>
    implements _$$TourEntityImplCopyWith<$Res> {
  __$$TourEntityImplCopyWithImpl(
    _$TourEntityImpl _value,
    $Res Function(_$TourEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? extraDetail = null,
    Object? price = null,
    Object? imageUrl = null,
    Object? companyId = null,
    Object? companyName = null,
    Object? guideId = null,
    Object? guideName = freezed,
    Object? capacity = null,
    Object? city = null,
    Object? region = null,
    Object? busInfo = null,
    Object? program = null,
    Object? departureDays = null,
    Object? departureTime = null,
    Object? departureDate = freezed,
    Object? departureDates = freezed,
    Object? seriesId = freezed,
    Object? isDeleted = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TourEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        extraDetail: null == extraDetail
            ? _value.extraDetail
            : extraDetail // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        guideId: null == guideId
            ? _value.guideId
            : guideId // ignore: cast_nullable_to_non_nullable
                  as String,
        guideName: freezed == guideName
            ? _value.guideName
            : guideName // ignore: cast_nullable_to_non_nullable
                  as String?,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        region: null == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String,
        busInfo: null == busInfo
            ? _value.busInfo
            : busInfo // ignore: cast_nullable_to_non_nullable
                  as BusInfoEntity,
        program: null == program
            ? _value._program
            : program // ignore: cast_nullable_to_non_nullable
                  as List<DayProgramEntity>,
        departureDays: null == departureDays
            ? _value._departureDays
            : departureDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as String,
        departureDate: freezed == departureDate
            ? _value.departureDate
            : departureDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        departureDates: freezed == departureDates
            ? _value._departureDates
            : departureDates // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>?,
        seriesId: freezed == seriesId
            ? _value.seriesId
            : seriesId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDeleted: null == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
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

class _$TourEntityImpl implements _TourEntity {
  const _$TourEntityImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.extraDetail,
    required this.price,
    required this.imageUrl,
    required this.companyId,
    required this.companyName,
    required this.guideId,
    this.guideName,
    required this.capacity,
    required this.city,
    required this.region,
    required this.busInfo,
    required final List<DayProgramEntity> program,
    required final List<int> departureDays,
    required this.departureTime,
    this.departureDate,
    final List<DateTime>? departureDates,
    this.seriesId,
    required this.isDeleted,
    this.createdAt,
  }) : _program = program,
       _departureDays = departureDays,
       _departureDates = departureDates;

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String extraDetail;
  @override
  final double price;
  @override
  final String imageUrl;
  @override
  final String companyId;
  @override
  final String companyName;
  @override
  final String guideId;
  @override
  final String? guideName;
  @override
  final int capacity;
  @override
  final String city;
  @override
  final String region;
  @override
  final BusInfoEntity busInfo;
  final List<DayProgramEntity> _program;
  @override
  List<DayProgramEntity> get program {
    if (_program is EqualUnmodifiableListView) return _program;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_program);
  }

  /// Haftalık tekrar günleri: 1=Pzt … 7=Pzr
  final List<int> _departureDays;

  /// Haftalık tekrar günleri: 1=Pzt … 7=Pzr
  @override
  List<int> get departureDays {
    if (_departureDays is EqualUnmodifiableListView) return _departureDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_departureDays);
  }

  @override
  final String departureTime;
  @override
  final DateTime? departureDate;
  final List<DateTime>? _departureDates;
  @override
  List<DateTime>? get departureDates {
    final value = _departureDates;
    if (value == null) return null;
    if (_departureDates is EqualUnmodifiableListView) return _departureDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Bir seri içindeki tüm instance'ları gruplar
  @override
  final String? seriesId;
  @override
  final bool isDeleted;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TourEntity(id: $id, title: $title, description: $description, extraDetail: $extraDetail, price: $price, imageUrl: $imageUrl, companyId: $companyId, companyName: $companyName, guideId: $guideId, guideName: $guideName, capacity: $capacity, city: $city, region: $region, busInfo: $busInfo, program: $program, departureDays: $departureDays, departureTime: $departureTime, departureDate: $departureDate, departureDates: $departureDates, seriesId: $seriesId, isDeleted: $isDeleted, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TourEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.extraDetail, extraDetail) ||
                other.extraDetail == extraDetail) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.guideId, guideId) || other.guideId == guideId) &&
            (identical(other.guideName, guideName) ||
                other.guideName == guideName) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.busInfo, busInfo) || other.busInfo == busInfo) &&
            const DeepCollectionEquality().equals(other._program, _program) &&
            const DeepCollectionEquality().equals(
              other._departureDays,
              _departureDays,
            ) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.departureDate, departureDate) ||
                other.departureDate == departureDate) &&
            const DeepCollectionEquality().equals(
              other._departureDates,
              _departureDates,
            ) &&
            (identical(other.seriesId, seriesId) ||
                other.seriesId == seriesId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    extraDetail,
    price,
    imageUrl,
    companyId,
    companyName,
    guideId,
    guideName,
    capacity,
    city,
    region,
    busInfo,
    const DeepCollectionEquality().hash(_program),
    const DeepCollectionEquality().hash(_departureDays),
    departureTime,
    departureDate,
    const DeepCollectionEquality().hash(_departureDates),
    seriesId,
    isDeleted,
    createdAt,
  ]);

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TourEntityImplCopyWith<_$TourEntityImpl> get copyWith =>
      __$$TourEntityImplCopyWithImpl<_$TourEntityImpl>(this, _$identity);
}

abstract class _TourEntity implements TourEntity {
  const factory _TourEntity({
    required final String id,
    required final String title,
    required final String description,
    required final String extraDetail,
    required final double price,
    required final String imageUrl,
    required final String companyId,
    required final String companyName,
    required final String guideId,
    final String? guideName,
    required final int capacity,
    required final String city,
    required final String region,
    required final BusInfoEntity busInfo,
    required final List<DayProgramEntity> program,
    required final List<int> departureDays,
    required final String departureTime,
    final DateTime? departureDate,
    final List<DateTime>? departureDates,
    final String? seriesId,
    required final bool isDeleted,
    final DateTime? createdAt,
  }) = _$TourEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get extraDetail;
  @override
  double get price;
  @override
  String get imageUrl;
  @override
  String get companyId;
  @override
  String get companyName;
  @override
  String get guideId;
  @override
  String? get guideName;
  @override
  int get capacity;
  @override
  String get city;
  @override
  String get region;
  @override
  BusInfoEntity get busInfo;
  @override
  List<DayProgramEntity> get program;

  /// Haftalık tekrar günleri: 1=Pzt … 7=Pzr
  @override
  List<int> get departureDays;
  @override
  String get departureTime;
  @override
  DateTime? get departureDate;
  @override
  List<DateTime>? get departureDates;

  /// Bir seri içindeki tüm instance'ları gruplar
  @override
  String? get seriesId;
  @override
  bool get isDeleted;
  @override
  DateTime? get createdAt;

  /// Create a copy of TourEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TourEntityImplCopyWith<_$TourEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
