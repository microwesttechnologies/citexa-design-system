import 'package:flutter/material.dart';

/// Font families registered in `pubspec.yaml`.
///
/// - [headlineFontFamily] — Space Grotesk. Titles, headlines.
/// - [bodyFontFamily] — Geist. Body copy, UI text.
/// - [labelFontFamily] — JetBrains Mono. Labels, tags, technical text.
const String headlineFontFamily = 'SpaceGrotesk';
const String bodyFontFamily = 'Geist';
const String labelFontFamily = 'JetBrainsMono';

/// Text style hierarchy for the Citexa design system.
///
/// Sizes/weights/line-heights are typography tokens, not colors —
/// [CitexaColors] is applied separately by callers (typically via
/// `context.colors`) so every style here stays theme-agnostic and reusable
/// in both light and dark mode.
abstract final class CitexaTypography {
  /// Space Grotesk Bold 48 / 120% — Título Principal.
  static const TextStyle titlePrincipal = TextStyle(
    fontFamily: headlineFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.2,
  );

  /// Space Grotesk SemiBold 28 / 130% — Subtítulo.
  static const TextStyle subtitle = TextStyle(
    fontFamily: headlineFontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.3,
  );

  /// Space Grotesk Medium 20 / 130% — Título de sección.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: headlineFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.3,
  );

  /// Geist Regular 16 / 150% — Texto principal.
  static const TextStyle bodyPrimary = TextStyle(
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );

  /// Geist Regular 14 / 150% — Texto secundario.
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: bodyFontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
  );

  /// JetBrains Mono Medium 12 / 150% — Etiqueta / Nota.
  static const TextStyle label = TextStyle(
    fontFamily: labelFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.5,
  );

  /// Maps the hierarchy onto Flutter's [TextTheme] so built-in Material
  /// widgets (AppBar titles, default [Text], etc.) also pick up the right
  /// family and scale automatically.
  static TextTheme textTheme(Color color) {
    final base = TextTheme(
      displayLarge: titlePrincipal,
      headlineMedium: subtitle,
      titleLarge: sectionTitle,
      bodyLarge: bodyPrimary,
      bodyMedium: bodySecondary,
      labelSmall: label,
    );
    return base.apply(
      bodyColor: color,
      displayColor: color,
      decorationColor: color,
    );
  }
}
