import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/company_model.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/tour_entity.dart';
import '../../domain/usecases/add_tour_series_usecase.dart';
import '../../domain/usecases/add_tour_usecase.dart';
import '../../domain/usecases/delete_tour_usecase.dart';
import '../../domain/usecases/get_companies_usecase.dart';
import '../../domain/usecases/get_company_name_usecase.dart';
import '../../domain/usecases/get_tour_usecase.dart';
import '../../domain/usecases/stream_active_tours_usecase.dart';
import '../../domain/usecases/stream_deleted_tours_usecase.dart';
import '../../domain/usecases/stream_tour_usecase.dart';
import '../../domain/usecases/toggle_tour_active_usecase.dart';
import '../../domain/usecases/update_tour_usecase.dart';

class TourController extends GetxController {
  final StreamActiveToursUseCase _streamActiveTours;
  final StreamDeletedToursUseCase _streamDeletedTours;
  final StreamTourUseCase _streamTour;
  final GetTourUseCase _getTour;
  final AddTourUseCase _addTour;
  final AddTourSeriesUseCase _addTourSeries;
  final UpdateTourUseCase _updateTour;
  final DeleteTourUseCase _deleteTour;
  final ToggleTourActiveUseCase _toggleTourActive;
  final GetCompanyNameUseCase _getCompanyName;
  final GetCompaniesUseCase _getCompanies;

  TourController({
    required StreamActiveToursUseCase streamActiveTours,
    required StreamDeletedToursUseCase streamDeletedTours,
    required StreamTourUseCase streamTour,
    required GetTourUseCase getTour,
    required AddTourUseCase addTour,
    required AddTourSeriesUseCase addTourSeries,
    required UpdateTourUseCase updateTour,
    required DeleteTourUseCase deleteTour,
    required ToggleTourActiveUseCase toggleTourActive,
    required GetCompanyNameUseCase getCompanyName,
    required GetCompaniesUseCase getCompanies,
  }) : _streamActiveTours = streamActiveTours,
       _streamDeletedTours = streamDeletedTours,
       _streamTour = streamTour,
       _getTour = getTour,
       _addTour = addTour,
       _addTourSeries = addTourSeries,
       _updateTour = updateTour,
       _deleteTour = deleteTour,
       _toggleTourActive = toggleTourActive,
       _getCompanyName = getCompanyName,
       _getCompanies = getCompanies;

  // ─── Reaktif State ────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final activeTours = <TourEntity>[].obs;
  final deletedTours = <TourEntity>[].obs;
  final Rx<TourEntity?> selectedTour = Rx(null);

  // ─── Şirket seçimi (SuperAdmin için) ───────────────────────────────────────
  final companies = <CompanyModel>[].obs;
  final Rx<String?> selectedCompanyId = Rx(null);

  StreamSubscription? _activeSub;
  StreamSubscription? _deletedSub;
  StreamSubscription? _tourSub;

  // ─── Rol Bilgisi (UI katmanından sıfır Firebase bağımlılığı) ─────────────

  UserRole get currentRole => Get.find<AuthController>().currentUser.value?.role ?? UserRole.admin;

  bool get isSuperAdmin => currentRole == UserRole.superAdmin;

  // ─── Stream Abonelikleri ─────────────────────────────────────────────────

  void loadActiveTours(String companyId) {
    _activeSub?.cancel();
    _activeSub = _streamActiveTours(companyId).listen(
      (result) => result.fold(
        (failure) => _showError(failure.message),
        (tours) => activeTours.value = tours,
      ),
      onError: (error) => _handleStreamError(error, clearActive: true),
    );
  }

  void loadDeletedTours(String companyId) {
    _deletedSub?.cancel();
    _deletedSub = _streamDeletedTours(companyId).listen(
      (result) => result.fold(
        (failure) => _showError(failure.message),
        (tours) => deletedTours.value = tours,
      ),
      onError: (error) => _handleStreamError(error, clearDeleted: true),
    );
  }

  void watchTour(String tourId) {
    _tourSub?.cancel();
    _tourSub = _streamTour(tourId).listen(
      (result) => result.fold(
        (failure) => _showError(failure.message),
        (tour) => selectedTour.value = tour,
      ),
      onError: (error) => _handleStreamError(error, clearSelected: true),
    );
  }

