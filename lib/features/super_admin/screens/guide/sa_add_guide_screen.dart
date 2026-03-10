import 'package:flutter/material.dart';

import '../../../guides/presentation/screens/guide_add_screen.dart' as shared;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaAddGuideScreen extends StatelessWidget {
  final String tourId;
  final String companyId;

  const SaAddGuideScreen({super.key, required this.tourId, required this.companyId});

  @override
  Widget build(BuildContext context) =>
      shared.GuideAddScreen(tourId: tourId, companyId: companyId);
}
