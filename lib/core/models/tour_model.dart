import 'package:cloud_firestore/cloud_firestore.dart';

class BusInfo {
  final String driverName;
  final String phoneNumber;
  final String plate;
  final int capacity;

  BusInfo({
    required this.driverName,
    required this.phoneNumber,
    required this.plate,
    required this.capacity,
  });

  factory BusInfo.fromMap(Map<String, dynamic> map) {
    return BusInfo(
      driverName: map['driverName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      plate: map['plate'] ?? '',
      capacity: map['capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverName': driverName,
      'phoneNumber': phoneNumber,
      'plate': plate,
      'capacity': capacity,
    };
  }
}

class DayProgram {
  final String id;
  final String title;
  final int day;
  final int order;
  final List<String> activities;

  DayProgram({
    required this.id,
    required this.title,
    required this.day,
    required this.order,
    required this.activities,
  });

  factory DayProgram.fromMap(Map<String, dynamic> map) {
    return DayProgram(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      day: map['day'] ?? 0,
      order: map['order'] ?? 0,
      activities: List<String>.from(map['activities'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'day': day, 'order': order, 'activities': activities};
  }
}

class TourModel {
  final String? id;
  final String title;
  final String description;
  final String extraDetail;
  final double price;
  final String imageUrl;
  final String companyId;
  final String guideId;
  final String? guideName;
  final int capacity;
  final String city;
  final String region;
  final BusInfo busInfo;
  final List<DayProgram> program;
  final DateTime? createdAt;
  final bool isDeleted;

  /// Haftalık çıkış günleri (1=Pazartesi … 7=Pazar).
  final List<int> departureDays;
  final String departureTime;
  final DateTime? departureDate;

  /// Özel çıkış tarihleri listesi.
  final List<DateTime>? departureDates;

  /// Aynı turun farklı tarihlere ait instance'larını gruplamak için.
  final String? seriesId;

  TourModel({
    this.id,
    required this.title,
    required this.description,
    this.extraDetail = '',
    required this.price,
    required this.imageUrl,
    required this.companyId,
    this.guideId = '',
    this.guideName,
    required this.capacity,
    required this.city,
    required this.region,
    required this.busInfo,
    this.program = const [],
    this.createdAt,
    this.isDeleted = false,
    this.departureDays = const [],
    required this.departureTime,
    this.departureDate,
    this.departureDates,
    this.seriesId,
  });

  factory TourModel.fromMap(Map<String, dynamic> map, String docId) {
    return TourModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      extraDetail: map['extraDetail'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      companyId: map['companyId'] ?? '',
      guideId: map['guideId'] ?? '',
      guideName: map['guideName'],
      capacity: map['capacity'] ?? 0,
      city: map['city'] ?? '',
      region: map['region'] ?? '',
      busInfo: map['busInfo'] != null
          ? BusInfo.fromMap(Map<String, dynamic>.from(map['busInfo']))
          : BusInfo(driverName: '', phoneNumber: '', plate: '', capacity: 0),
      program: map['program'] != null
          ? (map['program'] as List)
                .map((e) => DayProgram.fromMap(Map<String, dynamic>.from(e)))
                .toList()
          : [],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      isDeleted: map['isDeleted'] ?? false,
      departureDays: List<int>.from(map['departureDays'] ?? []),
      departureTime: map['departureTime'] ?? '',
      departureDate: map['departureDate'] != null
          ? (map['departureDate'] as Timestamp).toDate()
          : null,
      departureDates: map['departureDates'] != null
          ? (map['departureDates'] as List).map((e) => (e as Timestamp).toDate()).toList()
          : null,
      seriesId: map['seriesId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'extraDetail': extraDetail,
      'price': price,
      'imageUrl': imageUrl,
      'companyId': companyId,
      'guideId': guideId,
      'guideName': guideName,
      'capacity': capacity,
      'city': city,
      'region': region,
      'busInfo': busInfo.toMap(),
      'program': program.map((e) => e.toMap()).toList(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'isDeleted': isDeleted,
      'departureDays': departureDays,
      'departureTime': departureTime,
      'departureDate': departureDate != null ? Timestamp.fromDate(departureDate!) : null,
      'departureDates': departureDates?.map((e) => Timestamp.fromDate(e)).toList(),
      'seriesId': seriesId,
    };
  }
}
