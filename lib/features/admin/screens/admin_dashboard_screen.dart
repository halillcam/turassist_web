import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/sidebar_menu.dart';
import '../services/admin_tour_service.dart';
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
  final _authService = AuthService();
  final _tourService = AdminTourService();

  int _selectedIndex = 0;
  String? _companyId;
  bool _isLoading = true;

  static const _menuItems = [
    SidebarItem(icon: Icons.tour, label: AppStrings.activeTours),
    SidebarItem(icon: Icons.history, label: AppStrings.passiveTours),
    SidebarItem(icon: Icons.add_circle, label: AppStrings.addTour),
    SidebarItem(icon: Icons.check_circle, label: AppStrings.tourCompletionApproval),
    SidebarItem(icon: Icons.feedback, label: AppStrings.feedback),
    SidebarItem(icon: Icons.notifications, label: AppStrings.notifications),
  ];

  @override
  void initState() {
    super.initState();
    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final id = await _tourService.getCurrentCompanyId();
    if (!mounted) return;
    setState(() {
      _companyId = id;
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Widget _buildScreen() {
    final companyId = _companyId;
    if (companyId == null) {
      return const Center(
        child: Text('Şirket bilgisi bulunamadı.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return ActiveToursScreen(companyId: companyId);
      case 1:
        return PassiveToursScreen(companyId: companyId);
      case 2:
        return AddTourScreen(companyId: companyId);
      case 3:
        return TourCompletionApprovalScreen(companyId: companyId);
      case 4:
        return AdminFeedbackScreen(companyId: companyId);
      case 5:
        return AdminNotificationsScreen(companyId: companyId);
      default:
        return ActiveToursScreen(companyId: companyId);
    }
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
          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildScreen(),
          ),
        ],
      ),
    );
  }
}
