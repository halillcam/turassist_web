import 'package:flutter/material.dart';

import '../../../../features/tours/presentation/screens/tour_schedule_screen.dart' as unified;

/// Admin rotasi icin ince sunum sarmalayicisi.
class TourScheduleScreen extends StatelessWidget {
  final String companyId;
  final String representativeTourId;
  final String? seriesId;

  const TourScheduleScreen({
    super.key,
    required this.companyId,
    required this.representativeTourId,
    this.seriesId,
  });

  @override
  Widget build(BuildContext context) => unified.TourScheduleScreen(
    companyId: companyId,
    representativeTourId: representativeTourId,
    seriesId: seriesId,
  );
}
