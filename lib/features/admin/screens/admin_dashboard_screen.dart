import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/sidebar_menu.dart';
import 'tours/active_tours_screen.dart';
import 'tours/passive_tours_screen.dart';
import 'tours/add_tour_screen.dart';
import 'tours/tour_completion_approval_screen.dart';
import 'feedback/admin_feedback_screen.dart';
import 'notifications/admin_notifications_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<SidebarItem> _menuItems = const [
    SidebarItem(icon: Icons.tour, label: AppStrings.activeTours),
    SidebarItem(icon: Icons.history, label: AppStrings.passiveTours),
    SidebarItem(icon: Icons.add_circle, label: AppStrings.addTour),
    SidebarItem(icon: Icons.check_circle, label: AppStrings.tourCompletionApproval),
    SidebarItem(icon: Icons.feedback, label: AppStrings.feedback),
    SidebarItem(icon: Icons.notifications, label: AppStrings.notifications),
  ];

  final List<Widget> _screens = const [
    ActiveToursScreen(),
    PassiveToursScreen(),
    AddTourScreen(),
    TourCompletionApprovalScreen(),
    AdminFeedbackScreen(),
    AdminNotificationsScreen(),
  ];

  void _handleLogout() {
    // TODO: Çıkış işlemi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            title: 'Admin Panel',
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
