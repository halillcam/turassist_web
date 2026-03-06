import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turassist_web/firebase_options.dart';
import 'package:turassist_web/core/constants/app_routes.dart';
import 'package:turassist_web/core/constants/app_strings.dart';
import 'package:turassist_web/core/services/auth_service.dart';
import 'package:turassist_web/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _AuthGate(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

/// Uygulama açıldığında Firebase Auth durumunu kontrol eder.
///
/// - Oturum yoksa → Login ekranı
/// - Oturum varsa → Kullanıcının rolüne göre Admin veya Super Admin dashboardı
///
/// Bu sayede sayfayı yenileyen bir kullanıcı tekrar login'e düşmez.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase henüz durumu belirlemedi — yükleniyor.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Aktif oturum yok → Login
        if (!snapshot.hasData || snapshot.data == null) {
          return const _LoginRedirect();
        }

        // Aktif oturum var → Firestore'dan rolü oku ve yönlendir.
        return _RoleRouter(uid: snapshot.data!.uid);
      },
    );
  }
}

/// Oturum olmadığında Login ekranına yönlendirir.
class _LoginRedirect extends StatefulWidget {
  const _LoginRedirect();

  @override
  State<_LoginRedirect> createState() => _LoginRedirectState();
}

class _LoginRedirectState extends State<_LoginRedirect> {
  @override
  void initState() {
    super.initState();
    // Frame tamamlandıktan sonra yönlendir (build sırasında navigate edilemez).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Firestore'dan kullanıcı rolünü okuyup ilgili dashboard'a yönlendiren widget.
class _RoleRouter extends StatefulWidget {
  final String uid;
  const _RoleRouter({required this.uid});

  @override
  State<_RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<_RoleRouter> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    final user = await AuthService().getCurrentUserModel();

    if (!mounted) return;

    if (user == null || user.isDeleted) {
      // Geçersiz kullanıcı — oturumu kapat ve Login'e gönder.
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
      }
      return;
    }

    final route = switch (user.role) {
      'super_admin' => AppRoutes.superAdminDashboard,
      'admin' => AppRoutes.adminDashboard,
      _ => AppRoutes.login,
    };

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
