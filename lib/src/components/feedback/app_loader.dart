import 'package:flutter/material.dart';

import '../../theme/citexa_colors.dart';

/// Branded loading indicator. Defaults to the primary brand color, or an
/// explicit [color] (used by [AppButton] to match the current label color).
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? context.colors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size / 8,
        valueColor: AlwaysStoppedAnimation<Color>(resolved),
      ),
    );
  }
}

/// Full-bleed loading overlay: dims the screen with [CitexaColors.overlay]
/// and centers an [AppLoader]. Use for blocking, page-level loading states.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.overlay,
      alignment: Alignment.center,
      child: const AppLoader(size: 36),
    );
  }
}
