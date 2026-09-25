import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/citexa_colors.dart';

/// A placeholder block that pulses gently while real content is still
/// loading — shaped like the content it stands in for (a line of text, an
/// avatar, a card) rather than a generic spinner, so the layout the user is
/// about to see is already legible.
///
/// Only animates [opacity] (never size/position), per the design system's
/// performance rule, and freezes at a static mid-opacity when the platform
/// reports `MediaQuery.disableAnimations` (reduced motion).
///
/// This is infrastructure for screens that have a real asynchronous gap to
/// bridge — don't wrap content that is already available synchronously just
/// to "show a skeleton"; that reads as slower, not faster.
class AppSkeletonBox extends StatefulWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppRadius.sm,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<AppSkeletonBox> createState() => _AppSkeletonBoxState();
}

class _AppSkeletonBoxState extends State<AppSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _started = false;

  // MediaQuery.of() must not be called from initState() — see the same
  // note in AppFadeIn.didChangeDependencies().
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (!MediaQuery.of(context).disableAnimations) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.outline;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget box(double opacity) => Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: base.withValues(alpha: base.a * opacity),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
    );

    if (reduceMotion) return box(1);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => box(0.6 + _controller.value * 0.4),
    );
  }
}

/// A row of [AppSkeletonBox] lines with a leading circular avatar
/// placeholder — the common shape for a "list item is loading" state.
class AppSkeletonListTile extends StatelessWidget {
  const AppSkeletonListTile({super.key, this.avatarSize = 32});

  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSkeletonBox(
          width: avatarSize,
          height: avatarSize,
          borderRadius: avatarSize / 2,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSkeletonBox(width: double.infinity, height: 14),
              const SizedBox(height: AppSpacing.xxs),
              AppSkeletonBox(width: 120, height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