  void stopWatchingTour() {
    _tourSub?.cancel();
    selectedTour.value = null;
  }

  @override
  void onClose() {
    _activeSub?.cancel();
    _deletedSub?.cancel();
    _tourSub?.cancel();
    super.onClose();
  }

  // ─── One-shot: Tur Getir ─────────────────────────────────────────────────

  Future<TourEntity?> getTour(String tourId) async {
    final result = await _getTour(tourId);
    return result.fold((failure) {
      _showError(failure.message);
      return null;
    }, (tour) => tour);
  }

  // ─── Yazma İşlemleri ─────────────────────────────────────────────────────

  /// Admin akışı: her kalkış tarihi için ayrı Firestore dökümanı oluşturur.
  Future<bool> addTourSeries(TourEntity tour) async {
    isLoading.value = true;
    final result = await _addTourSeries(tour);
    isLoading.value = false;
    return result.fold(
      (failure) {
        _showError(failure.message);
        return false;
      },
      (_) {
        _showSuccess('Tur serisi başarıyla oluşturuldu.');
        return true;
      },
    );
  }

  /// SuperAdmin akışı: tek bir Firestore dökümanı oluşturur.
  Future<bool> addSingleTour(TourEntity tour) async {
    isLoading.value = true;
    final result = await _addTour(tour);
    isLoading.value = false;
    return result.fold(
      (failure) {
        _showError(failure.message);
        return false;
      },
      (_) {
        _showSuccess('Tur başarıyla oluşturuldu.');
        return true;
      },
    );
  }

  Future<bool> updateTour(String tourId, Map<String, dynamic> data) async {
    isLoading.value = true;
    final result = await _updateTour(tourId, data);
    isLoading.value = false;
    return result.fold(
      (failure) {
        _showError(failure.message);
        return false;
      },
      (_) {
        _showSuccess('Tur güncellendi.');
        return true;
      },
    );
  }

  Future<bool> deleteTour(String tourId) async {
    isLoading.value = true;
    final result = await _deleteTour(tourId);
    isLoading.value = false;
    return result.fold(
      (failure) {
        _showError(failure.message);
        return false;
      },
      (_) {
        _showSuccess('Tur silindi.');
        return true;
      },
    );
  }

  Future<bool> toggleTourActive(TourEntity tour) async {
    final newState = tour.isDeleted; // isDeleted=true → aktife al
    isLoading.value = true;
    final result = await _toggleTourActive(tour.id, isActive: newState);
    isLoading.value = false;
    return result.fold(
      (failure) {
        _showError(failure.message);
        return false;
      },
      (_) {
        _showSuccess(newState ? 'Tur aktif edildi.' : 'Tur pasife alındı.');
        return true;
      },
    );
  }

  Future<String> fetchCompanyName(String companyId) async {
    final result = await _getCompanyName(companyId);
    return result.fold((_) => '', (name) => name);
  }

  // ─── Şirket Yönetimi (SA) ─────────────────────────────────────────────────

  Future<void> loadCompanies() async {
    final result = await _getCompanies();
    result.fold((failure) => _showError(failure.message), (list) => companies.value = list);
  }

  void selectCompany(String? id) {
    selectedCompanyId.value = id;
    if (id != null) {
      loadActiveTours(id);
      loadDeletedTours(id);
    } else {
      activeTours.clear();
      deletedTours.clear();
    }
  }

  // ─── Yardımcılar ─────────────────────────────────────────────────────────

  void _showError(String message) {
    Get.snackbar(
      'Hata',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _handleStreamError(
    Object error, {
    bool clearActive = false,
    bool clearDeleted = false,
    bool clearSelected = false,
  }) {
    if (clearActive) activeTours.clear();
    if (clearDeleted) deletedTours.clear();
    if (clearSelected) selectedTour.value = null;

    final message = error.toString().toLowerCase();
    if (message.contains('permission-denied') || message.contains('insufficient permissions')) {
      return;
    }
    _showError(error.toString());
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Başarılı',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
