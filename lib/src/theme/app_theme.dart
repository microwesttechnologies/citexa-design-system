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
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      surface: colors.surface,
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
