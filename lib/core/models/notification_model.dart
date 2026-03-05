import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String title;
  final String body;
  final String? targetCompanyId;
  final String senderRole;
  final bool isRead;
  final Timestamp? createdAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    this.targetCompanyId,
    required this.senderRole,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String docId) {
    return NotificationModel(
      id: docId,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      targetCompanyId: map['targetCompanyId'],
      senderRole: map['senderRole'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'targetCompanyId': targetCompanyId,
      'senderRole': senderRole,
      'isRead': isRead,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
