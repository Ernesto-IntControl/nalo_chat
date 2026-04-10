import 'package:flutter/material.dart';

// 🎨 Design System Nalo Chat
// Toutes les couleurs, dégradés et styles centralisés ici.
// Modifier ici = modifier partout dans l'app.
class NaloColors {
  NaloColors._();

  // Couleurs principales
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7CF6);
  static const Color primaryDark = Color(0xFF1A1142);
  static const Color accent = Color(0xFF7C3AED);

  // Fonds
  static const Color background = Color(0xFFF8F7FF);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1EFFF);
  static const Color card = Colors.white;

  // Textes
  static const Color textPrimary = Color(0xFF1A1142);
  static const Color textSecondary = Color(0xFF8E8EA0);
  static const Color textLight = Color(0xFFB4B4C7);

  // Statuts
  static const Color online = Color(0xFF22C55E);
  static const Color unread = Color(0xFF6C5CE7);
  static const Color error = Color(0xFFEF4444);

  // Dégradés réutilisables
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C5CE7), Color(0xFF8B5CF6)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1142), Color(0xFF2D2065)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  // Ombres douces
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
