import 'package:citexa_design_system/citexa_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders every variant with its label', (tester) async {
      for (final variant in AppButtonVariant.values) {
        await tester.pumpWidget(
          wrap(
            AppButton(
              label: 'Etiqueta ${variant.name}',
              onPressed: () {},
              variant: variant,
            ),
            theme: CitexaTheme.dark(),
          ),
        );
        expect(find.text('Etiqueta ${variant.name}'), findsOneWidget);
      }
    });

    testWidgets('fires onPressed on tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Ir', onPressed: () => taps++),
          theme: CitexaTheme.light(),
        ),
      );
      await tester.tap(find.text('Ir'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('does not fire when disabled (onPressed null)', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppButton(label: 'Ir', onPressed: null),
          theme: CitexaTheme.light(),
        ),
      );
      await tester.tap(find.text('Ir'));
      await tester.pump();
      expect(find.text('Ir'), findsOneWidget); // renders, simply inert
    });

    testWidgets('shows a loader and ignores taps while loading', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Guardar', isLoading: true, onPressed: () => taps++),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(find.byType(AppLoader), findsOneWidget);
      await tester.tap(find.text('Guardar'));
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('renders the leading icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Añadir', leadingIcon: Icons.add, onPressed: () {}),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('expand fills the available width', (tester) async {
      useScreenSize(tester, const Size(400, 800));
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Ancho', expand: true, onPressed: () {}),
          theme: CitexaTheme.dark(),
          scaffold: false,
        ),
      );
      final width = tester.getSize(find.byType(AnimatedContainer).first).width;
      expect(width, 400);
    });
  });

  group('AppTextField', () {
    testWidgets('reports typed text through onChanged', (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(
        wrap(AppTextField(onChanged: changes.add), theme: CitexaTheme.dark()),
      );
      await tester.enterText(find.byType(TextField), 'hola');
      expect(changes.last, 'hola');
    });

    testWidgets('writes into the supplied controller', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(AppTextField(controller: controller), theme: CitexaTheme.light()),
      );
      await tester.enterText(find.byType(TextField), 'abc');
      expect(controller.text, 'abc');
    });

    testWidgets(
      'shows the helper text, replaced by the error when there is one',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const AppTextField(helperText: 'Ayuda'),
            theme: CitexaTheme.dark(),
          ),
        );
        expect(find.text('Ayuda'), findsOneWidget);

        await tester.pumpWidget(
          wrap(
            const AppTextField(helperText: 'Ayuda', errorText: 'Falló'),
            theme: CitexaTheme.dark(),
          ),
        );
        expect(find.text('Falló'), findsOneWidget);
        expect(find.text('Ayuda'), findsNothing);
      },
    );

    testWidgets('error text uses the error color, not the brand color', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppTextField(errorText: 'Falló'), theme: CitexaTheme.dark()),
      );
      final text = tester.widget<Text>(find.text('Falló'));
      expect(text.style?.color, CitexaColors.dark.error);
      expect(text.style?.color, isNot(CitexaColors.dark.primary));
    });

    testWidgets('disabled field is not editable', (tester) async {
      await tester.pumpWidget(
        wrap(const AppTextField(enabled: false), theme: CitexaTheme.dark()),
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets(
      'obscures text, shows the leading icon and the trailing widget',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const AppTextField(
              obscureText: true,
              leadingIcon: Icons.lock,
              trailing: Icon(Icons.visibility),
            ),
            theme: CitexaTheme.dark(),
          ),
        );
        expect(
          tester.widget<TextField>(find.byType(TextField)).obscureText,
          isTrue,
        );
        expect(find.byIcon(Icons.lock), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets('submits through onSubmitted', (tester) async {
      String? submitted;
      await tester.pumpWidget(
        wrap(
          AppTextField(onSubmitted: (v) => submitted = v),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.enterText(find.byType(TextField), 'enviar');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'enviar');
    });
  });

  group('AppSwitch', () {
    testWidgets('reports the new value when tapped', (tester) async {
      bool? received;
      await tester.pumpWidget(
        wrap(
          AppSwitch(value: false, onChanged: (v) => received = v),
          theme: CitexaTheme.dark(),
        ),
      );
      await tester.tap(find.byType(Switch));
      expect(received, isTrue);
    });

    testWidgets('is inert when onChanged is null', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSwitch(value: true, onChanged: null),
          theme: CitexaTheme.dark(),
        ),
      );
      expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);
      await tester.tap(find.byType(Switch), warnIfMissed: false);
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    });
  });

  group('AppCheckbox', () {
    testWidgets('reports the new value when tapped', (tester) async {
      bool? received;
      await tester.pumpWidget(
        wrap(
          AppCheckbox(value: false, onChanged: (v) => received = v),
          theme: CitexaTheme.light(),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      expect(received, isTrue);
    });

    testWidgets('reflects its value and is inert when disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppCheckbox(value: true, onChanged: null),
          theme: CitexaTheme.light(),
        ),
      );
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
      expect(checkbox.onChanged, isNull);
    });
  });
}
