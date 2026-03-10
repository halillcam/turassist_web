import 'dart:async';

import 'package:get/get.dart';

import '../../domain/entities/participant_ticket_entity.dart';
import '../../domain/entities/participant_user_entity.dart';
import '../../domain/usecases/add_participant_usecase.dart';
import '../../domain/usecases/get_participant_user_usecase.dart';
import '../../domain/usecases/watch_tickets_usecase.dart';

class ParticipantController extends GetxController {
  static const _customerEmailDomain = 'customer.turassist';

  final WatchTicketsUseCase _watchTickets;
  final GetParticipantUserUseCase _getParticipantUser;
  final AddParticipantUseCase _addParticipant;

  ParticipantController({
    required WatchTicketsUseCase watchTickets,
    required GetParticipantUserUseCase getParticipantUser,
    required AddParticipantUseCase addParticipant,
  }) : _watchTickets = watchTickets,
       _getParticipantUser = getParticipantUser,
       _addParticipant = addParticipant;

  final tickets = <ParticipantTicketEntity>[].obs;
  final isLoading = false.obs;

  StreamSubscription? _ticketsSub;

  String normalizeLoginId(String rawValue) => rawValue.trim().toUpperCase();

  String buildCustomerLoginEmail(String rawValue) {
    final normalized = normalizeLoginId(rawValue);
    return normalized.isEmpty ? '' : '$normalized@$_customerEmailDomain';
  }

  bool isValidLoginId(String rawValue) {
    final normalized = normalizeLoginId(rawValue);
    return normalized.isNotEmpty && RegExp(r'^[A-Z0-9-]+$').hasMatch(normalized);
  }

  void watchTickets(String tourId) {
    _ticketsSub?.cancel();
    _ticketsSub = _watchTickets(tourId).listen(
      (result) => result.fold(
        (failure) => _handleTicketsError(failure.message),
        (items) => tickets.value = items,
      ),
      onError: _handleTicketsError,
    );
  }

  void stopWatching() {
    _ticketsSub?.cancel();
    tickets.clear();
  }

  Future<ParticipantUserEntity?> getTicketUser(String userId) async {
    final result = await _getParticipantUser(userId);
    return result.fold((failure) {
      _showError(failure.message);
      return null;
    }, (user) => user);
  }

  List<ParticipantTicketEntity> filterTicketsByDate(
    List<ParticipantTicketEntity> allTickets,
    DateTime? departureDate,
  ) {
    if (departureDate == null) return allTickets;
    return allTickets.where((ticket) {
      final ticketDate = ticket.departureDate;
      return ticketDate != null &&
          ticketDate.year == departureDate.year &&
          ticketDate.month == departureDate.month &&
          ticketDate.day == departureDate.day;
    }).toList();
  }

  Future<bool> addParticipant({
    required String loginId,
    required String password,
    required String fullName,
    required String phone,
    required String tcNo,
    required String tourId,
    required String companyId,
    required double pricePaid,
    DateTime? departureDate,
  }) async {
    isLoading.value = true;
    try {
      final result = await _addParticipant(
        AddParticipantParams(
          loginId: loginId,
          password: password,
          fullName: fullName,
          phone: phone,
          tcNo: tcNo,
          tourId: tourId,
          companyId: companyId,
          pricePaid: pricePaid,
          departureDate: departureDate,
        ),
      );

      result.fold((failure) => throw StateError(failure.message), (_) {});

      _showSuccess('Katılımcı başarıyla eklendi.');
      return true;
    } catch (error) {
      _showError(_friendlyError(error));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _ticketsSub?.cancel();
    super.onClose();
  }

  void _handleTicketsError(Object error) {
    tickets.clear();
    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    _showError(error.toString());
  }

  String _friendlyError(Object error) {
    final msg = error.toString();
    if (msg.contains('kontenjan kalmadı')) {
      return 'Bu tur için kontenjan kalmadı.';
    }
    if (msg.contains('email-already-in-use')) {
      return 'Bu Müşteri ID zaten kullanılıyor.';
    }
    if (msg.contains('weak-password')) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    return 'İşlem başarısız: $msg';
  }

  void _showSuccess(String msg) {
    Get.snackbar('Başarılı', msg, snackPosition: SnackPosition.BOTTOM);
  }

  void _showError(String msg) {
    Get.snackbar('Hata', msg, snackPosition: SnackPosition.BOTTOM);
  }
}
