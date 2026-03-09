import 'package:flutter/material.dart';

import '../../../../features/tours/presentation/screens/tour_detail_screen.dart' as unified;

/// Admin rotasi icin ince sunum sarmalayicisi.
class TourDetailScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const TourDetailScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) =>
      unified.TourDetailScreen(tourId: tourId, departureDate: departureDate);
}
