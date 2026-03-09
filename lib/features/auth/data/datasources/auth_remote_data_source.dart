import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_user_model.dart';

/// Uzak veri kaynağı sözleşmesi.
/// Test yazarken bu interface mock'lanır; Firebase hiçbir zaman dışarı sızmaz.
abstract class IAuthRemoteDataSource {
  Future<AuthUserModel> signIn({required String email, required String password});

  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  Future<void> signOut();

  Future<AuthUserModel?> getCurrentUser();
}

/// Firebase Auth + Firestore çağrılarını kapsülleyen somut uygulama.
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AuthUserModel> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _fetchUserModel(credential.user!.uid);
  }

  @override
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = credential.user!.uid;

    final data = {
      'email': email.trim(),
      'fullName': name,
      'companyId': '',
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('users').doc(uid).set(data);

    return AuthUserModel(id: uid, email: email.trim(), name: name, companyId: '', roleRaw: role);
  }

  @override
  Future<void> signOut() async {
    if (_auth.currentUser == null) return;
    await _auth.signOut();
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _fetchUserModel(uid);
  }

  // ─── Yardımcı ────────────────────────────────────────────────────────────

  Future<AuthUserModel> _fetchUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Kullanıcı Firestore kayıt bulunamadı.',
      );
    }
    return AuthUserModel.fromJson(doc.data()!, doc.id);
  }
}
