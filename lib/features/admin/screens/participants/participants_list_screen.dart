import 'package:flutter/material.dart';

import '../../../participants/presentation/screens/participant_list_screen.dart' as shared;

class ParticipantsListScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const ParticipantsListScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) {
    return shared.ParticipantListScreen(tourId: tourId, departureDate: departureDate);
  }
}
