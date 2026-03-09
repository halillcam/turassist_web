import 'package:flutter/material.dart';

import '../../../participants/presentation/screens/sa_participants_list_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaParticipantsListScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const SaParticipantsListScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) =>
      unified.SaParticipantsListScreen(tourId: tourId, departureDate: departureDate);
}
