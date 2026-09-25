import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

/// Color treatment of an [AppBadge].
///
/// The brand manual does not define semantic status colors (success /
/// warning / error), so badges only offer neutral and brand-accent
/// treatments. Once the brand team publishes status colors they should be
/// added to [CitexaColors] and a matching variant added here — never as a
/// one-off hex in a screen.
enum AppBadgeVariant { neutral, primary, secondary }

/// Small pill used to show a status or tag (e.g. "Activo", "Pendiente").
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
  });

  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (Color bg, Color fg) = switch (variant) {
      AppBadgeVariant.neutral => (colors.outline, colors.textPrimary),
      AppBadgeVariant.primary => (colors.primary, colors.onPrimary),
      AppBadgeVariant.secondary => (colors.secondary, colors.onSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs / 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: CitexaTypography.label.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
