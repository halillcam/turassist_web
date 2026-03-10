import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/auth_service.dart';
import '../models/managed_user_dto.dart';

class CreateManagedUserPayload {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String role;
  final String companyId;
  final String tcNo;

  const CreateManagedUserPayload({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.companyId,
    required this.tcNo,
  });
}

abstract class IUserRemoteDataSource {
  Stream<List<ManagedUserDto>> watchUsers();

  Future<void> addUser(CreateManagedUserPayload payload);

  Future<void> updateUser(String uid, Map<String, dynamic> data);

  Future<void> setUserActive(String uid, {required bool isActive});

  Future<ManagedUserDto?> getUserByUid(String uid);
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final FirebaseFirestore _db;

  UserRemoteDataSource({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Stream<List<ManagedUserDto>> watchUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => ManagedUserDto.fromFirestore(doc.data(), doc.id)).toList(),
        );
  }

  @override
  Future<void> addUser(CreateManagedUserPayload payload) async {
    final uid = await AuthService.createSecondaryAuthUser(payload.email, payload.password);
    final dto = ManagedUserDto(
      uid: uid,
      fullName: payload.fullName,
      email: payload.email,
      phone: payload.phone,
      role: payload.role,
      companyId: payload.companyId,
      registeredCompanies: payload.companyId.isNotEmpty ? [payload.companyId] : const [],
      tcNo: payload.tcNo,
      profileImage: null,
      selectedCity: '',
      isDeleted: false,
      createdAt: null,
      guidePassword: null,
      loginId: null,
      customerPassword: null,
      isPanelManagedCustomer: false,
    );
    await _db.collection('users').doc(uid).set(dto.toFirestore());
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  @override
  Future<void> setUserActive(String uid, {required bool isActive}) async {
    await _db.collection('users').doc(uid).update({'isDeleted': !isActive});
  }

  @override
  Future<ManagedUserDto?> getUserByUid(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return ManagedUserDto.fromFirestore(doc.data()!, doc.id);
  }
}
