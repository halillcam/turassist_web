import 'package:flutter/material.dart';

import '../../../tours/presentation/screens/add_tour_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaAddTourScreen extends StatelessWidget {
  final String companyId;

  const SaAddTourScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) => unified.AddTourScreen(companyId: companyId);
}
