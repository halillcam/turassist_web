import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/tours/tour_detail_screen.dart';
import '../../features/admin/screens/tours/update_tour_screen.dart';
import '../../features/admin/screens/participants/add_participant_screen.dart';
import '../../features/admin/screens/participants/participants_list_screen.dart';
import '../../features/admin/screens/guide/add_guide_screen.dart';
import '../../features/admin/presentation/bindings/admin_dashboard_binding.dart';
import '../../features/super_admin/screens/super_admin_dashboard_screen.dart';
import '../../features/super_admin/screens/companies/update_company_screen.dart';
import '../../features/super_admin/screens/tours/super_admin_tour_detail_screen.dart';
import '../../features/super_admin/screens/tours/sa_add_tour_screen.dart';
import '../../features/super_admin/screens/tours/sa_update_tour_screen.dart';
import '../../features/super_admin/screens/participants/sa_add_participant_screen.dart';
import '../../features/super_admin/screens/participants/sa_participants_list_screen.dart';
import '../../features/super_admin/screens/guide/sa_add_guide_screen.dart';
import '../../features/super_admin/screens/users/sa_add_user_screen.dart';
import '../../features/super_admin/presentation/bindings/super_admin_dashboard_binding.dart';
import '../../features/admin/screens/tours/tour_communication_screen.dart';
import '../../features/tours/presentation/screens/tours_list_screen.dart';
import '../../features/tours/presentation/screens/tour_schedule_screen.dart';
import '../../features/tours/presentation/screens/tour_detail_screen.dart' as unified;
import '../../features/tours/presentation/screens/add_tour_screen.dart';
import '../../features/tours/presentation/screens/update_tour_screen.dart' as unified;
import '../../features/tours/presentation/bindings/tour_binding.dart';

class AppRoutes {
  AppRoutes._();

