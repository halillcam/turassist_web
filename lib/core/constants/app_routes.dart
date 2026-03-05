import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/tours/tour_detail_screen.dart';
import '../../features/admin/screens/tours/update_tour_screen.dart';
import '../../features/admin/screens/participants/add_participant_screen.dart';
import '../../features/admin/screens/participants/participants_list_screen.dart';
import '../../features/admin/screens/guide/add_guide_screen.dart';
import '../../features/super_admin/screens/super_admin_dashboard_screen.dart';
import '../../features/super_admin/screens/companies/update_company_screen.dart';
import '../../features/super_admin/screens/tours/super_admin_tour_detail_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String adminDashboard = '/admin';
  static const String superAdminDashboard = '/super-admin';
  static const String tourDetail = '/admin/tour-detail';
  static const String updateTour = '/admin/update-tour';
  static const String addParticipant = '/admin/add-participant';
  static const String participantsList = '/admin/participants';
  static const String addGuide = '/admin/add-guide';
  static const String updateCompany = '/super-admin/update-company';
  static const String superAdminTourDetail = '/super-admin/tour-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
        );

      case superAdminDashboard:
        return MaterialPageRoute(
          builder: (_) => const SuperAdminDashboardScreen(),
        );

      case tourDetail:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TourDetailScreen(tourId: tourId),
        );

      case updateTour:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => UpdateTourScreen(tourId: tourId),
        );

      case addParticipant:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AddParticipantScreen(tourId: tourId),
        );

      case participantsList:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ParticipantsListScreen(tourId: tourId),
        );

      case addGuide:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AddGuideScreen(tourId: tourId),
        );

      case updateCompany:
        final companyId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => UpdateCompanyScreen(companyId: companyId),
        );

      case superAdminTourDetail:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SuperAdminTourDetailScreen(tourId: tourId),
        );

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
