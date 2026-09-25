import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

/// Semantic color roles for the Citexa design system.
///
/// Every widget in this package reads colors exclusively through this
/// class (via [CitexaColorsX.colors] on [BuildContext]). No component may
/// declare a raw `Color(0x...)`.
///
/// Only [BrandPalette.primary], [BrandPalette.secondary],
/// [BrandPalette.tertiary], [BrandPalette.neutral], [BrandPalette.white]
/// and [BrandPalette.black] exist as literal hexes. Every other role below
/// is one of those six colors at a fixed opacity — never a new hue. Opacity
/// works here because Flutter composites a translucent color over whatever
/// sits behind it: e.g. `white` at 6% opacity painted over the dark
/// [neutral] background reads as a subtly lighter panel, with no need to
/// invent a second "surface" hex.
@immutable
class CitexaColors extends ThemeExtension<CitexaColors> {
  const CitexaColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.disabled,
    required this.overlay,
  });

  /// #8E05F7 — brand accent used for primary actions, icons and highlights.
  final Color primary;

  /// Color for content painted on top of [primary]-filled surfaces.
  final Color onPrimary;

  /// #7604CC — secondary accent for interactive elements.
  final Color secondary;

  /// Color for content painted on top of [secondary]-filled surfaces.
  final Color onSecondary;

  /// #460275 — supporting accent.
  final Color tertiary;

  /// Color for content painted on top of [tertiary]-filled surfaces.
  final Color onTertiary;

  /// Page / scaffold background.
  final Color background;

  /// Default content color on top of [background].
  final Color onBackground;

  /// Cards, modules, inputs and containers — a translucent tint of the
  /// structural color over [background], not a separate hue.
  final Color surface;

  /// Default content color on top of [surface].
  final Color onSurface;

  /// Dividers, borders and supporting graphic elements.
  final Color outline;

  /// Primary text color.
  final Color textPrimary;

  /// Secondary / supporting text color.
  final Color textSecondary;

  /// Disabled controls.
  final Color disabled;

  /// Scrim / overlay used behind dialogs and sheets.
  final Color overlay;

  /// Brand gradient (Primary → Secondary), identical in both themes.
  List<Color> get primaryGradient => BrandPalette.primaryGradient;

  static const CitexaColors dark = CitexaColors(
    primary: BrandPalette.primary,
    onPrimary: BrandPalette.white,
    secondary: BrandPalette.secondary,
    onSecondary: BrandPalette.white,
    tertiary: BrandPalette.tertiary,
    onTertiary: BrandPalette.white,
    background: BrandPalette.neutral,
    onBackground: BrandPalette.white,
    surface: Color(0x0FFFFFFF), // white @ 6% over neutral
    onSurface: BrandPalette.white,
    outline: Color(0x24FFFFFF), // white @ 14%
    textPrimary: BrandPalette.white,
    textSecondary: Color(0xA6FFFFFF), // white @ 65%
    disabled: Color(0x40FFFFFF), // white @ 25%
    overlay: Color(0xB30F172A), // neutral @ 70%
  );

  static const CitexaColors light = CitexaColors(
    primary: BrandPalette.primary,
    onPrimary: BrandPalette.white,
    secondary: BrandPalette.secondary,
    onSecondary: BrandPalette.white,
    tertiary: BrandPalette.tertiary,
    onTertiary: BrandPalette.white,
    background: BrandPalette.white,
    onBackground: BrandPalette.neutral,
    surface: Color(0x0A0F172A), // neutral @ 4% over white
    onSurface: BrandPalette.neutral,
    outline: Color(0x260F172A), // neutral @ 15%
    textPrimary: BrandPalette.neutral,
    textSecondary: Color(0xA60F172A), // neutral @ 65%
    disabled: Color(0x400F172A), // neutral @ 25%
    overlay: Color(0x660F172A), // neutral @ 40%
  );

  @override
  CitexaColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? disabled,
    Color? overlay,
  }) {
    return CitexaColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      disabled: disabled ?? this.disabled,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  CitexaColors lerp(ThemeExtension<CitexaColors>? other, double t) {
    if (other is! CitexaColors) return this;
    return CitexaColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

/// Convenience accessor: `context.colors.primary`.
extension CitexaColorsX on BuildContext {
  CitexaColors get colors =>
      Theme.of(this).extension<CitexaColors>() ?? CitexaColors.dark;
}
