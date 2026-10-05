import 'dart:typed_data';

import 'package:citexa_design_system/citexa_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders its child without being tappable by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppCard(child: Text('contenido')),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(find.text('contenido'), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('fires onTap when given', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppCard(onTap: () => taps++, child: const Text('tocar')),
          theme: CitexaTheme.light(),
        ),
      );
      await tester.tap(find.text('tocar'));
      expect(taps, 1);
    });
  });

  group('AppDivider', () {
    testWidgets('renders a Divider with the requested thickness', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppDivider(thickness: 3), theme: CitexaTheme.dark()),
      );
      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.thickness, 3);
      expect(divider.color, CitexaColors.dark.outline);
    });
  });

  group('AppAvatar', () {
    testWidgets('shows upper-cased initials', (tester) async {
      await tester.pumpWidget(
        wrap(const AppAvatar(initials: 'jo'), theme: CitexaTheme.dark()),
      );
      expect(find.text('JO'), findsOneWidget);
    });

    testWidgets('keeps only the first two initials', (tester) async {
      await tester.pumpWidget(
        wrap(const AppAvatar(initials: 'abc'), theme: CitexaTheme.dark()),
      );
      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('uses the image when one is provided', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppAvatar(
            imageProvider: MemoryImage(_transparentPixel),
            initials: 'XX',
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('XX'), findsNothing);
    });

    testWidgets('honours the size', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppAvatar(initials: 'A', size: 64),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(tester.getSize(find.byType(Container).first), const Size(64, 64));
    });
  });

  group('AppBadge', () {
    testWidgets('renders every variant with its label', (tester) async {
      for (final variant in AppBadgeVariant.values) {
        await tester.pumpWidget(
          wrap(
            AppBadge(label: 'Estado ${variant.name}', variant: variant),
            theme: CitexaTheme.dark(),
          ),
        );
        expect(find.text('Estado ${variant.name}'), findsOneWidget);
      }
    });

    testWidgets('forces an exact width when asked', (tester) async {
      await tester.pumpWidget(
        wrap(const AppBadge(label: 'A', width: 120), theme: CitexaTheme.dark()),
      );
      expect(tester.getSize(find.byType(Container).first).width, 120);
    });
  });

  group('AppLoader', () {
    testWidgets('renders a progress indicator of the requested size', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppLoader(size: 40),
          theme: CitexaTheme.dark(),
          scaffold: true,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.getSize(find.byType(SizedBox).first), const Size(40, 40));
    });

    testWidgets('AppLoadingOverlay dims the screen and shows a loader', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(width: 200, height: 200, child: AppLoadingOverlay()),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(find.byType(AppLoader), findsOneWidget);
    });
  });

  group('AppSkeleton', () {
    testWidgets('box renders and animates without errors', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSkeletonBox(width: 100, height: 20),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(AppSkeletonBox), findsOneWidget);
      expect(tester.getSize(find.byType(AppSkeletonBox)), const Size(100, 20));
      // Unmount so the repeating controller is disposed before the test ends.
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('box is static under reduced motion', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSkeletonBox(width: 100),
          theme: CitexaTheme.dark(),
          reduceMotion: true,
        ),
      );
      expect(find.byType(AppSkeletonBox), findsOneWidget);
      // No ticker is running, so settling returns immediately.
      await tester.pumpAndSettle();
    });

    testWidgets('list tile renders avatar and two lines', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(width: 300, child: AppSkeletonListTile()),
          theme: CitexaTheme.dark(),
          reduceMotion: true,
        ),
      );
      expect(find.byType(AppSkeletonBox), findsNWidgets(3));
    });
  });

  group('showAppSnackBar', () {
    Widget launcher(AppSnackBarType type) => wrap(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showAppSnackBar(
            context,
            message: 'Mensaje ${type.name}',
            type: type,
          ),
          child: const Text('abrir'),
        ),
      ),
      theme: CitexaTheme.dark(),
    );

    testWidgets('shows the message and removes it after its duration', (
      tester,
    ) async {
      await tester.pumpWidget(launcher(AppSnackBarType.info));
      await tester.tap(find.text('abrir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mensaje info'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.text('Mensaje info'), findsNothing);
    });

    testWidgets(
      'error toasts use the error icon and stay longer than info ones',
      (tester) async {
        await tester.pumpWidget(launcher(AppSnackBarType.error));
        await tester.tap(find.text('abrir'));
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        await tester.pump(
          const Duration(seconds: 4),
        ); // past the 3 s of non-error toasts
        expect(find.text('Mensaje error'), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
        expect(find.text('Mensaje error'), findsNothing);
      },
    );

    testWidgets('tapping a toast dismisses it', (tester) async {
      await tester.pumpWidget(launcher(AppSnackBarType.success));
      await tester.tap(find.text('abrir'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Mensaje success'));
      await tester.pumpAndSettle();
      expect(find.text('Mensaje success'), findsNothing);
      // Let the auto-dismiss timer elapse so no timer is left pending.
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('a new toast replaces the previous one', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => Column(
              children: [
                TextButton(
                  onPressed: () => showAppSnackBar(context, message: 'Primero'),
                  child: const Text('uno'),
                ),
                TextButton(
                  onPressed: () => showAppSnackBar(
                    context,
                    message: 'Segundo',
                    type: AppSnackBarType.warning,
                  ),
                  child: const Text('dos'),
                ),
              ],
            ),
          ),
          theme: CitexaTheme.light(),
        ),
      );
      await tester.tap(find.text('uno'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('dos'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Primero'), findsNothing);
      expect(find.text('Segundo'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();
    });
  });

  group('showAppDialog', () {
    Future<void> open(
      WidgetTester tester,
      void Function(Future<Object?>) capture, {
      String? cancel,
    }) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => capture(
                showAppDialog<bool>(
                  context,
                  title: 'Título',
                  message: 'Mensaje del diálogo',
                  confirmLabel: 'Sí',
                  cancelLabel: cancel,
                ),
              ),
              child: const Text('abrir'),
            ),
          ),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows title and message, confirm returns true', (
      tester,
    ) async {
      Future<Object?>? result;
      await open(tester, (f) => result = f);
      expect(find.text('Título'), findsOneWidget);
      expect(find.text('Mensaje del diálogo'), findsOneWidget);
      expect(find.text('No'), findsNothing); // no cancel action unless asked

      await tester.tap(find.text('Sí'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);
      expect(find.text('Título'), findsNothing);
    });

    testWidgets('cancel closes the dialog without a value', (tester) async {
      Future<Object?>? result;
      await open(tester, (f) => result = f, cancel: 'No');
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      expect(await result, isNull);
    });
  });
}

// 1x1 transparent PNG.
final Uint8List _transparentPixel = Uint8List.fromList(const <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52, //
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0xF8,
  0xFF,
  0xFF,
  0x3F,
  0x00,
  0x05,
  0xFE,
  0x02,
  0xFE,
  0xA7,
  0x35,
  0x81,
  0x84,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44, 0xAE, 0x42, 0x60, 0x82,
]);
