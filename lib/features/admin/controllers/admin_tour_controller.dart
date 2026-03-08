import 'package:get/get.dart';
import '../../../core/models/ticket_model.dart';
import '../../../core/models/tour_model.dart';
import '../../../core/models/user_model.dart';
import '../services/admin_tour_service.dart';

class AdminTourController extends GetxController {
  final _service = AdminTourService();

  Stream<List<TourModel>> streamActiveTours(String companyId) =>
      _service.streamActiveTours(companyId);

  Stream<List<TourModel>> streamDeletedTours(String companyId) =>
      _service.streamDeletedTours(companyId);

  Stream<TourModel?> streamTour(String tourId) => _service.streamTour(tourId);

  Stream<List<TicketModel>> streamTourTickets(String tourId) => _service.streamTourTickets(tourId);

  Stream<int> streamUnreadNotificationCount(String companyId) =>
      _service.streamUnreadNotificationCount(companyId);

  Future<String?> getCurrentCompanyId() => _service.getCurrentCompanyId();

  Future<String> addTour(TourModel tour) => _service.addTour(tour);

  Future<void> updateTour(String tourId, Map<String, dynamic> data) =>
      _service.updateTour(tourId, data);

  Future<void> deleteTour(String tourId) => _service.deleteTour(tourId);

  Future<void> setTourActive(String tourId, {required bool isActive}) =>
      _service.setTourActive(tourId, isActive: isActive);

  Future<TourModel?> getTour(String tourId) => _service.getTour(tourId);

  Future<void> addParticipantToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tcNo,
    required String tourId,
    required String companyId,
    required double pricePaid,
    DateTime? departureDate,
  }) => _service.addParticipantToTour(
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
    tcNo: tcNo,
    tourId: tourId,
    companyId: companyId,
    pricePaid: pricePaid,
    departureDate: departureDate,
  );

  Future<void> addGuideToTour({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String tourId,
    required String companyId,
  }) => _service.addGuideToTour(
    email: email,
    password: password,
    fullName: fullName,
    phone: phone,
    tourId: tourId,
    companyId: companyId,
  );

  Future<void> removeGuideFromTour({required String tourId, required String guideId}) =>
      _service.removeGuideFromTour(tourId: tourId, guideId: guideId);

  Future<UserModel?> getUserByUid(String uid) => _service.getUserByUid(uid);

  Future<void> updateGuide(String guideId, Map<String, dynamic> data) =>
      _service.updateGuide(guideId, data);

  Future<void> setGuideActive(String guideId, {required bool isActive}) =>
      _service.setGuideActive(guideId, isActive: isActive);

  Future<void> sendPasswordResetEmail(String email) => _service.sendPasswordResetEmail(email);

  Future<void> approveTourCompletion({
    required String requestId,
    required String tourId,
    required String guideId,
  }) => _service.approveTourCompletion(requestId: requestId, tourId: tourId, guideId: guideId);

  Future<void> rejectTourCompletion(String requestId) => _service.rejectTourCompletion(requestId);
}
