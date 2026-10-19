import 'package:collage_studio/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('includes starter layouts for one to six photos', () {
    expect(templates.first.name, 'Single');
    expect(templates.first.cells, hasLength(1));
    expect(
      templates.map((template) => template.name),
      containsAll(['Duo rows', 'Triptych', 'Hero', 'Grid 6']),
    );
    expect(templates.last.cells, hasLength(6));
  });

  testWidgets('shows collage editor and social presets', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const CollageApp());
    expect(find.text('Choose a collage'), findsOneWidget);
    expect(find.text('Instagram post'), findsOneWidget);
    expect(find.text('Export PNG'), findsOneWidget);
    expect(find.text('Collage Studio'), findsOneWidget);
    expect(find.text('Open project'), findsNothing);
    expect(find.text('DROP PHOTO 1'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('PHOTO EFFECTS'), findsOneWidget);
    expect(find.text('Sepia'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(
      find.text('Select a photo in the collage to edit it.'),
      findsOneWidget,
    );
  });

  testWidgets('allows overriding the detected system language', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const CollageApp());

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(find.text('Estudio de Collages'), findsOneWidget);
    expect(find.text('Exportar PNG'), findsOneWidget);
    expect(find.text('Elige un collage'), findsOneWidget);
  });
}
