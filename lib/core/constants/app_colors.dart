import 'package:flutter/material.dart';

/// TurAssist uygulama renk paleti.
///
/// Tüm renk tanımları bu sınıfta merkezi olarak yönetilir.
/// Ekranlarda doğrudan hex renk kodu kullanmak yerine
/// bu sınıftaki sabitler tercih edilmelidir.
abstract class AppColors {
  // ─── Ana Renkler ───
  static const Color primary = Color(0xFF137fec);
  static const Color primaryDark = Color(0xFF0d5bab);
  static const Color primaryLight = Color(0xFF4DA3FF);

  // ─── Arka Plan ───
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color backgroundDark = Color(0xFF1a2632);
  static const Color scannerBackground = Color(0xFF0a0f14);

  // ─── Yüzey / Kart ───
  static const Color darkSurface = Color(0xFF162231);
  static const Color cardDark = Color(0xFF1a2632);
  static const Color surfaceLight = Color(0xFFfbfdff);
  static const Color surfaceMuted = Color(0xFFeef4fb);
  static const Color borderSubtle = Color(0xFF253548);
  static const Color surfaceInputDark = Color(0xFF223247);
  static const Color surfaceOverlayDark = Color(0xFF203044);

  // ─── Slate Paleti ───
  static const Color slate900 = Color(0xFF0f172a);
  static const Color slate800 = Color(0xFF1e293b);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748b);
  static const Color slate400 = Color(0xFF94a3b8);
  static const Color slate300 = Color(0xFFcbd5e1);
  static const Color slate200 = Color(0xFFe2e8f0);
  static const Color slate100 = Color(0xFFf1f5f9);

  // ─── İkincil Renkler ───
  static const Color secondary = Color(0xFF4A90E2);
  static const Color secondaryDark = Color(0xFF3A7FD5);

  // ─── Semantik ───
  static const Color success = Color(0xFF22c55e);
  static const Color successLight = Color(0xFF34d399);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFef4444);
  static const Color errorLight = Color(0xFFfb7185);
  static const Color info = Color(0xFF2196F3);

  // ─── Sabit ───
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ─── Gradyanlar ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  // ─── Geriye Uyumluluk (eski isimlendirmeler) ───
  static const Color background = backgroundDark;
  static const Color surface = darkSurface;
  static const Color textPrimary = slate100;
  static const Color textSecondary = slate300;
  static const Color divider = borderSubtle;
  static const Color accent = warning;
  static const Color sidebarBg = slate900;
  static const Color sidebarText = slate300;
  static const Color sidebarActive = primaryLight;
}
