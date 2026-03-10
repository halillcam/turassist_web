import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../models/company_dto.dart';

class AddCompanyRemotePayload {
  final String companyName;
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String city;
  final String logo;

  const AddCompanyRemotePayload({
    required this.companyName,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    this.city = '',
    this.logo = '',
  });
}

abstract class ICompanyRemoteDataSource {
  Stream<List<CompanyDto>> watchCompanies({required bool isActive});
  Future<CompanyDto?> getCompany(String companyId);
  Future<void> addCompany(AddCompanyRemotePayload payload);
  Future<void> updateCompany(String companyId, Map<String, dynamic> data);
  Future<void> setCompanyStatus(String companyId, {required bool isActive});
}

class CompanyRemoteDataSource implements ICompanyRemoteDataSource {
  final FirebaseFirestore _db;

  CompanyRemoteDataSource({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Stream<List<CompanyDto>> watchCompanies({required bool isActive}) {
    return _db
        .collection('companies')
        .where('status', isEqualTo: isActive)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CompanyDto.fromFirestore(d.data(), d.id)).toList());
  }

  @override
  Future<CompanyDto?> getCompany(String companyId) async {
    final doc = await _db.collection('companies').doc(companyId).get();
    if (!doc.exists || doc.data() == null) return null;
    return CompanyDto.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<void> addCompany(AddCompanyRemotePayload payload) async {
    final uid = await AuthService.createSecondaryAuthUser(payload.email, payload.password);
    final companyRef = _db.collection('companies').doc();
    final companyId = companyRef.id;
    final batch = _db.batch();

    batch.set(companyRef, {
      'companyName': payload.companyName,
      'city': payload.city,
      'contactPhone': payload.phone,
      'logo': payload.logo,
      'admin_uid': uid,
      'status': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.set(
      _db.collection('users').doc(uid),
      UserModel(
        uid: uid,
        fullName: payload.fullName,
        email: payload.email,
        phone: payload.phone,
        role: 'admin',
        companyId: companyId,
        registeredCompanies: [companyId],
        isDeleted: false,
      ).toMap(),
    );

    await batch.commit();
  }

  @override
  Future<void> updateCompany(String companyId, Map<String, dynamic> data) async {
    await _db.collection('companies').doc(companyId).update(data);
  }

  @override
  Future<void> setCompanyStatus(String companyId, {required bool isActive}) async {
    await _db.collection('companies').doc(companyId).update({'status': isActive});
  }
}
