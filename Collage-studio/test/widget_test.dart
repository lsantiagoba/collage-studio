import 'package:collage_studio/main.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  test('honeycomb hexagons stay regular on any canvas shape', () {
    final honeycomb = templates.firstWhere((t) => t.name == 'Honeycomb');
    expect(honeycomb.shape, CellShape.hexagon);
    expect(honeycomb.cells, hasLength(7));
    for (final size in const [Size(1600, 900), Size(1080, 1920)]) {
      for (final cell in honeycomb.cellsFor(size)) {
        final ratio = cell.width * size.width / (cell.height * size.height);
        expect(ratio, closeTo(math.sqrt(3) / 2, 1e-9));
        expect(cell.left, greaterThanOrEqualTo(-1e-9));
        expect(cell.right, lessThanOrEqualTo(1 + 1e-9));
      }
    }
  });

  test('custom grid keeps its cells and order when resized', () {
    const spec = CustomGridSpec(
      id: 'a',
      name: 'A',
      pattern: GridPattern.grid,
      rows: 2,
      columns: 2,
      order: [3, 0],
    );
    final wider = spec.resized(columns: 3);
    // Cell 3 (row 1, col 1) becomes 4; the new column's cells are appended.
    expect(wider.order, [4, 0, 2, 5]);
    expect(spec.resized(rows: 1).order, [0]);
    final template = spec.toTemplate();
    expect(template.cells, hasLength(2));
    expect(template.cells.first, const Rect.fromLTWH(.5, .5, .5, .5));
  });

  test('custom grids survive a save round trip and reject bad data', () {
    const spec = CustomGridSpec(
      id: 'b',
      name: 'Hive',
      pattern: GridPattern.honeycomb,
      rows: 3,
      columns: 4,
      order: [5, 1, 2],
    );
    final copy = CustomGridSpec.tryParse(spec.toJson())!;
    expect(copy.name, 'Hive');
    expect(copy.pattern, GridPattern.honeycomb);
    expect(copy.order, [5, 1, 2]);
    expect(CustomGridSpec.tryParse({'id': 'x'}), isNull);
    expect(
      CustomGridSpec.tryParse({
        ...spec.toJson(),
        'order': [99],
      }),
      isNull,
    );
  });

  testWidgets('creates a custom honeycomb layout', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const CollageApp());

    await tester.tap(find.text('New custom layout'));
    await tester.pumpAndSettle();
    expect(find.text('Photos: 7'), findsOneWidget);

    // Switching to set-order mode and clicking cell 7 makes it first.
    await tester.tap(find.text('Set order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('7'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('MY LAYOUTS'), findsOneWidget);
    expect(find.text('My layout 1'), findsOneWidget);
    expect(find.text('DROP PHOTO 7'), findsOneWidget);
  });

  testWidgets('undo and redo layout changes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(const CollageApp());

    await tester.tap(find.text('Triptych'));
    await tester.pumpAndSettle();
    expect(find.text('DROP PHOTO 3'), findsOneWidget);
    expect(find.text('DROP PHOTO 4'), findsNothing);

    await tester.tap(find.byIcon(Icons.undo_rounded));
    await tester.pumpAndSettle();
    expect(find.text('DROP PHOTO 4'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyY);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.text('DROP PHOTO 4'), findsNothing);
  });
}
