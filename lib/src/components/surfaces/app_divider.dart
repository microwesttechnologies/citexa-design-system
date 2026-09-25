import 'package:flutter/material.dart';

import '../../theme/citexa_colors.dart';

/// Thin horizontal rule using [CitexaColors.outline].
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.thickness = 1});

  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: thickness,
      thickness: thickness,
      color: context.colors.outline,
    );
  }
}
