import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Kimlik doğrulama servisi.
///
/// [createSecondaryAuthUser]: Admin/super-admin oturumunu kapatmadan yeni bir
/// Firebase Auth kullanıcısı oluşturmak için her iki servis de bu statik
/// metodu kullanır. Geçici bir ikincil uygulama örneği açılır, kullanıcı
/// oluşturulur ve örnek hemen silinir.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Giriş yapar ve [UserModel] döndürür.
  ///
  /// Hesap `isDeleted = true` ise oturum açılmaz ve [StateError] fırlatılır.
  Future<UserModel?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    final user = UserModel.fromMap(doc.data()!, doc.id);
    if (user.isDeleted) {
      await _auth.signOut();
      throw StateError('Bu hesap devre dışı bırakılmıştır.');
    }
    return user;
  }

  /// Oturum açık kullanıcının [UserModel]'ini getirir; oturum yoksa null döner.
  Future<UserModel?> getCurrentUserModel() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> signOut() => _auth.signOut();

  static Future<void> sendPasswordReset(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Statik yardımcı — mevcut oturumu bozmadan yeni Auth kullanıcısı oluşturur.
  // ──────────────────────────────────────────────────────────────────────────

  /// Geçici bir ikincil Firebase uygulaması üzerinden yeni kullanıcı oluşturur.
  ///
  /// Döndürülen değer yeni kullanıcının UID'sidir.
  /// [AdminTourService] ve [SuperAdminService] katılımcı / rehber eklerken
  /// mevcut yönetici oturumunun kapanmaması için bu metodu çağırır.
  static Future<String> createSecondaryAuthUser(String email, String password) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondary_$ts',
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
