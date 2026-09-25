import 'package:flutter/material.dart';

import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/citexa_colors.dart';

OverlayEntry? _activeToastEntry;

/// Shows a themed toast anchored to the bottom-right corner, built from
/// [CitexaColors].
///
/// Renders as an [Overlay] entry (not a [SnackBar]) so it gets a solid,
/// fully opaque background — never a translucent one that reads as
/// "barely visible" over busy content — plus a smooth slide/fade entrance
/// instead of Material's default full-width bar.
void showAppSnackBar(
  BuildContext context, {
  required String message,
  bool emphasize = false,
}) {
  final colors = context.colors;
  final overlay = Overlay.of(context);

  _activeToastEntry?.remove();
  _activeToastEntry = null;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _AppToast(
      message: message,
      emphasize: emphasize,
      colors: colors,
      onDismissed: () {
        entry.remove();
        if (identical(_activeToastEntry, entry)) {
          _activeToastEntry = null;
        }
      },
    ),
  );
  _activeToastEntry = entry;
  overlay.insert(entry);
}

class _AppToast extends StatefulWidget {
  const _AppToast({
    required this.message,
    required this.emphasize,
    required this.colors,
    required this.onDismissed,
  });

  final String message;
  final bool emphasize;
  final CitexaColors colors;
  final VoidCallback onDismissed;

  @override
  State<_AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<_AppToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
  );
  late final Animation<double> _entrance = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final background = widget.emphasize
        ? colors.primary
        : Color.alphaBlend(colors.surface, colors.background);
    final foreground = widget.emphasize ? colors.onPrimary : colors.textPrimary;

    return Positioned(
      right: AppSpacing.lg,
      bottom: AppSpacing.lg,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _entrance,
          builder: (context, child) {
            return Opacity(
              opacity: _entrance.value,
              child: Transform.translate(
                offset: Offset((1 - _entrance.value) * 48, 0),
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: Color.alphaBlend(
                          colors.overlay,
                          colors.background,
                        ).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: CitexaTypography.bodySecondary.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
