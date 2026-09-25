import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/citexa_colors.dart';

/// Branded checkbox with a square, rounded shape matching [AppRadius.sm].
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.xxs),
      ),
      side: BorderSide(color: colors.outline, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.primary;
        return Colors.transparent;
      }),
      checkColor: colors.onPrimary,
    );
  }
}
