import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// The outline of every frame in a layout.
enum CellShape { rectangle, hexagon, circle }

class LayoutTemplate {
  const LayoutTemplate(
    this.name,
    this.cells, {
    this.shape = CellShape.rectangle,
    this.aspectRatio,
    this.customId,
  });

  final String name;

  /// Frames in normalized 0–1 coordinates. The list order is the photo order.
  final List<Rect> cells;
  final CellShape shape;

  /// When set, the cells keep this width / height ratio and are centered on
  /// the canvas instead of being stretched to fill it. Hexagons and circles
  /// need this to stay regular on any export size.
  final double? aspectRatio;

  /// Set for layouts the user built with the custom layout editor.
  final String? customId;

  bool get isCustom => customId != null;
  String get id => customId == null ? name : 'custom:$customId';

  /// The cells placed on a canvas of [size].
  List<Rect> cellsFor(Size size) {
    final ratio = aspectRatio;
    if (ratio == null || size.isEmpty) return cells;
    final area = fitAspect(ratio, size.width / size.height);
    return [
      for (final r in cells)
        Rect.fromLTWH(
          area.left + r.left * area.width,
          area.top + r.top * area.height,
          r.width * area.width,
          r.height * area.height,
        ),
    ];
  }
}

/// The normalized area, centered in a box of [boxAspect], that has [aspect].
Rect fitAspect(double aspect, double boxAspect) {
  var width = 1.0;
  var height = 1.0;
  if (boxAspect > aspect) {
    width = aspect / boxAspect;
  } else {
    height = boxAspect / aspect;
  }
  return Rect.fromLTWH((1 - width) / 2, (1 - height) / 2, width, height);
}

enum GridPattern { grid, honeycomb, circles }

/// Width of a pointy-top hexagon that is 2 units tall.
final _hexWidth = math.sqrt(3);

/// A user-defined layout: a grid of [rows] × [columns] cells, where [order]
/// lists the cells that are used, in the order photos fill them.
///
/// Cell `i` sits at row `i ~/ columns`, column `i % columns`.
@immutable
class CustomGridSpec {
  const CustomGridSpec({
    required this.id,
    required this.name,
    required this.pattern,
    required this.rows,
    required this.columns,
    required this.order,
  });

  /// A grid that uses every cell, in reading order.
  factory CustomGridSpec.filled({
    required String id,
    required String name,
    required GridPattern pattern,
    required int rows,
    required int columns,
  }) => CustomGridSpec(
    id: id,
    name: name,
    pattern: pattern,
    rows: rows,
    columns: columns,
    order: List.generate(rows * columns, (i) => i),
  );

  static const maxSize = 8;

  final String id;
  final String name;
  final GridPattern pattern;
  final int rows;
  final int columns;
  final List<int> order;

  int get cellCount => rows * columns;

  CellShape get shape => switch (pattern) {
    GridPattern.grid => CellShape.rectangle,
    GridPattern.honeycomb => CellShape.hexagon,
    GridPattern.circles => CellShape.circle,
  };

  CustomGridSpec copyWith({
    String? name,
    GridPattern? pattern,
    List<int>? order,
  }) => CustomGridSpec(
    id: id,
    name: name ?? this.name,
    pattern: pattern ?? this.pattern,
    rows: rows,
    columns: columns,
    order: order ?? this.order,
  );

  /// Resizes the grid, keeping the chosen cells and their order. Cells added
  /// by the resize are switched on and go at the end of the order.
  CustomGridSpec resized({int? rows, int? columns}) {
    final newRows = (rows ?? this.rows).clamp(1, maxSize);
    final newColumns = (columns ?? this.columns).clamp(1, maxSize);
    final kept = [
      for (final i in order)
        if (i ~/ this.columns < newRows && i % this.columns < newColumns)
          (i ~/ this.columns) * newColumns + i % this.columns,
    ];
    final added = [
      for (var i = 0; i < newRows * newColumns; i++)
        if (i ~/ newColumns >= this.rows || i % newColumns >= this.columns) i,
    ];
    final newOrder = [...kept, ...added];
    return CustomGridSpec(
      id: id,
      name: name,
      pattern: pattern,
      rows: newRows,
      columns: newColumns,
      order: newOrder.isEmpty
          ? List.generate(newRows * newColumns, (i) => i)
          : newOrder,
    );
  }

  /// The bounds of cell [index] in grid units. Honeycomb rows are offset by
  /// half a cell so the hexagons interlock.
  Rect unitRect(int index) {
    final row = index ~/ columns;
    final column = index % columns;
    return switch (pattern) {
      GridPattern.grid || GridPattern.circles => Rect.fromLTWH(
        column.toDouble(),
        row.toDouble(),
        1,
        1,
      ),
      GridPattern.honeycomb => Rect.fromLTWH(
        column * _hexWidth + (row.isOdd ? _hexWidth / 2 : 0),
        row * 1.5,
        _hexWidth,
        2,
      ),
    };
  }

  /// Bounds of [cells] in grid units.
  Rect unitBounds(Iterable<int> cells) =>
      cells.map(unitRect).reduce((a, b) => a.expandToInclude(b));

