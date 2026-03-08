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
import '../../features/super_admin/screens/tours/sa_add_tour_screen.dart';
import '../../features/super_admin/screens/tours/sa_update_tour_screen.dart';
import '../../features/super_admin/screens/participants/sa_add_participant_screen.dart';
import '../../features/super_admin/screens/participants/sa_participants_list_screen.dart';
import '../../features/super_admin/screens/guide/sa_add_guide_screen.dart';
import '../../features/super_admin/screens/users/sa_add_user_screen.dart';

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
  static const String saAddTour = '/super-admin/add-tour';
  static const String saUpdateTour = '/super-admin/update-tour';
  static const String saAddParticipant = '/super-admin/add-participant';
  static const String saParticipantsList = '/super-admin/participants';
  static const String saAddGuide = '/super-admin/add-guide';
  static const String saAddUser = '/super-admin/add-user';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case superAdminDashboard:
        return MaterialPageRoute(builder: (_) => const SuperAdminDashboardScreen());

      case tourDetail:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => TourDetailScreen(tourId: tourId));

      case updateTour:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UpdateTourScreen(tourId: tourId));

      case addParticipant:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => AddParticipantScreen(tourId: tourId));

      case participantsList:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ParticipantsListScreen(tourId: tourId));

      case addGuide:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => AddGuideScreen(tourId: tourId));

      case updateCompany:
        final companyId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UpdateCompanyScreen(companyId: companyId));

      case superAdminTourDetail:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SuperAdminTourDetailScreen(tourId: tourId));

      case saAddTour:
        final companyId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SaAddTourScreen(companyId: companyId));

      case saUpdateTour:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SaUpdateTourScreen(tourId: tourId));

      case saAddParticipant:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) =>
              SaAddParticipantScreen(tourId: args['tourId']!, companyId: args['companyId']!),
        );

      case saParticipantsList:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SaParticipantsListScreen(tourId: tourId));

      case saAddGuide:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => SaAddGuideScreen(tourId: args['tourId']!, companyId: args['companyId']!),
        );

      case saAddUser:
        return MaterialPageRoute(builder: (_) => const SaAddUserScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
