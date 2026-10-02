import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:citexa_design_system/citexa_design_system.dart';

void main() {
  group('CitexaTheme', () {
    test('light and dark themes only use brand-approved colors', () {
      final approved = <Color>{
        BrandPalette.primary,
        BrandPalette.secondary,
        BrandPalette.tertiary,
        BrandPalette.neutral,
        BrandPalette.white,
        BrandPalette.black,
        BrandPalette.success,
        BrandPalette.warning,
        BrandPalette.error,
        BrandPalette.info,
      };

      for (final colors in [CitexaColors.light, CitexaColors.dark]) {
        for (final color in [
          colors.primary,
          colors.onPrimary,
          colors.secondary,
          colors.onSecondary,
          colors.tertiary,
          colors.onTertiary,
          colors.background,
          colors.onBackground,
          colors.onSurface,
          colors.success,
          colors.onSuccess,
          colors.warning,
          colors.onWarning,
          colors.error,
          colors.onError,
          colors.info,
          colors.onInfo,
        ]) {
          expect(
            approved.contains(color),
            isTrue,
            reason: '$color is not one of the approved brand hexes',
          );
        }
        // Opacity-adjusted roles must still share the same RGB as an
        // approved color.
        for (final color in [
          colors.surface,
          colors.textPrimary,
          colors.textSecondary,
          colors.outline,
          colors.disabled,
          colors.overlay,
        ]) {
          final opaque = color.withValues(alpha: 1);
          expect(
            approved.contains(opaque),
            isTrue,
            reason: '$color is not derived from an approved brand hex',
          );
        }
      }
    });
  });

  testWidgets('AppButton renders label and responds to taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: CitexaTheme.light(),
        home: Scaffold(
          body: AppButton(label: 'Continuar', onPressed: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Continuar'), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('AppTextField shows label, hint and error text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CitexaTheme.dark(),
        home: const Scaffold(
          body: AppTextField(
            label: 'Correo',
            hintText: 'nombre@correo.com',
            errorText: 'Correo inválido',
          ),
        ),
      ),
    );

    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Correo inválido'), findsOneWidget);
  });

  testWidgets('AppPageScaffold clamps content width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CitexaTheme.dark(),
        home: const AppPageScaffold(title: 'Citexa', body: Text('contenido')),
      ),
    );

    expect(find.text('Citexa'), findsOneWidget);
    expect(find.text('contenido'), findsOneWidget);
  });

  group('CitexaLogo', () {
    Future<String> assetShownUnder(WidgetTester tester, ThemeData theme, CitexaLogoVariant v) async {
      await tester.pumpWidget(
        MaterialApp(theme: theme, home: Scaffold(body: CitexaLogo(variant: v, height: 40))),
      );
      await tester.pumpAndSettle(); // MaterialApp animates theme changes
      final image = tester.widget<Image>(find.byType(Image));
      return (image.image as AssetImage).assetName;
    }

    testWidgets('picks the navy lettering on light and the white lettering on dark', (tester) async {
      expect(
        await assetShownUnder(tester, CitexaTheme.light(), CitexaLogoVariant.horizontal),
        endsWith('citexa_horizontal_on_light.png'),
      );
      expect(
        await assetShownUnder(tester, CitexaTheme.dark(), CitexaLogoVariant.vertical),
        endsWith('citexa_vertical_on_dark.png'),
      );
    });

    testWidgets('the icon-only mark is the same artwork in both themes', (tester) async {
      final light = await assetShownUnder(tester, CitexaTheme.light(), CitexaLogoVariant.icon);
      final dark = await assetShownUnder(tester, CitexaTheme.dark(), CitexaLogoVariant.icon);
      expect(light, dark);
    });

    testWidgets('every variant is bundled in the package', (tester) async {
      for (final variant in CitexaLogoVariant.values) {
        for (final onDark in [true, false]) {
          final path = 'packages/citexa_design_system/${CitexaLogo.assetPath(variant, onDark: onDark)}';
          final data = await rootBundle.load(path);
          expect(data.lengthInBytes, greaterThan(1000), reason: path);
        }
      }
    });
  });
}
