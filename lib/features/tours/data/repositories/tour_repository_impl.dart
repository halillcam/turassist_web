import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/company_model.dart';
import '../../domain/entities/tour_entity.dart';
import '../../domain/repositories/i_tour_repository.dart';
import '../datasources/tour_remote_data_source.dart';
import '../models/tour_dto.dart';

class TourRepositoryImpl implements ITourRepository {
  final ITourRemoteDataSource _dataSource;

  const TourRepositoryImpl(this._dataSource);

  // ─── Streams ─────────────────────────────────────────────────────────────

  @override
  Stream<Either<Failure, List<TourEntity>>> streamActiveTours(String companyId) => _dataSource
      .streamActiveTours(companyId)
      .map<Either<Failure, List<TourEntity>>>(
        (list) => Right(list.map((dto) => dto.toEntity()).toList()),
      )
      .handleError((e) => Left(ServerFailure(e.toString())));

  @override
  Stream<Either<Failure, List<TourEntity>>> streamDeletedTours(String companyId) => _dataSource
      .streamDeletedTours(companyId)
      .map<Either<Failure, List<TourEntity>>>(
        (list) => Right(list.map((dto) => dto.toEntity()).toList()),
      )
      .handleError((e) => Left(ServerFailure(e.toString())));

  @override
  Stream<Either<Failure, TourEntity?>> streamTour(String tourId) => _dataSource
      .streamTour(tourId)
      .map<Either<Failure, TourEntity?>>((dto) => Right(dto?.toEntity()))
      .handleError((e) => Left(ServerFailure(e.toString())));

  // ─── One-shot reads ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, TourEntity>> getTour(String tourId) async {
    try {
      final dto = await _dataSource.getTour(tourId);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TourEntity>>> getToursByCompany(
    String companyId, {
    required bool isDeleted,
  }) async {
    try {
      final list = await _dataSource.getToursByCompany(companyId, isDeleted: isDeleted);
      return Right(list.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── Writes ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> addTour(TourEntity tour) async {
    try {
      final id = await _dataSource.addTour(TourDto.fromEntity(tour));
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> addTourSeries(TourEntity tour) async {
    try {
      final ids = await _dataSource.addTourSeries(TourDto.fromEntity(tour));
      return Right(ids);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTour(String tourId, Map<String, dynamic> data) async {
    try {
      await _dataSource.updateTour(tourId, data);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTour(String tourId) async {
    try {
      await _dataSource.deleteTour(tourId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setTourActive(String tourId, {required bool isActive}) async {
    try {
      await _dataSource.setTourActive(tourId, isActive: isActive);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCompanyName(String companyId) async {
    try {
      final name = await _dataSource.getCompanyName(companyId);
      return Right(name);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CompanyModel>>> getCompanies() async {
    try {
      final list = await _dataSource.getCompanies();
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
