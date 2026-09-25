import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/citexa_colors.dart';
import 'app_breakpoints.dart';

/// Standard page shell shared by every Citexa screen (web and mobile):
/// brand background, optional title bar, and content clamped to a
/// comfortable reading width on large / web viewports.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.maxContentWidth = 960,
    this.floatingActionButton,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final double maxContentWidth;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: title == null
          ? null
          : AppBar(
              backgroundColor: colors.background,
              foregroundColor: colors.textPrimary,
              elevation: 0,
              title: Text(title!),
              actions: actions,
            ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppBreakpoints.isMobile(context)
                    ? AppSpacing.md
                    : AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
