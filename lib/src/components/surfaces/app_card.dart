import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/citexa_colors.dart';

/// Standard container for grouped content ("Tarjetas, módulos y
/// contenedores" in the brand manual).
///
/// In dark mode this reads as a lighter navy panel ([CitexaColors.surface]
/// vs. [CitexaColors.background]); in light mode there is no separate
/// surface hex in the manual, so the card stays flat and is instead
/// separated from the page with a hairline [CitexaColors.outline] border.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.outline),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: content,
      ),
    );
  }
}
