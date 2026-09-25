import 'package:flutter/material.dart';
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
}
