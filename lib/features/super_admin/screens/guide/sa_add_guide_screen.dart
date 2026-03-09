import 'package:flutter/material.dart';

import '../../../guides/presentation/screens/sa_add_guide_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaAddGuideScreen extends StatelessWidget {
  final String tourId;
  final String companyId;

  const SaAddGuideScreen({super.key, required this.tourId, required this.companyId});

  @override
  Widget build(BuildContext context) =>
      unified.SaAddGuideScreen(tourId: tourId, companyId: companyId);
}
