import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// The single page-transition every Citexa app should push routes with —
/// a short fade + small upward slide, consistently faster on the way out
/// than on the way in (the user should never feel like the app is waiting
/// on an animation to leave a screen).
///
/// Respects `MediaQuery.disableAnimations` (the Flutter surface for the
/// OS's "reduce motion" setting): when set, this degrades to an
/// instant/near-instant cut instead of skipping the route entirely, so
/// functionality (and the back stack) is unaffected.
Route<T> appPageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: AppMotion.medium,
    reverseTransitionDuration: AppMotion.fast,
    pageBuilder: (context, animation, secondaryAnimation) =>
        builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.of(context).disableAnimations) {
        return child;
      }
      final curved = CurvedAnimation(parent: animation, curve: AppMotion.enter);
      return FadeTransition(
        opacity: curved,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * 16),
          child: child,
        ),
      );
    },
  );
}
