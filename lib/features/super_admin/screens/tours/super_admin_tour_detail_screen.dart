import 'package:flutter/material.dart';

import '../../../tours/presentation/screens/tour_detail_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
///
/// Tum detay ve rehber yonetimi mantigi merkezi tur detay ekranindadir.
class SuperAdminTourDetailScreen extends StatelessWidget {
  final String tourId;
  final DateTime? departureDate;

  const SuperAdminTourDetailScreen({super.key, required this.tourId, this.departureDate});

  @override
  Widget build(BuildContext context) =>
      unified.TourDetailScreen(tourId: tourId, departureDate: departureDate);
}
