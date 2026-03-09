import 'package:flutter/material.dart';

import '../../../../features/tours/presentation/screens/update_tour_screen.dart' as unified;

/// Admin rotasi icin ince sunum sarmalayicisi.
///
/// Tum guncelleme mantigi merkezi [features/tours] modulu icindedir.
class UpdateTourScreen extends StatelessWidget {
  final String tourId;

  const UpdateTourScreen({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) => unified.UpdateTourScreen(tourId: tourId);
}
