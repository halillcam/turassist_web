import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/guide_dto.dart';

class AddGuideRemotePayload {
  final String guideId;
  final String password;
  final String fullName;
  final String phone;
  final String tourId;
  final String companyId;

  const AddGuideRemotePayload({
    required this.guideId,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.tourId,
    required this.companyId,
  });
}

abstract class IGuideRemoteDataSource {
  Future<void> addGuide(AddGuideRemotePayload payload);
}

class GuideRemoteDataSource implements IGuideRemoteDataSource {
  static const _guideEmailDomain = 'guide.turassist';

  final FirebaseFirestore _db;

  GuideRemoteDataSource({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<void> addGuide(AddGuideRemotePayload payload) async {
    final normalizedGuideId = _normalizeGuideId(payload.guideId);
    final email = _buildGuideLoginEmail(normalizedGuideId);
    final uid = await _createSecondaryAuthUser(email, payload.password);

    final guide = GuideDto(
      uid: uid,
      loginId: normalizedGuideId,
      email: email,
      fullName: payload.fullName,
      phone: payload.phone,
      companyId: payload.companyId,
      guidePassword: payload.password,
      isDeleted: false,
    );

    await _db.collection('users').doc(uid).set(guide.toFirestore());
    await _db.collection('tours').doc(payload.tourId).update({
      'guideId': uid,
      'guideName': payload.fullName,
    });
  }

  String _normalizeGuideId(String guideId) => guideId.trim().toUpperCase();

  String _buildGuideLoginEmail(String guideId) => '${_normalizeGuideId(guideId)}@$_guideEmailDomain';

  Future<String> _createSecondaryAuthUser(String email, String password) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondary_guide_$ts',
      options: Firebase.app().options,
    );
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!.uid;
    } finally {
      await secondaryApp.delete();
    }
  }
}