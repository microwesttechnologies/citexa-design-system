import 'package:flutter/material.dart';

import 'citexa_colors.dart';
import 'app_typography.dart';

/// Builds the light and dark [ThemeData] for every Citexa app (web and
/// mobile). Colors always come from [CitexaColors]; nothing here declares a
/// raw hex value.
abstract final class CitexaTheme {
  static ThemeData light() => _build(CitexaColors.light, Brightness.light);

  static ThemeData dark() => _build(CitexaColors.dark, Brightness.dark);

  static ThemeData _build(CitexaColors colors, Brightness brightness) {
    // Stock Material widgets (PopupMenuButton, Dialog, etc.) read
    // ColorScheme.surface expecting an OPAQUE base color for elevation
    // overlays. CitexaColors.surface is intentionally translucent (a tint
    // painted over whatever background sits behind it — see AppCard), so it
    // must never be passed here directly or default menus/dialogs render
    // almost invisible. Flatten it to a solid color first.
    final opaqueSurface = Color.alphaBlend(colors.surface, colors.background);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      surface: opaqueSurface,
      onSurface: colors.onSurface,
      error: colors.outline,
      onError: colors.onSurface,
      outline: colors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      dividerColor: colors.outline,
      fontFamily: bodyFontFamily,
      textTheme: CitexaTypography.textTheme(colors.textPrimary),
      splashFactory: InkSparkle.splashFactory,
      extensions: [colors],
    );
  }
}
