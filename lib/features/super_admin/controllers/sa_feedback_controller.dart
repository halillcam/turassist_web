import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/company_model.dart';
import '../../../core/models/feedback_model.dart';
import '../../../core/models/user_model.dart';
import '../services/super_admin_service.dart';

class SAFeedbackController extends GetxController {
  final _service = SuperAdminService();

  final feedbacks = <FeedbackModel>[].obs;
  final companyCache = <String, CompanyModel>{}.obs;
  final adminCache = <String, UserModel>{}.obs;

  StreamSubscription? _feedbackSub;

  @override
  void onInit() {
    super.onInit();
    _feedbackSub = _service.streamAllFeedbacks().listen((list) {
      feedbacks.value = list;
      _resolveMissingData(list);
    }, onError: (e) => printError(info: 'feedbacks stream: $e'));
  }

  @override
  void onClose() {
    _feedbackSub?.cancel();
    super.onClose();
  }

  void _resolveMissingData(List<FeedbackModel> list) {
    for (final fb in list) {
      final cid = fb.companyId;
      if (cid.isNotEmpty && !companyCache.containsKey(cid)) {
        _service.getCompany(cid).then((c) {
          if (c != null) {
            companyCache[cid] = c;
            if (c.adminUid.isNotEmpty && !adminCache.containsKey(c.adminUid)) {
              _service.getUserByUid(c.adminUid).then((u) {
                if (u != null) adminCache[c.adminUid] = u;
              });
            }
          }
        });
      }
    }
  }

  String getCompanyName(String companyId) {
    return companyCache[companyId]?.companyName ?? companyId;
  }

  String getAdminName(String companyId) {
    final company = companyCache[companyId];
    if (company == null) return '-';
    return adminCache[company.adminUid]?.fullName ?? '-';
  }

  String getAdminPhone(String companyId) {
    final company = companyCache[companyId];
    if (company == null) return '-';
    return adminCache[company.adminUid]?.phone ?? '-';
  }
}
