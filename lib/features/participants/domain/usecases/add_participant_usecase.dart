import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/i_participant_repository.dart';

class AddParticipantParams {
  final String loginId;
  final String password;
  final String fullName;
  final String phone;
  final String tcNo;
  final String tourId;
  final String companyId;
  final double pricePaid;
  final DateTime? departureDate;

  const AddParticipantParams({
    required this.loginId,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.tcNo,
    required this.tourId,
    required this.companyId,
    required this.pricePaid,
    this.departureDate,
  });
}

class AddParticipantUseCase {
  final IParticipantRepository repository;

  const AddParticipantUseCase(this.repository);

  Future<Either<Failure, Unit>> call(AddParticipantParams params) {
    return repository.addParticipant(
      loginId: params.loginId,
      password: params.password,
      fullName: params.fullName,
      phone: params.phone,
      tcNo: params.tcNo,
      tourId: params.tourId,
      companyId: params.companyId,
      pricePaid: params.pricePaid,
      departureDate: params.departureDate,
    );
  }
}
