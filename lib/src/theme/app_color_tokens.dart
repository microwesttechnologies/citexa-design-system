import 'package:flutter/widgets.dart';

/// Raw brand colors for the Citexa design system.
///
/// This is the ONLY file in the whole design system allowed to contain a
/// literal `Color(0x...)` value. Every other file — tokens, theme,
/// components — must reference a color through [CitexaColors] (see
/// `citexa_colors.dart`), never through a hex literal. This keeps a single
/// source of truth and makes it impossible for a component to be painted
/// with an undocumented color.
///
/// Pure white and pure black are treated as structural, not brand, colors
/// (they carry no hue) and are allowed alongside the brand hexes below —
/// every other color in the system is one of these six colors at some
/// opacity, never a new hue.
///
/// Source: Citexa color palette (updated 2026-09-24).
abstract final class BrandPalette {
  /// #8E05F7 — Primary. Buttons, icons, highlighted elements.
  static const Color primary = Color(0xFF8E05F7);

  /// #7604CC — Secondary. Interactive elements and accents.
  static const Color secondary = Color(0xFF7604CC);

  /// #460275 — Tertiary. Supporting accents.
  static const Color tertiary = Color(0xFF460275);

  /// #0F172A — Neutral. App background / dark canvas.
  static const Color neutral = Color(0xFF0F172A);

  /// Structural — pure white. Used for text/icons on dark surfaces and as
  /// the light-theme background.
  static const Color white = Color(0xFFFFFFFF);

  /// Structural — pure black. Reserved for maximum-contrast needs.
  static const Color black = Color(0xFF000000);

  /// Primary brand gradient: Primary → Secondary.
  static const List<Color> primaryGradient = [primary, secondary];
}
