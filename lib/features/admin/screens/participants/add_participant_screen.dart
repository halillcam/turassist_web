import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../participants/presentation/screens/participant_add_screen.dart' as shared;

class AddParticipantScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const AddParticipantScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) {
    final companyId = Get.find<AuthController>().currentUser.value?.companyId ?? '';
    return shared.ParticipantAddScreen(
      tourId: tourId,
      companyId: companyId,
      departureDate: departureDate,
    );
  }
}
