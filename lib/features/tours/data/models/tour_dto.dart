import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/tour_entity.dart';

// ─── BusInfo ──────────────────────────────────────────────────────────────────

class BusInfoDto {
  final String driverName;
  final String phoneNumber;
  final String plate;
  final int capacity;

  const BusInfoDto({
    required this.driverName,
    required this.phoneNumber,
    required this.plate,
    required this.capacity,
  });

  factory BusInfoDto.fromJson(Map<String, dynamic> json) => BusInfoDto(
    driverName: json['driverName'] as String? ?? '',
    phoneNumber: json['phoneNumber'] as String? ?? '',
    plate: json['plate'] as String? ?? '',
    capacity: (json['capacity'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'driverName': driverName,
    'phoneNumber': phoneNumber,
    'plate': plate,
    'capacity': capacity,
  };

  BusInfoEntity toEntity() => BusInfoEntity(
    driverName: driverName,
    phoneNumber: phoneNumber,
    plate: plate,
    capacity: capacity,
  );

  factory BusInfoDto.fromEntity(BusInfoEntity e) => BusInfoDto(
    driverName: e.driverName,
    phoneNumber: e.phoneNumber,
    plate: e.plate,
    capacity: e.capacity,
  );
}

// ─── DayProgram ───────────────────────────────────────────────────────────────

class DayProgramDto {
  final String id;
  final String title;
  final int day;
  final int order;
  final List<String> activities;

  const DayProgramDto({
    required this.id,
    required this.title,
    required this.day,
    required this.order,
    required this.activities,
  });

  factory DayProgramDto.fromJson(Map<String, dynamic> json) => DayProgramDto(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    day: (json['day'] as num?)?.toInt() ?? 0,
    order: (json['order'] as num?)?.toInt() ?? 0,
    activities: List<String>.from(json['activities'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'day': day,
    'order': order,
    'activities': activities,
  };

  DayProgramEntity toEntity() =>
      DayProgramEntity(id: id, title: title, day: day, order: order, activities: activities);

  factory DayProgramDto.fromEntity(DayProgramEntity e) =>
      DayProgramDto(id: e.id, title: e.title, day: e.day, order: e.order, activities: e.activities);
}

// ─── Tour ─────────────────────────────────────────────────────────────────────

class TourDto {
  final String id;
  final String title;
  final String description;
  final String extraDetail;
  final double price;
  final String imageUrl;
  final String companyId;
  final String companyName;
  final String guideId;
  final String? guideName;
  final int capacity;
  final String city;
  final String region;
  final BusInfoDto busInfo;
  final List<DayProgramDto> program;
  final List<int> departureDays;
  final String departureTime;
  final DateTime? departureDate;
  final List<DateTime>? departureDates;
  final String? seriesId;
  final bool isDeleted;
  final DateTime? createdAt;

  const TourDto({
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
    required this.program,
    required this.departureDays,
    required this.departureTime,
    this.departureDate,
    this.departureDates,
    this.seriesId,
    required this.isDeleted,
    this.createdAt,
  });

  factory TourDto.fromJson(Map<String, dynamic> json, String docId) {
    DateTime? _ts(dynamic v) => v is Timestamp ? v.toDate() : null;

    return TourDto(
      id: docId,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      extraDetail: json['extraDetail'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      guideId: json['guideId'] as String? ?? '',
      guideName: json['guideName'] as String?,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      city: json['city'] as String? ?? '',
      region: json['region'] as String? ?? '',
      busInfo: json['busInfo'] != null
          ? BusInfoDto.fromJson(Map<String, dynamic>.from(json['busInfo']))
          : const BusInfoDto(driverName: '', phoneNumber: '', plate: '', capacity: 0),
      program: (json['program'] as List<dynamic>? ?? [])
          .map((e) => DayProgramDto.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      departureDays: List<int>.from(json['departureDays'] ?? []),
      departureTime: json['departureTime'] as String? ?? '',
      departureDate: _ts(json['departureDate']),
      departureDates: (json['departureDates'] as List<dynamic>?)
          ?.map((e) => _ts(e))
          .whereType<DateTime>()
          .toList(),
      seriesId: json['seriesId'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: _ts(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'extraDetail': extraDetail,
    'price': price,
    'imageUrl': imageUrl,
    'companyId': companyId,
    'companyName': companyName,
    'guideId': guideId,
    if (guideName != null) 'guideName': guideName,
    'capacity': capacity,
    'city': city,
    'region': region,
    'busInfo': busInfo.toJson(),
    'program': program.map((p) => p.toJson()).toList(),
    'departureDays': departureDays,
    'departureTime': departureTime,
    if (departureDate != null) 'departureDate': Timestamp.fromDate(departureDate!),
    if (departureDates != null) 'departureDates': departureDates!.map(Timestamp.fromDate).toList(),
    if (seriesId != null) 'seriesId': seriesId,
    'isDeleted': isDeleted,
    'createdAt': FieldValue.serverTimestamp(),
  };

  TourEntity toEntity() => TourEntity(
    id: id,
    title: title,
    description: description,
    extraDetail: extraDetail,
    price: price,
    imageUrl: imageUrl,
    companyId: companyId,
    companyName: companyName,
    guideId: guideId,
    guideName: guideName,
    capacity: capacity,
    city: city,
    region: region,
    busInfo: busInfo.toEntity(),
    program: program.map((p) => p.toEntity()).toList(),
    departureDays: departureDays,
    departureTime: departureTime,
    departureDate: departureDate,
    departureDates: departureDates,
    seriesId: seriesId,
    isDeleted: isDeleted,
    createdAt: createdAt,
  );

  factory TourDto.fromEntity(TourEntity e) => TourDto(
    id: e.id,
    title: e.title,
    description: e.description,
    extraDetail: e.extraDetail,
    price: e.price,
    imageUrl: e.imageUrl,
    companyId: e.companyId,
    companyName: e.companyName,
    guideId: e.guideId,
    guideName: e.guideName,
    capacity: e.capacity,
    city: e.city,
    region: e.region,
    busInfo: BusInfoDto.fromEntity(e.busInfo),
    program: e.program.map(DayProgramDto.fromEntity).toList(),
    departureDays: e.departureDays,
    departureTime: e.departureTime,
    departureDate: e.departureDate,
    departureDates: e.departureDates,
    seriesId: e.seriesId,
    isDeleted: e.isDeleted,
    createdAt: e.createdAt,
  );
}
