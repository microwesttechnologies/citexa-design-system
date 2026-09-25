import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

/// Circular avatar. Shows [imageProvider] when given, otherwise [initials]
/// (typically first-name + last-name initials, e.g. "JO") over a
/// brand-gradient background.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageProvider,
    this.initials = '',
    this.size = 40,
  });

  final ImageProvider? imageProvider;
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (imageProvider != null) {
      return CircleAvatar(radius: size / 2, backgroundImage: imageProvider);
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors.primaryGradient),
      ),
      child: Text(
        initials.length <= 2
            ? initials.toUpperCase()
            : initials.substring(0, 2).toUpperCase(),
        style: CitexaTypography.sectionTitle.copyWith(
          color: colors.onPrimary,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}
