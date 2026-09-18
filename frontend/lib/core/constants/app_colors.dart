import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // PRIMARY COLORS
  // =========================

  static const Color primary = Color(0xFF0866E5);
  static const Color primaryDark = Color(0xFF0049B8);
  static const Color primaryLight = Color(0xFFEAF3FF);

  // =========================
  // BACKGROUND COLORS
  // =========================

  static const Color background = Color(0xFFF8FAFF);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // =========================
  // TEXT COLORS
  // =========================

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF687086);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // =========================
  // BORDER COLORS
  // =========================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEDF0F5);

  // =========================
  // STATUS COLORS
  // =========================

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFEAFBF0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFF7E6);

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFFEEEE);

  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFEFF6FF);

  // =========================
  // FLIGHT / SEAT COLORS
  // =========================

  static const Color availableSeat = Color(0xFF22C55E);
  static const Color selectedSeat = Color(0xFF0866E5);
  static const Color bookedSeat = Color(0xFFD1D5DB);

  // =========================
  // GRADIENT COLORS
  // =========================

  static const Color gradientStart = Color(0xFF003C8F);
  static const Color gradientMiddle = Color(0xFF0877E8);
  static const Color gradientEnd = Color(0xFF56BAFF);

  // =========================
  // SHADOW
  // =========================

  static Color shadow = Colors.black.withValues(alpha: 0.06);
}

