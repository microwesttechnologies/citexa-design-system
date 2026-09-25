import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

/// Color treatment of an [AppBadge].
///
/// [success] and [warning] are semantic status treatments (e.g. "Activo",
/// "Por vencer") backed by [CitexaColors.success]/[CitexaColors.warning] —
/// never a one-off hex in a screen.
enum AppBadgeVariant { neutral, primary, secondary, success, warning }

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
      AppBadgeVariant.success => (colors.success, colors.onSuccess),
      AppBadgeVariant.warning => (colors.warning, colors.onWarning),
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