  LayoutTemplate toTemplate({bool custom = true}) {
    final bounds = unitBounds(order);
    return LayoutTemplate(
      name,
      [for (final i in order) normalizeRect(unitRect(i), bounds)],
      shape: shape,
      // Rectangles stretch to fill the canvas; other shapes must stay regular.
      aspectRatio: pattern == GridPattern.grid
          ? null
          : bounds.width / bounds.height,
      customId: custom ? id : null,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'pattern': pattern.name,
    'rows': rows,
    'columns': columns,
    'order': order,
  };

  /// Parses a saved spec, returning null if it is malformed.
  static CustomGridSpec? tryParse(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final name = json['name'];
    final pattern = GridPattern.values.asNameMap()[json['pattern']];
    final rows = json['rows'];
    final columns = json['columns'];
    final order = json['order'];
    if (id is! String ||
        name is! String ||
        pattern == null ||
        rows is! int ||
        columns is! int ||
        order is! List ||
        rows < 1 ||
        columns < 1 ||
        rows > maxSize ||
        columns > maxSize) {
      return null;
    }
    final cells = <int>[];
    for (final i in order) {
      if (i is int && i >= 0 && i < rows * columns && !cells.contains(i)) {
        cells.add(i);
      }
    }
    if (cells.isEmpty) return null;
    return CustomGridSpec(
      id: id,
      name: name,
      pattern: pattern,
      rows: rows,
      columns: columns,
      order: cells,
    );
  }
}

/// [rect] expressed as a fraction of [bounds].
Rect normalizeRect(Rect rect, Rect bounds) => Rect.fromLTWH(
  (rect.left - bounds.left) / bounds.width,
  (rect.top - bounds.top) / bounds.height,
  rect.width / bounds.width,
  rect.height / bounds.height,
);

/// The border used to draw and clip a frame of [shape].
OutlinedBorder cellBorder(
  CellShape shape,
  double radius, [
  BorderSide side = BorderSide.none,
]) => switch (shape) {
  CellShape.rectangle => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: side,
  ),
  CellShape.hexagon => HexagonBorder(radius: radius, side: side),
  CellShape.circle => OvalBorder(side: side),
};

/// A pointy-top hexagon that fills [rect], with corners rounded by [radius].
Path hexagonPath(Rect rect, [double radius = 0]) {
  final quarter = rect.height / 4;
  return _roundedPolygon([
    Offset(rect.center.dx, rect.top),
    Offset(rect.right, rect.top + quarter),
    Offset(rect.right, rect.bottom - quarter),
    Offset(rect.center.dx, rect.bottom),
    Offset(rect.left, rect.bottom - quarter),
    Offset(rect.left, rect.top + quarter),
  ], radius);
}

Path _roundedPolygon(List<Offset> points, double radius) {
  final path = Path();
  if (radius <= 0) return path..addPolygon(points, true);
  final n = points.length;
  for (var i = 0; i < n; i++) {
    final previous = points[(i - 1 + n) % n];
    final current = points[i];
    final next = points[(i + 1) % n];
    final inLength = (current - previous).distance;
    final outLength = (next - current).distance;
    if (inLength == 0 || outLength == 0) continue;
    final r = math.min(radius, math.min(inLength, outLength) / 2);
    final start = current - (current - previous) * (r / inLength);
    final end = current + (next - current) * (r / outLength);
    if (i == 0) {
      path.moveTo(start.dx, start.dy);
    } else {
      path.lineTo(start.dx, start.dy);
    }
    path.quadraticBezierTo(current.dx, current.dy, end.dx, end.dy);
  }
  return path..close();
}

class HexagonBorder extends OutlinedBorder {
  const HexagonBorder({super.side, this.radius = 0});

  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.strokeInset);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      hexagonPath(rect.deflate(side.strokeInset), radius);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      hexagonPath(rect.inflate(side.strokeOutset), radius);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;
    canvas.drawPath(
      hexagonPath(rect.inflate(side.strokeOffset / 2), radius),
      side.toPaint(),
    );
  }

  @override
  ShapeBorder scale(double t) =>
      HexagonBorder(side: side.scale(t), radius: radius * t);

  @override
  HexagonBorder copyWith({BorderSide? side, double? radius}) =>
      HexagonBorder(side: side ?? this.side, radius: radius ?? this.radius);

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is HexagonBorder
      ? HexagonBorder(
          side: BorderSide.lerp(a.side, side, t),
          radius: lerpDouble(a.radius, radius, t)!,
        )
      : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is HexagonBorder
      ? HexagonBorder(
          side: BorderSide.lerp(side, b.side, t),
          radius: lerpDouble(radius, b.radius, t)!,
        )
      : super.lerpTo(b, t);

  @override
  bool operator ==(Object other) =>
      other is HexagonBorder && other.side == side && other.radius == radius;

  @override
  int get hashCode => Object.hash(side, radius);
}

/// Saves custom layouts as JSON in the app support directory.
class CustomLayoutStore {
  const CustomLayoutStore();

  Future<File> _file() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/custom_layouts.json');
  }

  Future<List<CustomGridSpec>> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return [];
      final data = jsonDecode(await file.readAsString());
      if (data is! List) return [];
      return data
          .map(CustomGridSpec.tryParse)
          .whereType<CustomGridSpec>()
          .toList();
    } catch (error) {
      debugPrint('Could not load custom layouts: $error');
      return [];
    }
  }

  Future<bool> save(List<CustomGridSpec> specs) async {
    try {
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(
        jsonEncode([for (final spec in specs) spec.toJson()]),
      );
      return true;
    } catch (error) {
      debugPrint('Could not save custom layouts: $error');
      return false;
    }
  }
}
