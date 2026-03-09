import 'package:flutter/material.dart';

import '../../../../features/tours/presentation/screens/add_tour_screen.dart' as unified;

/// Admin rotasi icin ince sunum sarmalayicisi.
///
/// Tum is mantigi merkezi [features/tours] modulu icindedir.
class AddTourScreen extends StatelessWidget {
  final String companyId;

  const AddTourScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) => unified.AddTourScreen(companyId: companyId);
}
