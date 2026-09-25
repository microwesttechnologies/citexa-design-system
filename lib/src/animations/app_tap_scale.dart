import 'package:flutter/widgets.dart';

import '../theme/app_motion.dart';

/// Wraps [child] with a subtle press-down scale animation, driven purely by
/// pointer down/up/cancel — no [InkWell]/splash. Used by [AppButton] and
/// anything else that wants tactile press feedback without Material's
/// ripple.
class AppTapScale extends StatefulWidget {
  const AppTapScale({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
    this.pressedScale = 0.96,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double pressedScale;

  @override
  State<AppTapScale> createState() => _AppTapScaleState();
}

class _AppTapScaleState extends State<AppTapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.fast,
    reverseDuration: AppMotion.fast,
    lowerBound: 0,
    upperBound: 1,
  );

  bool get _enabled => widget.enabled && widget.onTap != null;

  /// Tapping still works under reduced motion — only the visual
  /// press-scale feedback is skipped, per `MediaQuery.disableAnimations`.
  bool get _reduceMotion => MediaQuery.of(context).disableAnimations;

  void _onPointerDown(PointerDownEvent _) {
    if (_enabled && !_reduceMotion) _controller.forward();
  }

  void _onPointerUp(PointerUpEvent _) {
    if (_enabled && !_reduceMotion) _controller.reverse();
  }

  void _onPointerCancel(PointerCancelEvent _) {
    if (_enabled && !_reduceMotion) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: GestureDetector(
        onTap: _enabled ? widget.onTap : null,
        child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (context, child) {
            final scale = 1 - (_controller.value * (1 - widget.pressedScale));
            return Transform.scale(scale: scale, child: child);
          },
        ),
      ),
    );
  }
}
