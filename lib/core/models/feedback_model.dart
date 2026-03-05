import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String? id;
  final String companyId;
  final String title;
  final String description;
  final String senderName;
  final String senderPhone;
  final Timestamp? createdAt;

  FeedbackModel({
    this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.senderName,
    required this.senderPhone,
    this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      companyId: map['companyId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhone: map['senderPhone'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'senderName': senderName,
      'senderPhone': senderPhone,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
