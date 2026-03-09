import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/company_model.dart';
import '../models/tour_dto.dart';

abstract class ITourRemoteDataSource {
  Stream<List<TourDto>> streamActiveTours(String companyId);
  Stream<List<TourDto>> streamDeletedTours(String companyId);
  Stream<TourDto?> streamTour(String tourId);
  Future<TourDto> getTour(String tourId);
  Future<List<TourDto>> getToursByCompany(String companyId, {required bool isDeleted});
  Future<String> addTour(TourDto dto);
  Future<List<String>> addTourSeries(TourDto dto);
  Future<void> updateTour(String tourId, Map<String, dynamic> data);
  Future<void> deleteTour(String tourId);
  Future<void> setTourActive(String tourId, {required bool isActive});
  Future<String> getCompanyName(String companyId);
  Future<List<CompanyModel>> getCompanies();
}

class TourRemoteDataSource implements ITourRemoteDataSource {
  final FirebaseFirestore _db;

  TourRemoteDataSource({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tours => _db.collection('tours');

  // ─── Streams ─────────────────────────────────────────────────────────────

  @override
  Stream<List<TourDto>> streamActiveTours(String companyId) => _tours
      .where('companyId', isEqualTo: companyId)
      .where('isDeleted', isEqualTo: false)
      .snapshots()
      .map((s) => s.docs.map((d) => TourDto.fromJson(d.data(), d.id)).toList());

  @override
  Stream<List<TourDto>> streamDeletedTours(String companyId) => _tours
      .where('companyId', isEqualTo: companyId)
      .where('isDeleted', isEqualTo: true)
      .snapshots()
      .map((s) => s.docs.map((d) => TourDto.fromJson(d.data(), d.id)).toList());

  @override
  Stream<TourDto?> streamTour(String tourId) => _tours
      .doc(tourId)
      .snapshots()
      .map((d) => d.exists && d.data() != null ? TourDto.fromJson(d.data()!, d.id) : null);

  // ─── One-shot reads ───────────────────────────────────────────────────────

  @override
  Future<TourDto> getTour(String tourId) async {
    final doc = await _tours.doc(tourId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Tur bulunamadı: $tourId');
    }
    return TourDto.fromJson(doc.data()!, doc.id);
  }

  @override
  Future<List<TourDto>> getToursByCompany(String companyId, {required bool isDeleted}) async {
    final snap = await _tours
        .where('companyId', isEqualTo: companyId)
        .where('isDeleted', isEqualTo: isDeleted)
        .get();
    return snap.docs.map((d) => TourDto.fromJson(d.data(), d.id)).toList();
  }

  // ─── Writes ───────────────────────────────────────────────────────────────

  @override
  Future<String> addTour(TourDto dto) async {
    final payload = await _payloadWithCompanyName(dto);
    final ref = await _tours.add(payload);
    return ref.id;
  }

  @override
  Future<List<String>> addTourSeries(TourDto dto) async {
    final resolvedDates = _resolveDates(dto);
    if (resolvedDates.isEmpty) {
      final id = await addTour(dto);
      return [id];
    }

    final seriesId = 'series_${DateTime.now().microsecondsSinceEpoch}';
    final ids = <String>[];

    for (final date in resolvedDates) {
      final data = (await _payloadWithCompanyName(dto))
        ..['departureDate'] = Timestamp.fromDate(date)
        ..['seriesId'] = seriesId;
      final ref = await _tours.add(data);
      ids.add(ref.id);
    }
    return ids;
  }

  @override
  Future<void> updateTour(String tourId, Map<String, dynamic> data) =>
      _tours.doc(tourId).update(data);

  @override
  Future<void> deleteTour(String tourId) => _tours.doc(tourId).update({'isDeleted': true});

  @override
  Future<void> setTourActive(String tourId, {required bool isActive}) =>
      _tours.doc(tourId).update({'isDeleted': !isActive});

  // ─── Yardımcılar ─────────────────────────────────────────────────────────

  @override
  Future<String> getCompanyName(String companyId) async {
    final doc = await _db.collection('companies').doc(companyId).get();
    final data = doc.data();
    if (data == null) return '';
    return (data['companyName'] as String?) ?? (data['name'] as String?) ?? '';
  }

  @override
  Future<List<CompanyModel>> getCompanies() async {
    final snap = await _db.collection('companies').get();
    return snap.docs.map((d) => CompanyModel.fromMap(d.data(), d.id)).toList();
  }

  /// Dto'daki kalkış gün ve tarih konfigürasyonundan somut DateTime listesi üretir.
  /// Admin "addTourSeries" mantığını buraya taşıdık.
  List<DateTime> _resolveDates(TourDto dto) {
    if (dto.departureDates != null && dto.departureDates!.isNotEmpty) {
      return dto.departureDates!;
    }

    if (dto.departureDate != null) return [dto.departureDate!];

    // Haftalık tekrar: her seçili gün için önümüzdeki 4 haftayı üret
    if (dto.departureDays.isNotEmpty) {
      final dates = <DateTime>[];
      final now = DateTime.now();
      for (final weekday in dto.departureDays) {
        for (var week = 1; week <= 4; week++) {
          var candidate = now;
          while (candidate.weekday != weekday) {
            candidate = candidate.add(const Duration(days: 1));
          }
          candidate = candidate.add(Duration(days: (week - 1) * 7));
          dates.add(DateTime(candidate.year, candidate.month, candidate.day));
        }
      }
      return dates..sort();
    }

    return [];
  }

  Future<Map<String, dynamic>> _payloadWithCompanyName(TourDto dto) async {
    final companyName = dto.companyName.trim().isNotEmpty
        ? dto.companyName.trim()
        : await getCompanyName(dto.companyId);

    final payload = dto.toJson();
    payload['companyName'] = companyName;
    return payload;
  }
}
