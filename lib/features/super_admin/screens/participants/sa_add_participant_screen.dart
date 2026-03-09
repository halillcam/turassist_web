import 'package:flutter/material.dart';

import '../../../participants/presentation/screens/sa_add_participant_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaAddParticipantScreen extends StatelessWidget {
  final String tourId;
  final String companyId;
  final DateTime? departureDate;

  const SaAddParticipantScreen({
    super.key,
    required this.tourId,
    required this.companyId,
    this.departureDate,
  });

  @override
  Widget build(BuildContext context) => unified.SaAddParticipantScreen(
    tourId: tourId,
    companyId: companyId,
    departureDate: departureDate,
  );
}
