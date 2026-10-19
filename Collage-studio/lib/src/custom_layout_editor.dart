import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import 'layout.dart';
import 'theme.dart';

enum _EditMode { cells, order }

/// Dialog for building a custom grid. Pops with the edited [CustomGridSpec],
/// or null when cancelled.
class CustomLayoutEditor extends StatefulWidget {
  const CustomLayoutEditor({
    required this.initial,
    required this.isNew,
    super.key,
  });

  final CustomGridSpec initial;
  final bool isNew;

  @override
  State<CustomLayoutEditor> createState() => _CustomLayoutEditorState();
}

class _CustomLayoutEditorState extends State<CustomLayoutEditor> {
  late CustomGridSpec _spec = widget.initial;
  late final TextEditingController _name = TextEditingController(
    text: widget.initial.name,
  );
  _EditMode _mode = _EditMode.cells;

  /// Cells clicked so far in "set order" mode. They come first in the order.
  final List<int> _picked = [];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  List<int> get _order => [
    ..._picked,
    for (final cell in _spec.order)
      if (!_picked.contains(cell)) cell,
  ];

  void _commitOrder() {
    _spec = _spec.copyWith(order: _order);
    _picked.clear();
  }

  void _setMode(_EditMode mode) => setState(() {
    _commitOrder();
    _mode = mode;
  });

  void _resize({int? rows, int? columns}) => setState(() {
    _commitOrder();
    _spec = _spec.resized(rows: rows, columns: columns);
  });

  void _tapCell(int cell) {
    setState(() {
      final enabled = _spec.order.contains(cell);
      switch (_mode) {
        case _EditMode.cells:
          if (!enabled) {
            _spec = _spec.copyWith(order: [..._spec.order, cell]);
          } else if (_spec.order.length > 1) {
            _spec = _spec.copyWith(order: [..._spec.order]..remove(cell));
          }
        case _EditMode.order:
          if (!enabled) {
            _spec = _spec.copyWith(order: [..._spec.order, cell]);
            _picked.add(cell);
          } else if (!_picked.remove(cell)) {
            _picked.add(cell);
          }
      }
    });
  }

  void _resetOrder() => setState(() {
    _picked.clear();
    _spec = _spec.copyWith(order: [..._spec.order]..sort());
  });

  void _useAllCells() => setState(() {
    _commitOrder();
    _spec = _spec.copyWith(
      order: [
        ..._spec.order,
        for (var i = 0; i < _spec.cellCount; i++)
          if (!_spec.order.contains(i)) i,
      ],
    );
  });

