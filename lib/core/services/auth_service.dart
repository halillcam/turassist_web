import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';

/// Kimlik doğrulama servisi.
///
/// [createSecondaryAuthUser]: Admin/super-admin oturumunu kapatmadan yeni bir
/// Firebase Auth kullanıcısı oluşturmak için her iki servis de bu statik
/// metodu kullanır. Geçici bir ikincil uygulama örneği açılır, kullanıcı
/// oluşturulur ve örnek hemen silinir.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String guideEmailDomain = 'guide.turassist';
  static const String customerEmailDomain = 'customer.turassist';

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  static String normalizeGuideId(String guideId) => guideId.trim().toUpperCase();

  static String normalizePanelLoginId(String loginId) => loginId.trim().toUpperCase();

  static String buildGuideLoginEmail(String guideId) =>
      '${normalizeGuideId(guideId)}@$guideEmailDomain';

  static String buildCustomerLoginEmail(String customerId) =>
      '${normalizePanelLoginId(customerId)}@$customerEmailDomain';

  static bool isGeneratedGuideLoginEmail(String email) =>
      email.trim().toLowerCase().endsWith('@$guideEmailDomain');

  static bool isGeneratedCustomerLoginEmail(String email) =>
      email.trim().toLowerCase().endsWith('@$customerEmailDomain');

  static String extractGuideId(String email) {
    final trimmed = email.trim();
    if (!isGeneratedGuideLoginEmail(trimmed)) return trimmed;
    return trimmed.substring(0, trimmed.length - '@$guideEmailDomain'.length).toUpperCase();
  }

  static String extractCustomerId(String email) {
    final trimmed = email.trim();
    if (!isGeneratedCustomerLoginEmail(trimmed)) return trimmed;
    return trimmed.substring(0, trimmed.length - '@$customerEmailDomain'.length).toUpperCase();
  }

  static bool looksLikePanelLoginId(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty &&
        !trimmed.contains('@') &&
        RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(trimmed);
  }

  static bool looksLikeGuideId(String value) => looksLikePanelLoginId(value);

  List<String> buildLoginCandidates(String value) {
    final trimmed = value.trim();
    if (!looksLikePanelLoginId(trimmed)) {
      return [trimmed];
    }

    final normalizedLoginId = normalizePanelLoginId(trimmed);
    return [buildCustomerLoginEmail(normalizedLoginId), buildGuideLoginEmail(normalizedLoginId)];
  }

  /// Giriş yapar ve [UserModel] döndürür.
  ///
  /// Hesap `isDeleted = true` ise oturum açılmaz ve [StateError] fırlatılır.
  Future<UserModel?> signIn(String emailOrGuideId, String password) async {
    UserCredential? credential;
    Object? lastError;

    for (final candidateEmail in buildLoginCandidates(emailOrGuideId)) {
      try {
        credential = await _auth.signInWithEmailAndPassword(
          email: candidateEmail,
          password: password,
        );
        break;
      } catch (error) {
        lastError = error;
      }
    }

    if (credential == null) {
      throw lastError ?? StateError('Giriş yapılamadı.');
    }

    final uid = credential.user?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
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

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> signOut() async {
    if (_auth.currentUser == null) return;
    await _auth.signOut();
  }

  static Future<void> sendPasswordReset(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  /// Yonetilen bir kullanicinin parolasini mevcut oturumu bozmadan gunceller.
  static Future<void> updateUserPasswordWithSecondaryApp({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final secondaryApp = await Firebase.initializeApp(
      name: 'secondary_pwd_$ts',
      options: Firebase.app().options,
    );
    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final credential = await secondaryAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: currentPassword,
      );
      await credential.user!.updatePassword(newPassword);
    } finally {
      await secondaryApp.delete();
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Statik yardımcı — mevcut oturumu bozmadan yeni Auth kullanıcısı oluşturur.
  // ──────────────────────────────────────────────────────────────────────────

  /// Geçici bir ikincil Firebase uygulaması üzerinden yeni kullanıcı oluşturur.
  ///
  /// Döndürülen değer yeni kullanıcının UID'sidir.
  /// Merkezi katilimci / rehber akislarinda
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
