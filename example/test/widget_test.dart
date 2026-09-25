import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Showcase app renders the design system sections', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pumpAndSettle();

    expect(find.text('Citexa Design System'), findsOneWidget);
    expect(find.text('Botones'), findsOneWidget);
  });
}
