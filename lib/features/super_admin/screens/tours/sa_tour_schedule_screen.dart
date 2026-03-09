import 'package:flutter/material.dart';

import '../../../tours/presentation/screens/tour_schedule_screen.dart' as unified;

/// Super Admin rotasi icin ince sunum sarmalayicisi.
class SaTourScheduleScreen extends StatelessWidget {
  final String companyId;
  final String representativeTourId;
  final String? seriesId;
  final bool isDeleted;

  const SaTourScheduleScreen({
    super.key,
    required this.companyId,
    required this.representativeTourId,
    this.seriesId,
    required this.isDeleted,
  });

  @override
  Widget build(BuildContext context) => unified.TourScheduleScreen(
    companyId: companyId,
    representativeTourId: representativeTourId,
    seriesId: seriesId,
    isDeleted: isDeleted,
  );
}
