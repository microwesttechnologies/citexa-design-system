import 'package:flutter/widgets.dart';

/// Shared responsive breakpoints so every Citexa app (web and mobile)
/// adapts layout consistently.
abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}

/// Picks between [mobile], [tablet] and [desktop] based on the current
/// width, falling back to the closest smaller breakpoint when a variant
/// isn't provided.
class AppResponsiveBuilder extends StatelessWidget {
  const AppResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    if (AppBreakpoints.isDesktop(context)) {
      return (desktop ?? tablet ?? mobile)(context);
    }
    if (AppBreakpoints.isTablet(context)) {
      return (tablet ?? mobile)(context);
    }
    return mobile(context);
  }
}