  void _save() {
    final name = _name.text.trim();
    Navigator.of(context).pop(
      _spec.copyWith(
        order: _order,
        name: name.isEmpty ? widget.initial.name : name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    return Dialog(
      backgroundColor: panel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: stroke),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isNew
                    ? strings.newCustomLayout
                    : strings.editCustomLayout,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 430,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 280,
                      child: SingleChildScrollView(child: _controls(strings)),
                    ),
                    const SizedBox(width: 22),
                    Expanded(child: _preview()),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 16,
                    color: muted,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    strings.photoCount(_spec.order.length),
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: muted),
                    child: Text(material.cancelButtonLabel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: lime,
                      foregroundColor: ink,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      material.saveButtonLabel,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controls(AppLocalizations strings) {
    final allUsed = _spec.order.length == _spec.cellCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _name,
          decoration: InputDecoration(
            labelText: strings.layoutName,
            isDense: true,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: stroke),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(strings.pattern.toUpperCase(), style: sectionLabelStyle),
        const SizedBox(height: 9),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final option in [
              (
                GridPattern.honeycomb,
                strings.honeycomb,
                Icons.hexagon_outlined,
              ),
              (GridPattern.grid, strings.patternGrid, Icons.grid_view_rounded),
              (
                GridPattern.circles,
                strings.patternCircles,
                Icons.circle_outlined,
              ),
            ])
              _chip(
                label: option.$2,
                icon: option.$3,
                selected: _spec.pattern == option.$1,
                onTap: () =>
                    setState(() => _spec = _spec.copyWith(pattern: option.$1)),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _Stepper(
                label: strings.rows,
                value: _spec.rows,
                onChanged: (v) => _resize(rows: v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Stepper(
                label: strings.columns,
                value: _spec.columns,
                onChanged: (v) => _resize(columns: v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: stroke),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            _chip(
              label: strings.chooseCells,
              icon: Icons.touch_app_outlined,
              selected: _mode == _EditMode.cells,
              onTap: () => _setMode(_EditMode.cells),
            ),
            _chip(
              label: strings.setOrder,
              icon: Icons.format_list_numbered_rounded,
              selected: _mode == _EditMode.order,
              onTap: () => _setMode(_EditMode.order),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _mode == _EditMode.cells
              ? strings.chooseCellsHint
              : strings.setOrderHint,
          style: const TextStyle(color: muted, fontSize: 11.5, height: 1.45),
        ),
        const SizedBox(height: 8),
        if (_mode == _EditMode.cells)
          TextButton.icon(
            onPressed: allUsed ? null : _useAllCells,
            icon: const Icon(Icons.select_all_rounded, size: 17),
            label: Text(strings.useAllCells),
          )
        else
          TextButton.icon(
            onPressed: _resetOrder,
            icon: const Icon(Icons.restart_alt_rounded, size: 17),
            label: Text(strings.resetOrder),
          ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) => ChoiceChip(
    avatar: Icon(icon, size: 16, color: selected ? lime : muted),
    showCheckmark: false,
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    selectedColor: lime.withValues(alpha: .18),
    side: BorderSide(color: selected ? lime : stroke),
    labelStyle: TextStyle(
      color: selected ? lime : muted,
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _preview() {
    final cells = List.generate(_spec.cellCount, (i) => i);
    final bounds = _spec.unitBounds(cells);
    final order = _order;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF13161B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stroke),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final size = box.biggest;
          final area = fitAspect(
            bounds.width / bounds.height,
            size.width / size.height,
          );
          return Stack(
            children: [
              for (final cell in cells)
                _previewCell(
                  cell,
                  _place(
                    normalizeRect(_spec.unitRect(cell), bounds),
                    area,
                    size,
                  ),
                  order.indexOf(cell),
                ),
            ],
          );
        },
      ),
    );
  }

  Rect _place(Rect cell, Rect area, Size size) => Rect.fromLTWH(
    (area.left + cell.left * area.width) * size.width,
    (area.top + cell.top * area.height) * size.height,
    cell.width * area.width * size.width,
    cell.height * area.height * size.height,
  ).deflate(3);

  Widget _previewCell(int cell, Rect rect, int position) {
    final enabled = position >= 0;
    final strong = _mode == _EditMode.cells ? enabled : _picked.contains(cell);
    final fontSize = (math.min(rect.width, rect.height) * .32).clamp(
      10.0,
      26.0,
    );
    final shape = _spec.shape;
    return Positioned.fromRect(
      rect: rect,
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: cellBorder(shape, 4)),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _tapCell(cell),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: ShapeDecoration(
                color: !enabled
                    ? const Color(0xFF1C1F25)
                    : strong
                    ? lime.withValues(alpha: .85)
                    : lime.withValues(alpha: .22),
                shape: cellBorder(
                  shape,
                  4,
                  BorderSide(
                    color: enabled ? lime : stroke,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
              ),
              child: Center(
                child: enabled
                    ? Text(
                        '${position + 1}',
                        style: TextStyle(
                          color: strong ? ink : lime,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : Icon(
                        Icons.add_rounded,
                        color: muted.withValues(alpha: .6),
                        size: fontSize,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: stroke),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              icon: const Icon(Icons.remove_rounded),
            ),
            Expanded(
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            IconButton(
              onPressed: value < CustomGridSpec.maxSize
                  ? () => onChanged(value + 1)
                  : null,
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    ],
  );
}
