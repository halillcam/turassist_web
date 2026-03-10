import 'package:flutter/material.dart';

import '../../../participants/presentation/screens/participant_list_screen.dart' as shared;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaParticipantsListScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const SaParticipantsListScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) =>
      shared.ParticipantListScreen(tourId: tourId, departureDate: departureDate);
}
