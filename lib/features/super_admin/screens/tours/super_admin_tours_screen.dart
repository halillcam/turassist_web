import 'package:flutter/material.dart';

import '../../../tours/presentation/screens/tours_list_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
///
/// Listeleme ve sekme mantigi merkezi [features/tours] modulu icindedir.
class SuperAdminToursScreen extends StatelessWidget {
  const SuperAdminToursScreen({super.key});

  @override
  Widget build(BuildContext context) => const unified.ToursListScreen();
}
