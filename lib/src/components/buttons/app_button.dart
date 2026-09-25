import 'package:flutter/material.dart';

import '../../animations/app_tap_scale.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';
import '../feedback/app_loader.dart';

/// Visual style of an [AppButton].
enum AppButtonVariant {
  /// Filled with the brand gradient (Turquesa → Azul Eléctrico). Use for
  /// the single most important action on a screen.
  primary,

  /// Filled with the solid secondary accent color.
  secondary,

  /// Transparent fill, primary-colored border and label.
  outline,

  /// No fill, no border — just a colored label. Use for low-emphasis
  /// actions.
  ghost,
}

/// The single button component every Citexa app (web and mobile) should
/// use. Colors always come from [CitexaColors]; sizing/spacing from
/// [AppSpacing].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final bool isLoading;

  /// When true, the button fills the width of its parent.
  final bool expand;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final decoration = _decoration(colors);
    final textColor = _labelColor(colors);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          AppLoader(size: 16, color: textColor),
          const SizedBox(width: AppSpacing.xs),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: textColor),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: CitexaTypography.bodyPrimary.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    return AppTapScale(
      enabled: _enabled,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: decoration,
        child: content,
      ),
    );
  }

  BoxDecoration _decoration(CitexaColors colors) {
    final radius = BorderRadius.circular(AppSpacing.xs + AppSpacing.xxs);
    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          borderRadius: radius,
          gradient: _enabled
              ? LinearGradient(colors: colors.primaryGradient)
              : null,
          color: _enabled ? null : colors.disabled,
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          borderRadius: radius,
          color: _enabled ? colors.secondary : colors.disabled,
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: _enabled ? colors.primary : colors.disabled,
            width: 1.5,
          ),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(borderRadius: radius);
    }
  }

  Color _labelColor(CitexaColors colors) {
    if (!_enabled) return colors.textSecondary;
    switch (variant) {
      case AppButtonVariant.primary:
        return colors.onPrimary;
      case AppButtonVariant.secondary:
        return colors.onSecondary;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return colors.primary;
    }
  }
}
