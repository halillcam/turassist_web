import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../users/domain/entities/managed_user_entity.dart';
import '../../../users/presentation/controllers/user_controller.dart';
import '../../domain/entities/tour_entity.dart';
import '../controllers/tour_controller.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;
  final DateTime? departureDate;

  const TourDetailScreen({super.key, required this.tourId, this.departureDate});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  late final TourController _controller;
  late final UserController _userController;

  static const _dayLabels = {
    1: 'Pazartesi',
    2: 'Salı',
    3: 'Çarşamba',
    4: 'Perşembe',
    5: 'Cuma',
    6: 'Cumartesi',
    7: 'Pazar',
  };

  @override
  void initState() {
    super.initState();
    _controller = Get.find<TourController>();
    _userController = Get.find<UserController>();
    _controller.watchTour(widget.tourId);
  }

  @override
  void dispose() {
    _controller.stopWatchingTour();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tourDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        final tour = _controller.selectedTour.value;
        if (tour == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.departureDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary.withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Seçilen Çıkış Tarihi: ${DateFormat('dd.MM.yyyy').format(widget.departureDate!)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              _buildActionButtons(tour),
              const SizedBox(height: 24),
              _buildInfoCard(tour),
              const SizedBox(height: 16),
              _buildGuideCard(tour),
              const SizedBox(height: 16),
              _buildBusInfoCard(tour),
              const SizedBox(height: 16),
              _buildDepartureCard(tour),
              if (tour.program.isNotEmpty) ...[const SizedBox(height: 16), _buildProgramCard(tour)],
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // ─── Action Buttons ──────────────────────────────────────────────────────

  Widget _buildActionButtons(TourEntity tour) {
    final isSA = _controller.isSuperAdmin;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _actionButton(
          AppStrings.participants,
          Icons.people,
          AppColors.primary,
          () => Navigator.pushNamed(
            context,
            isSA ? AppRoutes.saParticipantsList : AppRoutes.participantsList,
            arguments: {'tourId': tour.id, 'departureDate': widget.departureDate},
          ),
        ),
        _actionButton(
          AppStrings.addParticipant,
          Icons.person_add,
          AppColors.success,
          () => Navigator.pushNamed(
            context,
            isSA ? AppRoutes.saAddParticipant : AppRoutes.addParticipant,
            arguments: isSA
                ? {
                    'tourId': tour.id,
                    'companyId': tour.companyId,
                    'departureDate': widget.departureDate,
                  }
                : {'tourId': tour.id, 'departureDate': widget.departureDate},
          ),
        ),
        _actionButton(
          tour.guideId.isEmpty ? AppStrings.addGuide : AppStrings.editGuide,
          Icons.admin_panel_settings,
          AppColors.warning,
          () => tour.guideId.isEmpty
              ? Navigator.pushNamed(
                  context,
                  isSA ? AppRoutes.saAddGuide : AppRoutes.addGuide,
                  arguments: isSA ? {'tourId': tour.id, 'companyId': tour.companyId} : tour.id,
                )
              : _showGuideEditor(tour),
        ),
        _actionButton(
          AppStrings.updateTour,
          Icons.edit,
          AppColors.primaryLight,
          () => Navigator.pushNamed(context, AppRoutes.toursUpdate, arguments: tour.id),
        ),
        // Admin-only: communication buttons
        if (!isSA) ...[
          _actionButton(
            'Mesajlar',
            Icons.forum_outlined,
            AppColors.info,
            () => _openCommunication(tour, initialTabIndex: 0),
          ),
          _actionButton(
            'Duyurular',
            Icons.campaign_outlined,
            AppColors.secondary,
            () => _openCommunication(tour, initialTabIndex: 1),
          ),
        ],
        _actionButton(
          tour.isDeleted ? AppStrings.active : AppStrings.passive,
          tour.isDeleted ? Icons.check_circle_outline : Icons.pause_circle_outline,
          tour.isDeleted ? AppColors.success : AppColors.warning,
          () => _confirmToggleActive(tour),
        ),
        _actionButton(AppStrings.delete, Icons.delete, AppColors.error, () => _confirmDelete(tour)),
      ],
    );
  }

  Widget _actionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _confirmToggleActive(TourEntity tour) {
    final willBeActive = tour.isDeleted;
    final actionLabel = willBeActive ? 'Aktif Yap' : 'Pasif Yap';
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: actionLabel,
        message: '"${tour.title}" turunu $actionLabel işlemini onaylıyor musunuz?',
        confirmText: actionLabel,
        onConfirm: () async {
          await _controller.toggleTourActive(tour);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(TourEntity tour) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Turu Sil',
        message: '"${tour.title}" turunu silmek istediğinize emin misiniz?',
        confirmText: 'Sil',
        onConfirm: () async {
          await _controller.deleteTour(tour);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _openCommunication(TourEntity tour, {required int initialTabIndex}) {
    // Sadece admin erişebilir; TourCommunicationScreen admin pakette.
    Navigator.pushNamed(
      context,
      AppRoutes.tourCommunication,
      arguments: {'tourId': tour.id, 'tourTitle': tour.title, 'initialTabIndex': initialTabIndex},
    );
  }

  // ─── Info Cards ──────────────────────────────────────────────────────────

  Widget _buildInfoCard(TourEntity tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Tur Bilgileri'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                _infoItem('Başlık', tour.title),
                _infoItem('Fiyat', '₺${tour.price.toStringAsFixed(0)}'),
                _infoItem('Kapasite', '${tour.capacity}'),
                _infoItem('Şehir', tour.city),
                _infoItem('Bölge', tour.region),
                _infoItem('Rehber', tour.guideName ?? '-'),
                _statusBadge(!tour.isDeleted),
              ],
            ),
            if (tour.description.isNotEmpty) ...[
              const Divider(height: 32),
              _infoItem('Açıklama', tour.description),
            ],
            if (tour.extraDetail.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem('Ekstra Detay', tour.extraDetail),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(TourEntity tour) {
    return FutureBuilder<ManagedUserEntity?>(
      future: tour.guideId.isEmpty
          ? Future.value(null)
          : _userController.getUserByUid(tour.guideId),
      builder: (context, snapshot) {
        final guide = snapshot.data;
        final usesGuideLoginId =
            guide != null && AuthService.isGeneratedGuideLoginEmail(guide.email);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _sectionTitle(AppStrings.guideManagement),
                    const Spacer(),
                    if (guide != null) _statusBadge(!guide.isDeleted),
                  ],
                ),
                const SizedBox(height: 16),
                if (guide == null)
                  const Text(
                    'Bu tura henüz rehber atanmadı.',
                    style: TextStyle(color: AppColors.textSecondary),
                  )
                else ...[
                  Wrap(
                    spacing: 32,
                    runSpacing: 12,
                    children: [
                      _infoItem('Ad Soyad', guide.fullName),
                      _infoItem('Telefon', guide.phone.isEmpty ? '-' : guide.phone),
                      _infoItem(
                        usesGuideLoginId ? 'Guide ID' : 'E-posta',
                        usesGuideLoginId ? AuthService.extractGuideId(guide.email) : guide.email,
                      ),
                      _PasswordInfoItem(label: 'Giriş Parolası', password: guide.guidePassword),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showGuideEditor(tour, guide: guide),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text(AppStrings.editGuide),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _toggleGuideActive(guide),
                        icon: Icon(guide.isDeleted ? Icons.visibility : Icons.visibility_off),
                        label: Text(guide.isDeleted ? AppStrings.activate : AppStrings.deactivate),
                      ),
                      if (!usesGuideLoginId)
                        OutlinedButton.icon(
                          onPressed: () => _sendGuidePasswordReset(guide),
                          icon: const Icon(Icons.lock_reset),
                          label: const Text(AppStrings.sendPasswordReset),
                        ),
                    ],
                  ),
                  if (usesGuideLoginId) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Bu hesap için e-posta doğrulaması ve şifre sıfırlama maili kullanılmaz.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusInfoCard(TourEntity tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Araç Bilgileri'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 12,
              children: [
                _infoItem('Şoför Adı', tour.busInfo.driverName),
                _infoItem('Telefon', tour.busInfo.phoneNumber),
                _infoItem('Plaka', tour.busInfo.plate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureCard(TourEntity tour) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Çıkış Bilgileri'),
            const SizedBox(height: 16),
            _infoItem('Çıkış Saati', tour.departureTime),
            if (tour.departureDays.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem(
                'Haftalık Çıkış Günleri',
                tour.departureDays.map((d) => _dayLabels[d] ?? '').join(', '),
              ),
            ],
            if (tour.departureDate != null) ...[
              const SizedBox(height: 8),
              _infoItem('Çıkış Tarihi', dateFormat.format(tour.departureDate!)),
            ],
            if (tour.departureDates != null && tour.departureDates!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem(
                'Özel Çıkış Tarihleri',
                tour.departureDates!.map((d) => dateFormat.format(d)).join(', '),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgramCard(TourEntity tour) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Tur Programı'),
            const SizedBox(height: 16),
            for (final day in tour.program) ...[
              Text(day.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              for (final act in day.activities)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                      Expanded(child: Text(act)),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Guide Management ─────────────────────────────────────────────────────

  Future<void> _toggleGuideActive(ManagedUserEntity guide) async {
    await _userController.toggleUserActive(guide.uid!, isActive: guide.isDeleted);
    if (mounted) setState(() {});
  }

  Future<void> _sendGuidePasswordReset(ManagedUserEntity guide) async {
    if (AuthService.isGeneratedGuideLoginEmail(guide.email)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu guide hesabı için şifre sıfırlama maili kullanılmaz.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    try {
      await AuthService.sendPasswordReset(guide.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şifre sıfırlama maili ${guide.email} adresine gönderildi.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
    }
  }

  Future<void> _showGuideEditor(TourEntity tour, {ManagedUserEntity? guide}) {
    final fullNameCtrl = TextEditingController(text: guide?.fullName ?? tour.guideName ?? '');
    final phoneCtrl = TextEditingController(text: guide?.phone ?? '');
    final newPasswordCtrl = TextEditingController();
    final loginIdentifier = guide == null
        ? ''
        : AuthService.isGeneratedGuideLoginEmail(guide.email)
        ? AuthService.extractGuideId(guide.email)
        : guide.email;
    final loginIdentifierLabel = guide == null
        ? 'Guide ID'
        : AuthService.isGeneratedGuideLoginEmail(guide.email)
        ? 'Guide ID'
        : 'Giriş E-postası';

    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.editGuide),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullNameCtrl,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Telefon'),
              ),
              if (guide != null) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(text: loginIdentifier),
                  enabled: false,
                  decoration: InputDecoration(labelText: loginIdentifierLabel),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _PasswordInfoItem(
                    label: 'Mevcut Giriş Parolası',
                    password: guide.guidePassword,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Yeni Giriş Parolası',
                    hintText: guide.guidePassword != null
                        ? 'Boş bırakırsanız parola değişmez'
                        : 'Mevcut parola kayıtlı değil',
                    helperText: guide.guidePassword == null
                        ? 'Bu hesabın parolası yönetim sistemine kaydedilmemiş, değiştirilemiyor.'
                        : null,
                    helperMaxLines: 2,
                    enabled: guide.guidePassword != null,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
          FilledButton(
            onPressed: guide == null
                ? () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      _controller.isSuperAdmin ? AppRoutes.saAddGuide : AppRoutes.addGuide,
                      arguments: _controller.isSuperAdmin
                          ? {'tourId': tour.id, 'companyId': tour.companyId}
                          : tour.id,
                    );
                  }
                : () async {
                    await _userController.updateUser(guide.uid!, {
                      'fullName': fullNameCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                    });
                    await _controller.updateTour(tour.id, {'guideName': fullNameCtrl.text.trim()});
                    final newPwd = newPasswordCtrl.text.trim();
                    if (newPwd.isNotEmpty && guide.guidePassword != null) {
                      try {
                        await AuthService.updateUserPasswordWithSecondaryApp(
                          email: guide.email,
                          currentPassword: guide.guidePassword!,
                          newPassword: newPwd,
                        );
                        await _userController.updateUser(guide.uid!, {'guidePassword': newPwd});
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Parola güncellenemedi: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                    setState(() {});
                  },
            child: Text(guide == null ? AppStrings.addGuide : AppStrings.save),
          ),
        ],
      ),
    ).whenComplete(() {
      fullNameCtrl.dispose();
      phoneCtrl.dispose();
      newPasswordCtrl.dispose();
    });
  }

  // ─── Utility Widgets ─────────────────────────────────────────────────────

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    final color = isActive ? AppColors.success : AppColors.error;
    final label = isActive ? AppStrings.active : AppStrings.passive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Durum',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─── Password Info Item ────────────────────────────────────────────────────

class _PasswordInfoItem extends StatefulWidget {
  final String label;
  final String? password;

  const _PasswordInfoItem({required this.label, this.password});

  @override
  State<_PasswordInfoItem> createState() => _PasswordInfoItemState();
}

class _PasswordInfoItemState extends State<_PasswordInfoItem> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final display = widget.password != null ? (_visible ? widget.password! : '••••••••') : '---';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(display, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            if (widget.password != null) ...[
              const SizedBox(width: 6),
              InkWell(
                onTap: () => setState(() => _visible = !_visible),
                borderRadius: BorderRadius.circular(4),
                child: Icon(
                  _visible ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
