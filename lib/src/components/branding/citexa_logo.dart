import 'package:flutter/material.dart';

/// The four official Citexa logo lockups.
enum CitexaLogoVariant {
  /// Icon on the left, "CITEXA" on its right — headers, sidebars, footers.
  horizontal,

  /// Icon on top, "CITEXA" underneath — login and splash screens.
  vertical,

  /// The building mark alone — favicons, avatars, tight spaces.
  icon,

  /// The "CITEXA" lettering alone.
  wordmark,
}

/// The Citexa brand mark. Always use this instead of drawing a logo by hand
/// or referencing the image files directly, so every app shows the same,
/// official artwork.
///
/// The lettering of the official logo is white (it is designed for dark
/// backgrounds), so on light backgrounds the widget switches to the twin
/// artwork with navy lettering — chosen automatically from the current
/// [Theme] brightness, or forced with [onDark].
///
/// Give it a [height] (or a [width]); the aspect ratio of each variant is
/// preserved.
class CitexaLogo extends StatelessWidget {
  const CitexaLogo({
    super.key,
    this.variant = CitexaLogoVariant.horizontal,
    this.height,
    this.width,
    this.onDark,
  });

  const CitexaLogo.horizontal({super.key, this.height, this.width, this.onDark})
    : variant = CitexaLogoVariant.horizontal;

  const CitexaLogo.vertical({super.key, this.height, this.width, this.onDark})
    : variant = CitexaLogoVariant.vertical;

  const CitexaLogo.icon({super.key, this.height, this.width, this.onDark})
    : variant = CitexaLogoVariant.icon;

  const CitexaLogo.wordmark({super.key, this.height, this.width, this.onDark})
    : variant = CitexaLogoVariant.wordmark;

  final CitexaLogoVariant variant;
  final double? height;
  final double? width;

  /// Force the artwork for a dark ([true]) or light ([false]) background.
  /// Null (default) follows the current theme.
  final bool? onDark;

  static const _package = 'citexa_design_system';
  static const _dir = 'lib/src/assets/logo';

  /// Asset path inside this package for [variant] on a dark / light background.
  static String assetPath(CitexaLogoVariant variant, {required bool onDark}) {
    final tone = onDark ? 'on_dark' : 'on_light';
    return switch (variant) {
      // The icon has no lettering, so one file serves both backgrounds.
      CitexaLogoVariant.icon => '$_dir/citexa_icon.png',
      CitexaLogoVariant.horizontal => '$_dir/citexa_horizontal_$tone.png',
      CitexaLogoVariant.vertical => '$_dir/citexa_vertical_$tone.png',
      CitexaLogoVariant.wordmark => '$_dir/citexa_wordmark_$tone.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    final dark = onDark ?? Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      assetPath(variant, onDark: dark),
      package: _package,
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Citexa',
    );
  }
}
