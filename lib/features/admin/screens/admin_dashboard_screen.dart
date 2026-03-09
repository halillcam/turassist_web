import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../core/widgets/sidebar_menu.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'tours/active_tours_screen.dart';
import 'tours/passive_tours_screen.dart';
import 'tours/add_tour_screen.dart';
import 'tours/tour_completion_approval_screen.dart';
import 'feedback/admin_feedback_screen.dart';
import 'notifications/admin_notifications_screen.dart';

/// Admin panelinin ana iskelet ekranı.
///
/// Navigasyon ve şirket kimliği yönetimi [AdminDashboardController] tarafından
/// sağlanır. Tüm bağımlılıklar [AdminDashboardBinding] üzerinden enjekte edilir.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Binding tarafından kayıt edilmiş controller — Get.put() çağrısı gerekmez.
  late final AdminDashboardController _dashboardController;

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
    // Controller, AdminDashboardBinding tarafından kayıt edildi; sadece bulunur.
    _dashboardController = Get.find<AdminDashboardController>();
  }

  Future<void> _handleLogout() async {
    await Get.find<AuthController>().logout();
  }

  Widget _buildScreen(String? companyId, int selectedIndex) {
    if (companyId == null) {
      return const Center(
        child: Text('Şirket bilgisi bulunamadı.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    switch (selectedIndex) {
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
      body: Obx(
        () => Row(
          children: [
            SidebarMenu(
              title: 'Admin Panel',
              items: _menuItems,
              selectedIndex: _dashboardController.selectedIndex.value,
              onItemSelected: _dashboardController.setSelectedIndex,
              onLogout: _handleLogout,
            ),
            Expanded(
              child: _dashboardController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildScreen(
                      _dashboardController.companyId.value,
                      _dashboardController.selectedIndex.value,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
