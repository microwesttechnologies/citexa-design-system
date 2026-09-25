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
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.emphasized,
  );

  bool _reduceMotion = false;
  bool _started = false;

  // MediaQuery.of() must not be called from initState() — see the same
  // note in AppFadeIn.didChangeDependencies().
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion) {
      _controller.value = 1;
    } else {
      _controller.forward();
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
