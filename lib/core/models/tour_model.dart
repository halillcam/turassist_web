import 'package:cloud_firestore/cloud_firestore.dart';

class TourModel {
  final String? id;
  final String title;
  final String description;
  final double price;
  final int quota;
  final String city;
  final String region;
  final String imageUrl;
  final String guideName;
  final String? guideId;
  final String departureDate;
  final String departureTime;
  final String program;
  final String vehicleInfo;
  final String driverName;
  final String driverPhone;
  final String plate;
  final bool isActive;
  final String companyId;
  final Timestamp? createdAt;

  TourModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quota,
    required this.city,
    required this.region,
    required this.imageUrl,
    required this.guideName,
    this.guideId,
    required this.departureDate,
    required this.departureTime,
    required this.program,
    required this.vehicleInfo,
    required this.driverName,
    required this.driverPhone,
    required this.plate,
    this.isActive = true,
    required this.companyId,
    this.createdAt,
  });

  factory TourModel.fromMap(Map<String, dynamic> map, String docId) {
    return TourModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quota: map['quota'] ?? 0,
      city: map['city'] ?? '',
      region: map['region'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      guideName: map['guideName'] ?? '',
      guideId: map['guideId'],
      departureDate: map['departureDate'] ?? '',
      departureTime: map['departureTime'] ?? '',
      program: map['program'] ?? '',
      vehicleInfo: map['vehicleInfo'] ?? '',
      driverName: map['driverName'] ?? '',
      driverPhone: map['driverPhone'] ?? '',
      plate: map['plate'] ?? '',
      isActive: map['isActive'] ?? true,
      companyId: map['companyId'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'quota': quota,
      'city': city,
      'region': region,
      'imageUrl': imageUrl,
      'guideName': guideName,
      'guideId': guideId,
      'departureDate': departureDate,
      'departureTime': departureTime,
      'program': program,
      'vehicleInfo': vehicleInfo,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'plate': plate,
      'isActive': isActive,
      'companyId': companyId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
