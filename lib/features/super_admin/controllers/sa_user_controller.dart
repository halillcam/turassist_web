import 'dart:async';

import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../services/super_admin_service.dart';

class SAUserController extends GetxController {
  final _service = SuperAdminService();

  final allUsers = <UserModel>[].obs;
  final searchQuery = ''.obs;
  final selectedRole = RxnString();

  StreamSubscription? _usersSub;

  @override
  void onInit() {
    super.onInit();
    _usersSub = _service.streamAllUsers().listen(
      (list) => allUsers.value = list,
      onError: (e) => printError(info: 'allUsers stream: $e'),
    );
  }

  @override
  void onClose() {
    _usersSub?.cancel();
    super.onClose();
  }

  List<UserModel> get filteredUsers {
    var list = allUsers.toList();

    final role = selectedRole.value;
    if (role != null && role.isNotEmpty) {
      list = list.where((u) => u.role == role).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((u) {
        return u.fullName.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.phone.contains(query);
      }).toList();
    }

    return list;
  }
}
