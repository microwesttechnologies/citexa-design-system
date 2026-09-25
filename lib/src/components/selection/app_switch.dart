import 'package:flutter/material.dart';

import '../../theme/citexa_colors.dart';

/// Branded on/off switch.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.onPrimary,
      activeTrackColor: colors.primary,
      inactiveThumbColor: colors.textSecondary,
      inactiveTrackColor: colors.outline,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
