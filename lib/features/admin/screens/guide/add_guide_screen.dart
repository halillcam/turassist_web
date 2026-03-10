import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../guides/presentation/screens/guide_add_screen.dart' as shared;

class AddGuideScreen extends StatelessWidget {
  final String tourId;

  const AddGuideScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) {
    final companyId = Get.find<AuthController>().currentUser.value?.companyId ?? '';
    return shared.GuideAddScreen(tourId: tourId, companyId: companyId);
  }
}
