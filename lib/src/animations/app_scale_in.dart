import 'package:flutter/widgets.dart';

import '../theme/app_motion.dart';

/// Scales (and fades) its [child] in from [beginScale] to 1.0.
///
/// Intended for emphasis — dialogs, badges, success states — anywhere a
/// slightly bouncier entrance than [AppFadeIn] reads better.
class AppScaleIn extends StatefulWidget {
  const AppScaleIn({
    super.key,
    required this.child,
    this.duration = AppMotion.medium,
    this.beginScale = 0.85,
  });

  final Widget child;
  final Duration duration;
  final double beginScale;

  @override
  State<AppScaleIn> createState() => _AppScaleInState();
}

class _AppScaleInState extends State<AppScaleIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.emphasized,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t.clamp(0, 1),
          child: Transform.scale(
            scale: widget.beginScale + (1 - widget.beginScale) * t,
            child: child,
          ),
        );
      },
    );
  }
}
