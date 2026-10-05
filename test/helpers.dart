import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in a themed [MaterialApp] + [Scaffold] for widget tests.
///
/// [reduceMotion] emulates the OS "reduce motion" setting. The override has to
/// live *inside* the app: [MaterialApp] builds its own [MediaQuery] from the
/// platform view and would discard one placed above it.
Widget wrap(
  Widget child, {
  ThemeData? theme,
  bool scaffold = true,
  bool reduceMotion = false,
}) {
  final home = scaffold ? Scaffold(body: Center(child: child)) : child;
  return MaterialApp(
    theme: theme,
    home: reduceMotion
        ? Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: home,
            ),
          )
        : home,
  );
}

/// Sets a logical screen size for the test (devicePixelRatio 1) and resets it
/// when the test finishes.
void useScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
