import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantModel {
  final String? id;
  final String email;
  final String tourId;
  final String companyId;
  final bool isActive;
  final Timestamp? createdAt;

  ParticipantModel({
    this.id,
    required this.email,
    required this.tourId,
    required this.companyId,
    this.isActive = true,
    this.createdAt,
  });

  factory ParticipantModel.fromMap(Map<String, dynamic> map, String docId) {
    return ParticipantModel(
      id: docId,
      email: map['email'] ?? '',
      tourId: map['tourId'] ?? '',
      companyId: map['companyId'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'tourId': tourId,
      'companyId': companyId,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
