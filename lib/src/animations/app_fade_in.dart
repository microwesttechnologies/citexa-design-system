import 'package:flutter/widgets.dart';

import '../theme/app_motion.dart';

/// Fades (and optionally slides up) its [child] in when first built.
///
/// Used to give entering content — cards, list items, sections — a
/// consistent, subtle appearance animation across every Citexa app.
class AppFadeIn extends StatefulWidget {
  const AppFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.medium,
    this.offsetY = 12,
    this.offsetX = 0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Vertical distance (px) the child travels while fading in. Set to 0
  /// for a pure fade with no vertical movement.
  final double offsetY;

  /// Horizontal distance (px) the child travels while fading in — e.g. a
  /// negative value slides in from the left. Set to 0 (default) for no
  /// horizontal movement.
  final double offsetX;

  @override
  State<AppFadeIn> createState() => _AppFadeInState();
}

class _AppFadeInState extends State<AppFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );

  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion) {
      // Respect the OS "reduce motion" setting: skip straight to the end
      // state instead of animating into it.
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) return widget.child;

    return AnimatedBuilder(
      animation: _fade,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(
              (1 - _fade.value) * widget.offsetX,
              (1 - _fade.value) * widget.offsetY,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
