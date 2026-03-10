import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/models/feedback_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../companies/data/models/company_dto.dart';
import '../../../companies/domain/entities/company_entity.dart';

/// Geri bildirim islemleri icin merkezi GetX controller.
///
/// Admin modunda [AdminFeedbackScreen]'den yeni geri bildirim gonderilir.
/// Super Admin modunda [SuperAdminFeedbackScreen]'de tum geri bildirimler
/// izlenir ve cozuldu/acik olarak isaretlenir.
class FeedbackController extends GetxController {
  final FirestoreService _db;
  final AuthService _auth;

  FeedbackController({required FirestoreService db, required AuthService auth})
    : _db = db,
      _auth = auth;

  // --- Reaktif State ---

  final feedbacks = <FeedbackModel>[].obs;
  final isLoading = false.obs;

  /// SA: companyId -> CompanyEntity onbellegi.
  final companyCache = <String, CompanyEntity>{}.obs;

  /// SA: adminUid -> UserModel onbellegi.
  final adminCache = <String, UserModel>{}.obs;

  StreamSubscription? _feedbackSub;

  // --- Computed ---

  List<FeedbackModel> get pendingFeedbacks => feedbacks.where((f) => !f.isResolved).toList();

  List<FeedbackModel> get resolvedFeedbacks => feedbacks.where((f) => f.isResolved).toList();

  // --- Yasam Dongusu ---

  @override
  void onClose() {
    _feedbackSub?.cancel();
    super.onClose();
  }

  // --- Super Admin Modu ---

  /// SA: tum geri bildirimleri gercek zamanli izler ve onbellegi gunceller.
  void watchAllFeedbacks() {
    _feedbackSub?.cancel();
    _feedbackSub = _db
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
          final list = snap.docs.map((d) => FeedbackModel.fromMap(d.data(), d.id)).toList();
          feedbacks.value = list;
          _populateCache(list);
        }, onError: _handleFeedbackError);
  }

  /// Sirket ve admin isimlerini onbellege alarak goruntuler.
  void _populateCache(List<FeedbackModel> list) {
    for (final fb in list) {
      final cid = fb.companyId;
      if (cid.isEmpty || companyCache.containsKey(cid)) continue;

      _db
          .getDocument('companies', cid)
          .then((doc) {
            if (!doc.exists || doc.data() == null) return;
            final company = CompanyDto.fromFirestore(doc.data()!, doc.id).toEntity();
            companyCache[cid] = company;

            final aUid = company.adminUid;
            if (aUid.isNotEmpty && !adminCache.containsKey(aUid)) {
              _db
                  .getDocument('users', aUid)
                  .then((uDoc) {
                    if (!uDoc.exists || uDoc.data() == null) return;
                    adminCache[aUid] = UserModel.fromMap(
                      uDoc.data() as Map<String, dynamic>,
                      uDoc.id,
                    );
                  })
                  .catchError((_) {});
            }
          })
          .catchError((_) {});
    }
  }

  void _handleFeedbackError(Object error) {
    feedbacks.clear();
    companyCache.clear();
    adminCache.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    Get.snackbar('Hata', error.toString(), snackPosition: SnackPosition.BOTTOM);
  }

  /// SA: Sirket adini onbellekten doner.
  String getCompanyName(String companyId) => companyCache[companyId]?.companyName ?? companyId;

  /// SA: Admin adini onbellekten doner.
  String getAdminName(String companyId) {
    final company = companyCache[companyId];
    if (company == null) return '-';
    return adminCache[company.adminUid]?.fullName ?? '-';
  }

  /// SA: Admin telefon numarasini onbellekten doner.
  String getAdminPhone(String companyId) {
    final company = companyCache[companyId];
    if (company == null) return '-';
    return adminCache[company.adminUid]?.phone ?? '-';
  }

  /// SA: Geri bildirimi cozuldu / acik olarak gunceller.
  Future<void> setResolved(FeedbackModel feedback, {required bool isResolved}) async {
    if (feedback.id == null) return;
    final currentUser = await _auth.getCurrentUserModel();
    final resolvedBy = currentUser?.fullName ?? 'Super Admin';

    await _db.updateDocument('feedbacks', feedback.id!, {
      'isResolved': isResolved,
      'resolvedBy': isResolved ? resolvedBy : null,
      'resolvedAt': isResolved ? FieldValue.serverTimestamp() : null,
    });
  }

  // --- Admin Modu ---

  /// Admin: yeni bir geri bildirim kaydi olusturur.
  ///
  /// [senderName] ve [senderPhone] verilmezse mevcut kullanicinin profilinden
  /// otomatik olarak alinir.
  Future<bool> sendFeedback({
    required String companyId,
    required String title,
    required String description,
    String senderName = '',
    String senderPhone = '',
  }) async {
    isLoading.value = true;
    try {
      String resolvedName = senderName;
      String resolvedPhone = senderPhone;
      if (resolvedName.isEmpty) {
        final user = await _auth.getCurrentUserModel();
        resolvedName = user?.fullName ?? '';
        resolvedPhone = user?.phone ?? '';
      }

      await _db
          .collection('feedbacks')
          .add(
            FeedbackModel(
              companyId: companyId,
              title: title,
              description: description,
              senderName: resolvedName,
              senderPhone: resolvedPhone,
            ).toMap(),
          );
      Get.snackbar('Basarili', 'Geri bildirim gonderildi.', snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      Get.snackbar('Hata', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
