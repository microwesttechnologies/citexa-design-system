import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

/// Shows a themed snackbar built from [CitexaColors]. Use this instead of
/// calling [ScaffoldMessenger] with ad-hoc styling.
void showAppSnackBar(
  BuildContext context, {
  required String message,
  bool emphasize = false,
}) {
  final colors = context.colors;
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      backgroundColor: emphasize ? colors.primary : colors.surface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: colors.outline),
      ),
      content: Text(
        message,
        style: CitexaTypography.bodySecondary.copyWith(
          color: emphasize ? colors.onPrimary : colors.textPrimary,
        ),
      ),
    ),
  );
}
