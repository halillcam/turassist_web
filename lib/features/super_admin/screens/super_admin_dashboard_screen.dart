import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/sidebar_menu.dart';
import '../controllers/company_controller.dart';
import '../controllers/sa_feedback_controller.dart';
import '../controllers/sa_notification_controller.dart';
import '../controllers/sa_tour_controller.dart';
import '../controllers/sa_user_controller.dart';
import 'companies/company_list_screen.dart';
import 'companies/add_company_screen.dart';
import 'users/user_list_screen.dart';
import 'tours/super_admin_tours_screen.dart';
import 'notifications/super_admin_notifications_screen.dart';
import 'feedback/super_admin_feedback_screen.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  int _selectedIndex = 0;
  final _authService = AuthService();

  final List<SidebarItem> _menuItems = const [
    SidebarItem(icon: Icons.business, label: AppStrings.companyList),
    SidebarItem(icon: Icons.add_business, label: AppStrings.addCompany),
    SidebarItem(icon: Icons.people, label: AppStrings.userList),
    SidebarItem(icon: Icons.tour, label: AppStrings.tours),
    SidebarItem(icon: Icons.notifications, label: AppStrings.notifications),
    SidebarItem(icon: Icons.feedback, label: AppStrings.feedback),
  ];

  final List<Widget> _screens = const [
    CompanyListScreen(),
    AddCompanyScreen(),
    UserListScreen(),
    SuperAdminToursScreen(),
    SuperAdminNotificationsScreen(),
    SuperAdminFeedbackScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(CompanyController());
    Get.put(SATourController());
    Get.put(SAUserController());
    Get.put(SANotificationController());
    Get.put(SAFeedbackController());
  }

  @override
  void dispose() {
    Get.delete<CompanyController>(force: true);
    Get.delete<SATourController>(force: true);
    Get.delete<SAUserController>(force: true);
    Get.delete<SANotificationController>(force: true);
    Get.delete<SAFeedbackController>(force: true);
    super.dispose();
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      }
    } catch (e) {
      Get.snackbar('Hata', 'Çıkış yapılamadı: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            title: 'Super Admin',
            items: _menuItems,
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            onLogout: _handleLogout,
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}
