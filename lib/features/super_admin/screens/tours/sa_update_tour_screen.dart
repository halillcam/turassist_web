import 'package:flutter/material.dart';

import '../../../tours/presentation/screens/update_tour_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaUpdateTourScreen extends StatelessWidget {
  final String tourId;

  const SaUpdateTourScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) => unified.UpdateTourScreen(tourId: tourId);
}
