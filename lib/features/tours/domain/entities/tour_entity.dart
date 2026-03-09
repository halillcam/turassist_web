import 'package:freezed_annotation/freezed_annotation.dart';

part 'tour_entity.freezed.dart';

@freezed
class BusInfoEntity with _$BusInfoEntity {
  const factory BusInfoEntity({
    required String driverName,
    required String phoneNumber,
    required String plate,
    required int capacity,
  }) = _BusInfoEntity;

  factory BusInfoEntity.empty() =>
      const BusInfoEntity(driverName: '', phoneNumber: '', plate: '', capacity: 0);
}

@freezed
class DayProgramEntity with _$DayProgramEntity {
  const factory DayProgramEntity({
    required String id,
    required String title,
    required int day,
    required int order,
    required List<String> activities,
  }) = _DayProgramEntity;
}

@freezed
class TourEntity with _$TourEntity {
  const factory TourEntity({
    required String id,
    required String title,
    required String description,
    required String extraDetail,
    required double price,
    required String imageUrl,
    required String companyId,
    required String companyName,
    required String guideId,
    String? guideName,
    required int capacity,
    required String city,
    required String region,
    required BusInfoEntity busInfo,
    required List<DayProgramEntity> program,

    /// Haftalık tekrar günleri: 1=Pzt … 7=Pzr
    required List<int> departureDays,
    required String departureTime,
    DateTime? departureDate,
    List<DateTime>? departureDates,

    /// Bir seri içindeki tüm instance'ları gruplar
    String? seriesId,

    required bool isDeleted,
    DateTime? createdAt,
  }) = _TourEntity;
}
