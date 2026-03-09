import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/company_model.dart';
import '../entities/tour_entity.dart';

abstract class ITourRepository {
  /// Şirkete ait aktif turları gerçek zamanlı dinler.
  Stream<Either<Failure, List<TourEntity>>> streamActiveTours(String companyId);

  /// Şirkete ait pasif/silinmiş turları gerçek zamanlı dinler.
  Stream<Either<Failure, List<TourEntity>>> streamDeletedTours(String companyId);

  /// Belirli bir turu gerçek zamanlı dinler.
  Stream<Either<Failure, TourEntity?>> streamTour(String tourId);

  /// Belirli bir turu tek seferlik getirir.
  Future<Either<Failure, TourEntity>> getTour(String tourId);

  /// Şirkete ait tüm turları (aktif veya pasif) tek seferlik getirir.
  Future<Either<Failure, List<TourEntity>>> getToursByCompany(
    String companyId, {
    required bool isDeleted,
  });

  /// Yeni bir tur ekler. Tek döküman, serializasyon caller sorumluluğunda.
  Future<Either<Failure, String>> addTour(TourEntity tour);

  /// Birden fazla kalkış tarihine sahip tur serisi oluşturur.
  /// Her tarih için ayrı Firestore dökümanı yaratır; aynı seriesId paylaşırlar.
  Future<Either<Failure, List<String>>> addTourSeries(TourEntity tour);

  /// Mevcut tur dökümanının belirtilen alanlarını günceller.
  Future<Either<Failure, Unit>> updateTour(String tourId, Map<String, dynamic> data);

  /// Turu mantıksal olarak siler (isDeleted = true).
  Future<Either<Failure, Unit>> deleteTour(String tourId);

  /// Turun aktif/pasif durumunu değiştirir.
  Future<Either<Failure, Unit>> setTourActive(String tourId, {required bool isActive});

  /// Şirket adını getirir (tur oluştururken companyName alanı için).
  Future<Either<Failure, String>> getCompanyName(String companyId);

  /// Tüm şirketleri getirir (SA şirket seçici için).
  Future<Either<Failure, List<CompanyModel>>> getCompanies();
}
