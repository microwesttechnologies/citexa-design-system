import 'package:citexa_design_system/citexa_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('AppBreakpoints', () {
    Future<List<bool>> flagsAt(WidgetTester tester, double width) async {
      useScreenSize(tester, Size(width, 800));
      late List<bool> flags;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              flags = [
                AppBreakpoints.isMobile(context),
                AppBreakpoints.isTablet(context),
                AppBreakpoints.isDesktop(context),
              ];
              return const SizedBox();
            },
          ),
        ),
      );
      return flags;
    }

    testWidgets('classifies mobile / tablet / desktop widths', (tester) async {
      expect(await flagsAt(tester, 599), [true, false, false]);
      expect(await flagsAt(tester, 600), [false, true, false]);
      expect(await flagsAt(tester, 1023), [false, true, false]);
      expect(await flagsAt(tester, 1024), [false, false, true]);
    });
  });

  group('AppResponsiveBuilder', () {
    Widget builder({bool withTablet = true, bool withDesktop = true}) =>
        MaterialApp(
          home: AppResponsiveBuilder(
            mobile: (_) => const Text('mobile'),
            tablet: withTablet ? (_) => const Text('tablet') : null,
            desktop: withDesktop ? (_) => const Text('desktop') : null,
          ),
        );

    testWidgets('picks the variant for the current width', (tester) async {
      useScreenSize(tester, const Size(400, 800));
      await tester.pumpWidget(builder());
      expect(find.text('mobile'), findsOneWidget);

      useScreenSize(tester, const Size(800, 800));
      await tester.pumpWidget(builder());
      expect(find.text('tablet'), findsOneWidget);

      useScreenSize(tester, const Size(1400, 800));
      await tester.pumpWidget(builder());
      expect(find.text('desktop'), findsOneWidget);
    });

    testWidgets('falls back to the closest smaller variant', (tester) async {
      useScreenSize(tester, const Size(1400, 800));
      await tester.pumpWidget(builder(withDesktop: false));
      expect(find.text('tablet'), findsOneWidget);

      await tester.pumpWidget(builder(withDesktop: false, withTablet: false));
      expect(find.text('mobile'), findsOneWidget);

      useScreenSize(tester, const Size(800, 800));
      await tester.pumpWidget(builder(withTablet: false));
      expect(find.text('mobile'), findsOneWidget);
    });
  });

  group('AppPageScaffold', () {
    testWidgets('has no app bar without a title and renders the body', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppPageScaffold(body: Text('cuerpo')),
          theme: CitexaTheme.dark(),
          scaffold: false,
        ),
      );
      expect(find.byType(AppBar), findsNothing);
      expect(find.text('cuerpo'), findsOneWidget);
    });

    testWidgets('shows the title and the actions', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppPageScaffold(
            title: 'Panel',
            actions: [Icon(Icons.settings)],
            body: Text('cuerpo'),
          ),
          theme: CitexaTheme.light(),
          scaffold: false,
        ),
      );
      expect(find.text('Panel'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('clamps the content to maxContentWidth on wide screens', (
      tester,
    ) async {
      useScreenSize(tester, const Size(1600, 900));
      await tester.pumpWidget(
        wrap(
          const AppPageScaffold(
            maxContentWidth: 500,
            body: SizedBox(
              width: double.infinity,
              height: 20,
              key: Key('content'),
            ),
          ),
          theme: CitexaTheme.dark(),
          scaffold: false,
        ),
      );
      // 500 max width minus the 24 px horizontal padding on each side.
      expect(
        tester.getSize(find.byKey(const Key('content'))).width,
        500 - 2 * AppSpacing.lg,
      );
    });

    testWidgets('renders the floating action button', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppPageScaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
          theme: CitexaTheme.dark(),
          scaffold: false,
        ),
      );
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('AppFadeIn', () {
    testWidgets('fades the child in until fully opaque', (tester) async {
      await tester.pumpWidget(
        wrap(const AppFadeIn(child: Text('hola')), theme: CitexaTheme.dark()),
      );
      expect(find.text('hola'), findsOneWidget);
      await tester.pumpAndSettle();
      final opacity = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('hola'), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, 1);
    });

    testWidgets('waits for the delay before animating', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppFadeIn(
            delay: Duration(milliseconds: 500),
            child: Text('hola'),
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      final early = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('hola'), matching: find.byType(Opacity))
            .first,
      );
      expect(early.opacity, 0);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      final done = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('hola'), matching: find.byType(Opacity))
            .first,
      );
      expect(done.opacity, 1);
    });

    testWidgets('skips the animation under reduced motion', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppFadeIn(child: Text('hola')),
          theme: CitexaTheme.dark(),
          reduceMotion: true,
        ),
      );
      expect(find.text('hola'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppFadeIn),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });
  });

  group('AppScaleIn', () {
    testWidgets('scales the child in to full size', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppScaleIn(
            child: SizedBox(width: 100, height: 100, key: Key('box')),
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(const Key('box'))),
        const Size(100, 100),
      );
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('renders the child directly under reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppScaleIn(child: Text('hola')),
          theme: CitexaTheme.dark(),
          reduceMotion: true,
        ),
      );
      expect(find.text('hola'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppScaleIn),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });
  });

  group('AppTapScale', () {
    double scaleOf(WidgetTester tester) => tester
        .widget<Transform>(
          find
              .descendant(
                of: find.byType(AppTapScale),
                matching: find.byType(Transform),
              )
              .first,
        )
        .transform
        .entry(0, 0);

    testWidgets('fires onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppTapScale(onTap: () => taps++, child: const Text('tocar')),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.tap(find.text('tocar'));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('does not fire when disabled or without a callback', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppTapScale(
            enabled: false,
            onTap: () => taps++,
            child: const Text('tocar'),
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.tap(find.text('tocar'));
      await tester.pumpAndSettle();
      expect(taps, 0);

      await tester.pumpWidget(
        wrap(
          const AppTapScale(onTap: null, child: Text('tocar')),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.tap(find.text('tocar'));
      await tester.pumpAndSettle();
    });

    testWidgets('shrinks while pressed and returns to full size on release', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AppTapScale(
            onTap: () {},
            pressedScale: 0.5,
            child: const ColoredBox(
              color: Colors.red,
              child: SizedBox(width: 100, height: 100, key: Key('child')),
            ),
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('child'))),
      );
      await tester.pumpAndSettle();
      expect(scaleOf(tester), closeTo(0.5, 0.01));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(scaleOf(tester), closeTo(1, 0.01));
    });
  });

  group('appPageRoute', () {
    testWidgets('pushes the page and pops back', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CitexaTheme.dark(),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                appPageRoute<void>(
                  builder: (_) => const Scaffold(body: Text('destino')),
                ),
              ),
              child: const Text('ir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ir'));
      await tester.pumpAndSettle();
      expect(find.text('destino'), findsOneWidget);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      expect(find.text('destino'), findsNothing);
    });

    testWidgets('still navigates under reduced motion', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                appPageRoute<void>(
                  builder: (_) => const Scaffold(body: Text('destino')),
                ),
              ),
              child: const Text('ir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ir'));
      await tester.pumpAndSettle();
      expect(find.text('destino'), findsOneWidget);
    });
  });

  group('CitexaTheme', () {
    test('exposes brightness and the color extension for light and dark', () {
      expect(CitexaTheme.light().brightness, Brightness.light);
      expect(CitexaTheme.dark().brightness, Brightness.dark);
      expect(CitexaTheme.dark().extension<CitexaColors>(), CitexaColors.dark);
      expect(CitexaTheme.light().extension<CitexaColors>(), CitexaColors.light);
    });

    test('spacing follows the 4 px grid', () {
      for (final value in [
        AppSpacing.xxs,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxl,
      ]) {
        expect(value % 4, 0);
      }
    });
  });
}