  static bool _asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
        case '1':
        case 'yes':
        case 'evet':
          return true;
        case 'false':
        case '0':
        case 'no':
        case 'hayir':
        case 'hayır':
          return false;
      }
    }
    return fallback;
  }

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

  // ─── Unified Tour Routes ─────────────────────────────────────────────────
  static const String toursList = '/tours';
  static const String toursSchedule = '/tours/schedule';
  static const String toursDetail = '/tours/detail';
  static const String toursAdd = '/tours/add';
  static const String toursUpdate = '/tours/update';
  static const String tourCommunication = '/admin/tour-communication';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return GetPageRoute(
          settings: settings,
          binding: AuthBinding(),
          page: () => const LoginScreen(),
        );

      case adminDashboard:
        return GetPageRoute(
          settings: settings,
          binding: AdminDashboardBinding(),
          page: () => const AdminDashboardScreen(),
        );

      case superAdminDashboard:
        return GetPageRoute(
          settings: settings,
          binding: SuperAdminDashboardBinding(),
          page: () => const SuperAdminDashboardScreen(),
        );

      case tourDetail:
        final tourDetailArgs = settings.arguments;
        final String tourDetailId;
        DateTime? tourDetailDate;
        if (tourDetailArgs is String) {
          tourDetailId = tourDetailArgs;
        } else {
          final map = tourDetailArgs as Map<String, dynamic>;
          tourDetailId = map['tourId'] as String;
          tourDetailDate = map['departureDate'] as DateTime?;
        }
        return MaterialPageRoute(
          builder: (_) => TourDetailScreen(tourId: tourDetailId, departureDate: tourDetailDate),
        );

      case updateTour:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UpdateTourScreen(tourId: tourId));

      case addParticipant:
        final apArgs = settings.arguments;
        final String apTourId;
        DateTime? apDate;
        if (apArgs is String) {
          apTourId = apArgs;
        } else {
          final map = apArgs as Map<String, dynamic>;
          apTourId = map['tourId'] as String;
          apDate = map['departureDate'] as DateTime?;
        }
        return MaterialPageRoute(
          builder: (_) => AddParticipantScreen(tourId: apTourId, departureDate: apDate),
        );

      case participantsList:
        final plArgs = settings.arguments;
        final String plTourId;
        DateTime? plDate;
        if (plArgs is String) {
          plTourId = plArgs;
        } else {
          final map = plArgs as Map<String, dynamic>;
          plTourId = map['tourId'] as String;
          plDate = map['departureDate'] as DateTime?;
        }
        return MaterialPageRoute(
          builder: (_) => ParticipantsListScreen(tourId: plTourId, departureDate: plDate),
        );

      case addGuide:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => AddGuideScreen(tourId: tourId));

      case updateCompany:
        final companyId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => UpdateCompanyScreen(companyId: companyId));

      case superAdminTourDetail:
        final saTourArgs = settings.arguments;
        final String saTourId;
        DateTime? saTourDate;
        if (saTourArgs is String) {
          saTourId = saTourArgs;
        } else {
          final map = saTourArgs as Map<String, dynamic>;
          saTourId = map['tourId'] as String;
          saTourDate = map['departureDate'] as DateTime?;
        }
        return MaterialPageRoute(
          builder: (_) => SuperAdminTourDetailScreen(tourId: saTourId, departureDate: saTourDate),
        );

      case saAddTour:
        final companyId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SaAddTourScreen(companyId: companyId));

      case saUpdateTour:
        final tourId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SaUpdateTourScreen(tourId: tourId));

      case saAddParticipant:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SaAddParticipantScreen(
            tourId: args['tourId'] as String,
            companyId: args['companyId'] as String,
            departureDate: args['departureDate'] as DateTime?,
          ),
        );

      case saParticipantsList:
        final args = settings.arguments;
        final String tourId;
        DateTime? departureDate;
        if (args is String) {
          tourId = args;
        } else {
          final map = args as Map<String, dynamic>;
          tourId = map['tourId'] as String;
          departureDate = map['departureDate'] as DateTime?;
        }
        return MaterialPageRoute(
          builder: (_) => SaParticipantsListScreen(tourId: tourId, departureDate: departureDate),
        );

      case saAddGuide:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => SaAddGuideScreen(tourId: args['tourId']!, companyId: args['companyId']!),
        );

      case saAddUser:
        return MaterialPageRoute(builder: (_) => const SaAddUserScreen());

      // ─── Unified Tour Routes ──────────────────────────────────────────────
      case toursList:
        final companyId = settings.arguments as String?;
        return GetPageRoute(
          settings: settings,
          binding: TourBinding(),
          page: () => ToursListScreen(companyId: companyId),
        );

      case toursSchedule:
        final scheduleArgs = settings.arguments as Map<String, dynamic>;
        return GetPageRoute(
          settings: settings,
          binding: TourBinding(),
          page: () => TourScheduleScreen(
            companyId: scheduleArgs['companyId'] as String,
            representativeTourId: scheduleArgs['representativeTourId'] as String,
            seriesId: scheduleArgs['seriesId'] as String?,
            isDeleted: _asBool(scheduleArgs['isDeleted']),
          ),
        );

      case toursDetail:
        final detailArgs = settings.arguments as Map<String, dynamic>;
        return GetPageRoute(
          settings: settings,
          binding: TourBinding(),
          page: () => unified.TourDetailScreen(
            tourId: detailArgs['tourId'] as String,
            departureDate: detailArgs['departureDate'] as DateTime?,
          ),
        );

      case toursAdd:
        final addCompanyId = settings.arguments as String;
        return GetPageRoute(
          settings: settings,
          binding: TourBinding(),
          page: () => AddTourScreen(companyId: addCompanyId),
        );

      case toursUpdate:
        final updateTourId = settings.arguments as String;
        return GetPageRoute(
          settings: settings,
          binding: TourBinding(),
          page: () => unified.UpdateTourScreen(tourId: updateTourId),
        );

      case tourCommunication:
        final commArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TourCommunicationScreen(
            tourId: commArgs['tourId'] as String,
            tourTitle: commArgs['tourTitle'] as String,
            initialTabIndex: (commArgs['initialTabIndex'] as int?) ?? 0,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
