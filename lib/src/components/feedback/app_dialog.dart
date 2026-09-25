import 'package:flutter/material.dart';

import '../../animations/app_scale_in.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';
import '../buttons/app_button.dart';

/// Shows a branded modal dialog with a title, message and up to two
/// actions. Returns the value passed to [Navigator.pop] by whichever
/// action was tapped (typically `true` / `false`).
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Aceptar',
  String? cancelLabel,
  bool isDestructive = false,
}) {
  final colors = context.colors;
  return showDialog<T>(
    context: context,
    barrierColor: colors.overlay,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: AppScaleIn(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: colors.outline),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CitexaTypography.sectionTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: CitexaTypography.bodySecondary.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (cancelLabel != null) ...[
                      AppButton(
                        label: cancelLabel,
                        variant: AppButtonVariant.ghost,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    AppButton(
                      label: confirmLabel,
                      variant: isDestructive
                          ? AppButtonVariant.outline
                          : AppButtonVariant.primary,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
