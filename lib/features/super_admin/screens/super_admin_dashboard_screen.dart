import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../core/widgets/sidebar_menu.dart';
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

  // initState ve dispose temizlendi — tüm controller'lar SuperAdminDashboardBinding tarafından yönetilir

  Future<void> _handleLogout() async {
    await Get.find<AuthController>().logout();
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
