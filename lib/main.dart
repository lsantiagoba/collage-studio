import 'dart:io';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/generated/app_localizations.dart';

void main() => runApp(const CollageApp());

const ink = Color(0xFF111318);
const panel = Color(0xFF191C22);
const stroke = Color(0xFF2A2E36);
const lime = Color(0xFFC8FF3D);
const muted = Color(0xFF9297A3);

enum PhotoEffectPreset { normal, sepia, blue, custom }

class PhotoEffect {
  const PhotoEffect({
    this.preset = PhotoEffectPreset.normal,
    this.brightness = 0,
    this.contrast = 1,
    this.saturation = 1,
    this.warmth = 0,
  });

  final PhotoEffectPreset preset;
  final double brightness;
  final double contrast;
  final double saturation;
  final double warmth;

  PhotoEffect copyWith({
    PhotoEffectPreset? preset,
    double? brightness,
    double? contrast,
    double? saturation,
    double? warmth,
  }) => PhotoEffect(
    preset: preset ?? this.preset,
    brightness: brightness ?? this.brightness,
    contrast: contrast ?? this.contrast,
    saturation: saturation ?? this.saturation,
    warmth: warmth ?? this.warmth,
  );
}

const _normalEffect = PhotoEffect();
const _sepiaEffect = PhotoEffect(
  preset: PhotoEffectPreset.sepia,
  contrast: 1.05,
  saturation: .55,
  warmth: .55,
);
const _blueEffect = PhotoEffect(
  preset: PhotoEffectPreset.blue,
  contrast: 1.08,
  saturation: .85,
  warmth: -.65,
);

List<double> _effectMatrix(PhotoEffect effect) {
  final s = effect.saturation;
  final c = effect.contrast;
  final inverseSaturation = 1 - s;
  final red = .213 * inverseSaturation;
  final green = .715 * inverseSaturation;
  final blue = .072 * inverseSaturation;
  final baseOffset = 128 * (1 - c) + effect.brightness * 255;
  final temperature = effect.warmth * 48;
  return [
    (red + s) * c,
    green * c,
    blue * c,
    0,
    baseOffset + temperature,
    red * c,
    (green + s) * c,
    blue * c,
    0,
    baseOffset,
    red * c,
    green * c,
    (blue + s) * c,
    0,
    baseOffset - temperature,
    0,
    0,
    0,
    1,
    0,
  ];
}

class CollageApp extends StatefulWidget {
  const CollageApp({super.key});

  @override
  State<CollageApp> createState() => _CollageAppState();
}

class _CollageAppState extends State<CollageApp> {
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: const ColorScheme.dark(primary: lime, surface: panel),
        fontFamily: 'sans-serif',
        sliderTheme: const SliderThemeData(
          activeTrackColor: lime,
          inactiveTrackColor: stroke,
          thumbColor: lime,
          trackHeight: 3,
        ),
      ),
      home: CollageStudio(
        locale: _locale,
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}

class LayoutTemplate {
  const LayoutTemplate(this.name, this.cells);
  final String name;
  final List<Rect> cells;
}

const templates = <LayoutTemplate>[
  LayoutTemplate('Single', [Rect.fromLTWH(0, 0, 1, 1)]),
  LayoutTemplate('Duo', [
    Rect.fromLTWH(0, 0, .5, 1),
    Rect.fromLTWH(.5, 0, .5, 1),
  ]),
  LayoutTemplate('Duo rows', [
    Rect.fromLTWH(0, 0, 1, .5),
    Rect.fromLTWH(0, .5, 1, .5),
  ]),
  LayoutTemplate('Triptych', [
    Rect.fromLTWH(0, 0, 1 / 3, 1),
    Rect.fromLTWH(1 / 3, 0, 1 / 3, 1),
    Rect.fromLTWH(2 / 3, 0, 1 / 3, 1),
  ]),
  LayoutTemplate('Spotlight', [
    Rect.fromLTWH(0, 0, .66, 1),
    Rect.fromLTWH(.66, 0, .34, .5),
    Rect.fromLTWH(.66, .5, .34, .5),
  ]),
  LayoutTemplate('Hero', [
    Rect.fromLTWH(0, 0, 1, .68),
    Rect.fromLTWH(0, .68, 1 / 3, .32),
    Rect.fromLTWH(1 / 3, .68, 1 / 3, .32),
    Rect.fromLTWH(2 / 3, .68, 1 / 3, .32),
  ]),
  LayoutTemplate('Grid 4', [
    Rect.fromLTWH(0, 0, .5, .5),
    Rect.fromLTWH(.5, 0, .5, .5),
    Rect.fromLTWH(0, .5, .5, .5),
    Rect.fromLTWH(.5, .5, .5, .5),
  ]),
  LayoutTemplate('Editorial', [
    Rect.fromLTWH(0, 0, 1, .58),
    Rect.fromLTWH(0, .58, .5, .42),
    Rect.fromLTWH(.5, .58, .5, .42),
  ]),
  LayoutTemplate('Filmstrip', [
    Rect.fromLTWH(0, 0, 1, .34),
    Rect.fromLTWH(0, .34, 1, .32),
    Rect.fromLTWH(0, .66, 1, .34),
  ]),
  LayoutTemplate('Mosaic', [
    Rect.fromLTWH(0, 0, .6, .65),
    Rect.fromLTWH(.6, 0, .4, .32),
    Rect.fromLTWH(.6, .32, .4, .33),
    Rect.fromLTWH(0, .65, .5, .35),
    Rect.fromLTWH(.5, .65, .5, .35),
  ]),
  LayoutTemplate('Grid 6', [
    Rect.fromLTWH(0, 0, 1 / 3, .5),
    Rect.fromLTWH(1 / 3, 0, 1 / 3, .5),
    Rect.fromLTWH(2 / 3, 0, 1 / 3, .5),
    Rect.fromLTWH(0, .5, 1 / 3, .5),
    Rect.fromLTWH(1 / 3, .5, 1 / 3, .5),
    Rect.fromLTWH(2 / 3, .5, 1 / 3, .5),
  ]),
];

class ExportPreset {
  const ExportPreset(
    this.name,
    this.detail,
    this.width,
    this.height,
    this.icon,
  );
  final String name;
  final String detail;
  final int width;
  final int height;
  final IconData icon;
}

const presets = <ExportPreset>[
  ExportPreset(
    'Instagram post',
    'Square · 1080 × 1080',
    1080,
    1080,
    Icons.photo_camera_outlined,
  ),
  ExportPreset(
    'Instagram story',
    'Portrait · 1080 × 1920',
    1080,
    1920,
    Icons.smartphone_rounded,
  ),
  ExportPreset(
    'Facebook cover',
    'Landscape · 1640 × 624',
    1640,
    624,
    Icons.facebook_rounded,
  ),
  ExportPreset(
    'X / Twitter post',
    'Landscape · 1600 × 900',
    1600,
    900,
    Icons.alternate_email_rounded,
  ),
  ExportPreset(
    'Presentation',
    'Widescreen · 1920 × 1080',
    1920,
    1080,
    Icons.slideshow_rounded,
  ),
  ExportPreset(
    'Print',
    'Portrait · 2480 × 3508',
    2480,
    3508,
    Icons.print_outlined,
  ),
];

String _layoutName(AppLocalizations s, String name) => switch (name) {
  'Single' => s.single,
  'Duo' => s.duo,
  'Duo rows' => s.duoRows,
  'Triptych' => s.triptych,
  'Spotlight' => s.spotlight,
  'Hero' => s.hero,
  'Grid 4' => s.grid4,
  'Editorial' => s.editorial,
  'Filmstrip' => s.filmstrip,
  'Mosaic' => s.mosaic,
  'Grid 6' => s.grid6,
  _ => name,
};

String _presetName(AppLocalizations s, int index) => switch (index) {
  0 => s.instagramPost,
  1 => s.instagramStory,
  2 => s.facebookCover,
  3 => s.twitterPost,
  4 => s.presentation,
  _ => s.print,
};

String _presetShape(AppLocalizations s, int index) => switch (index) {
  0 => s.square,
  1 || 5 => s.portrait,
  2 || 3 => s.landscape,
  _ => s.widescreen,
};

class CollageStudio extends StatefulWidget {
  const CollageStudio({
    required this.locale,
    required this.onLocaleChanged,
    super.key,
  });

  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;

  @override
  State<CollageStudio> createState() => _CollageStudioState();
}

class _CollageStudioState extends State<CollageStudio> {
  final GlobalKey _canvasKey = GlobalKey();
  int _template = 6;
  int _preset = 0;
  double _gap = 10;
  double _radius = 8;
  Color _background = const Color(0xFFF3F0E8);
  final List<String> _photos = [];
  List<String?> _slots = List.filled(4, null);
  List<PhotoEffect> _effects = List.filled(4, _normalEffect);
  int? _selectedSlot;
  bool _dragging = false;
  bool _exporting = false;

  LayoutTemplate get layout => templates[_template];
  ExportPreset get preset => presets[_preset];

  void _selectTemplate(int index) {
    final old = _slots;
    final oldEffects = _effects;
    setState(() {
      _template = index;
      _slots = List<String?>.generate(
        templates[index].cells.length,
        (i) => i < old.length ? old[i] : null,
      );
      _effects = List<PhotoEffect>.generate(
        templates[index].cells.length,
        (i) => i < oldEffects.length ? oldEffects[i] : _normalEffect,
      );
      if (_selectedSlot != null && _selectedSlot! >= _slots.length) {
        _selectedSlot = null;
      }
    });
  }

  Future<void> _pickPhotos() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    _addPhotos(result.paths.whereType<String>());
  }

  void _addPhotos(Iterable<String> paths) {
    final valid = paths.where((p) => File(p).existsSync()).toList();
    if (valid.isEmpty) return;
    setState(() {
      for (final path in valid) {
        if (!_photos.contains(path)) _photos.add(path);
        final empty = _slots.indexOf(null);
        if (empty >= 0) _slots[empty] = path;
      }
    });
  }

  void _setSlot(int index, String path) => setState(() {
    _slots[index] = path;
    _selectedSlot = index;
  });

  void _setEffectPreset(PhotoEffectPreset preset) {
    final index = _selectedSlot;
    if (index == null || _slots[index] == null) return;
    setState(() {
      _effects[index] = switch (preset) {
        PhotoEffectPreset.normal => _normalEffect,
        PhotoEffectPreset.sepia => _sepiaEffect,
        PhotoEffectPreset.blue => _blueEffect,
        PhotoEffectPreset.custom => _effects[index].copyWith(preset: preset),
      };
    });
  }

  void _updateEffect(PhotoEffect effect) {
    final index = _selectedSlot;
    if (index == null || _slots[index] == null) return;
    setState(
      () => _effects[index] = effect.copyWith(preset: PhotoEffectPreset.custom),
    );
  }

  void _removePhoto(String path) {
    setState(() {
      _photos.remove(path);
      for (var i = 0; i < _slots.length; i++) {
        if (_slots[i] == path) {
          _slots[i] = null;
          _effects[i] = _normalEffect;
          if (_selectedSlot == i) _selectedSlot = null;
        }
      }
    });
  }

  Future<void> _export() async {
    if (_exporting) return;
    final strings = AppLocalizations.of(context)!;
    setState(() => _exporting = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _canvasKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final logicalWidth = boundary.size.width;
      final scale = (preset.width / logicalWidth).clamp(1.0, 6.0);
      final image = await boundary.toImage(pixelRatio: scale);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = data!.buffer.asUint8List();
      final name = 'lsb-collage-${DateTime.now().millisecondsSinceEpoch}.png';
      final path = await FilePicker.saveFile(
        dialogTitle: strings.exportDialog,
        fileName: name,
        type: FileType.custom,
        allowedExtensions: const ['png'],
        bytes: bytes,
      );
      if (path == null && mounted) {
        return;
      }
      if (path != null && !File(path).existsSync()) {
        await File(path).writeAsBytes(bytes);
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.exportedAs(name))));
      }
    } catch (_) {
      final directory = await getDownloadsDirectory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              strings.exportError(directory?.path ?? strings.downloads),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onExport: _export,
              exporting: _exporting,
              locale: widget.locale,
              onLocaleChanged: widget.onLocaleChanged,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, size) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: size.maxWidth < 1120 ? 1120 : size.maxWidth,
                      height: size.maxHeight,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: _TemplatesPanel(
                              selected: _template,
                              onSelected: _selectTemplate,
                            ),
                          ),
                          Expanded(child: _workspace()),
                          SizedBox(
                            width: 290,
                            child: _SettingsPanel(
                              selectedPreset: _preset,
                              gap: _gap,
                              radius: _radius,
                              background: _background,
                              selectedPhoto: _selectedSlot == null
                                  ? null
                                  : _slots[_selectedSlot!],
                              effect: _selectedSlot == null
                                  ? _normalEffect
                                  : _effects[_selectedSlot!],
                              onPreset: (v) => setState(() => _preset = v),
                              onGap: (v) => setState(() => _gap = v),
                              onRadius: (v) => setState(() => _radius = v),
                              onBackground: (v) =>
                                  setState(() => _background = v),
                              onEffectPreset: _setEffectPreset,
                              onEffectChanged: _updateEffect,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workspace() {
    final strings = AppLocalizations.of(context)!;
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (details) {
        setState(() => _dragging = false);
        _addPhotos(details.files.map((XFile f) => f.path));
      },
      child: Container(
        color: const Color(0xFF13161B),
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 18),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  strings.canvas,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                _Pill('${preset.width} × ${preset.height}'),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  tooltip: strings.undo,
                  icon: const Icon(Icons.undo_rounded, size: 19),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: strings.redo,
                  icon: const Icon(Icons.redo_rounded, size: 19),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: preset.width / preset.height,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 660,
                      maxHeight: 590,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: _dragging
                                ? lime.withValues(alpha: .25)
                                : Colors.black38,
                            blurRadius: _dragging ? 36 : 18,
                          ),
                        ],
                      ),
                      child: RepaintBoundary(
                        key: _canvasKey,
                        child: ColoredBox(
                          color: _background,
                          child: LayoutBuilder(
                            builder: (context, bounds) {
                              return Stack(
                                children: [
                                  for (var i = 0; i < layout.cells.length; i++)
                                    _cell(i, layout.cells[i], bounds.biggest),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _PhotoTray(
              photos: _photos,
              onAdd: _pickPhotos,
              onRemove: _removePhoto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(int index, Rect rect, Size size) {
    final left = rect.left * size.width + _gap / 2;
    final top = rect.top * size.height + _gap / 2;
    final width = rect.width * size.width - _gap;
    final height = rect.height * size.height - _gap;
    final photo = _slots[index];
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: photo == null
            ? null
            : () => setState(() => _selectedSlot = index),
        child: DragTarget<String>(
          onAcceptWithDetails: (d) => _setSlot(index, d.data),
          builder: (context, candidates, _) => AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: candidates.isNotEmpty
                  ? lime.withValues(alpha: .22)
                  : const Color(0xFFDCD8CF),
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: candidates.isNotEmpty || _selectedSlot == index
                    ? lime
                    : Colors.black12,
                width: candidates.isNotEmpty || _selectedSlot == index ? 3 : 1,
              ),
            ),
            child: photo == null
                ? _exporting
                      ? const SizedBox.expand()
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.black.withValues(alpha: .32),
                                size: 30,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.dropPhoto(index + 1),
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: .4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.matrix(
                          _effectMatrix(_effects[index]),
                        ),
                        child: Image.file(
                          File(photo),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const ColoredBox(color: Color(0xFFCCCCCC)),
                        ),
                      ),
                      if (!_exporting)
                        Positioned(
                          right: 7,
                          top: 7,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => setState(() {
                                _slots[index] = null;
                                _effects[index] = _normalEffect;
                                if (_selectedSlot == index) {
                                  _selectedSlot = null;
                                }
                              }),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.close, size: 13),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onExport,
    required this.exporting,
    required this.locale,
    required this.onLocaleChanged,
  });
  final VoidCallback onExport;
  final bool exporting;
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: panel,
        border: Border(bottom: BorderSide(color: stroke)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: lime,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.dashboard_customize_rounded,
              color: ink,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            strings.appTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -.5,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: strings.language,
            initialValue: locale?.languageCode ?? 'system',
            onSelected: (code) =>
                onLocaleChanged(code == 'system' ? null : Locale(code)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'system',
                child: Text(strings.systemLanguage),
              ),
              const PopupMenuDivider(),
              for (final language in const [
                ('en', 'English'),
                ('es', 'Español'),
                ('fr', 'Français'),
                ('pt', 'Português'),
                ('de', 'Deutsch'),
                ('zh', '中文'),
                ('ja', '日本語'),
                ('ru', 'Русский'),
                ('ar', 'العربية'),
              ])
                PopupMenuItem(value: language.$1, child: Text(language.$2)),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, size: 18),
                  const SizedBox(width: 7),
                  Text(strings.language),
                  const Icon(Icons.arrow_drop_down_rounded),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: exporting ? null : onExport,
            style: FilledButton.styleFrom(
              backgroundColor: lime,
              foregroundColor: ink,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            icon: exporting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ink,
                    ),
                  )
                : const Icon(Icons.file_download_outlined, size: 18),
            label: Text(
              exporting ? strings.exporting : strings.exportPng,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplatesPanel extends StatelessWidget {
  const _TemplatesPanel({required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      color: panel,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.layouts,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: muted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            strings.chooseCollage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .92,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: templates.length,
              itemBuilder: (context, i) => _TemplateCard(
                template: templates[i],
                name: _layoutName(strings, templates[i].name),
                selected: selected == i,
                onTap: () => onSelected(i),
              ),
            ),
          ),
          const Divider(color: stroke),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: lime,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  strings.layoutTip,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.name,
    required this.selected,
    required this.onTap,
  });
  final LayoutTemplate template;
  final String name;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected ? lime.withValues(alpha: .08) : const Color(0xFF20232A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? lime : stroke,
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (_, b) => Stack(
                children: [
                  for (final r in template.cells)
                    Positioned(
                      left: r.left * b.maxWidth + 1,
                      top: r.top * b.maxHeight + 1,
                      width: r.width * b.maxWidth - 3,
                      height: r.height * b.maxHeight - 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: selected
                              ? lime.withValues(alpha: .55)
                              : const Color(0xFF4A4F59),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              color: selected ? lime : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _PhotoTray extends StatelessWidget {
  const _PhotoTray({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });
  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      height: 86,
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(strings.addPhotos),
            style: OutlinedButton.styleFrom(
              foregroundColor: lime,
              side: const BorderSide(color: stroke),
              minimumSize: const Size(128, 62),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: photos.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: stroke),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        strings.dropPhotosWorkspace,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final photo = photos[i];
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Draggable<String>(
                            data: photo,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(8),
                              child: _thumb(photo),
                            ),
                            childWhenDragging: Opacity(
                              opacity: .3,
                              child: _thumb(photo),
                            ),
                            child: _thumb(photo),
                          ),
                          Positioned(
                            top: -3,
                            right: -3,
                            child: Material(
                              color: Colors.black87,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => onRemove(photo),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.close, size: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _thumb(String path) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.file(File(path), width: 80, height: 62, fit: BoxFit.cover),
  );
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.selectedPreset,
    required this.gap,
    required this.radius,
    required this.background,
    required this.selectedPhoto,
    required this.effect,
    required this.onPreset,
    required this.onGap,
    required this.onRadius,
    required this.onBackground,
    required this.onEffectPreset,
    required this.onEffectChanged,
  });
  final int selectedPreset;
  final double gap;
  final double radius;
  final Color background;
  final String? selectedPhoto;
  final PhotoEffect effect;
  final ValueChanged<int> onPreset;
  final ValueChanged<double> onGap;
  final ValueChanged<double> onRadius;
  final ValueChanged<Color> onBackground;
  final ValueChanged<PhotoEffectPreset> onEffectPreset;
  final ValueChanged<PhotoEffect> onEffectChanged;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      color: panel,
      padding: const EdgeInsets.all(18),
      child: ListView(
        children: [
          Text(
            strings.output,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: muted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            strings.madeForAnywhere,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 15),
          for (var i = 0; i < presets.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: InkWell(
                onTap: () => onPreset(i),
                borderRadius: BorderRadius.circular(9),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedPreset == i
                        ? lime.withValues(alpha: .09)
                        : const Color(0xFF20232A),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: selectedPreset == i ? lime : stroke,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        presets[i].icon,
                        size: 19,
                        color: selectedPreset == i ? lime : muted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _presetName(strings, i),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_presetShape(strings, i)} · ${presets[i].width} × ${presets[i].height}',
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selectedPreset == i)
                        const Icon(Icons.check_circle, color: lime, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 13),
          const Divider(color: stroke),
          const SizedBox(height: 10),
          _SliderSetting(
            label: strings.spacing,
            value: gap,
            max: 32,
            suffix: '${gap.round()} px',
            onChanged: onGap,
          ),
          _SliderSetting(
            label: strings.cornerRadius,
            value: radius,
            max: 36,
            suffix: '${radius.round()} px',
            onChanged: onRadius,
          ),
          const SizedBox(height: 7),
          Text(
            strings.background,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final color in const [
                Color(0xFFF3F0E8),
                Colors.white,
                Color(0xFF16181D),
                Color(0xFFE8D8FF),
                Color(0xFFD8F1EC),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => onBackground(color),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: background == color ? lime : stroke,
                          width: background == color ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: stroke),
          const SizedBox(height: 10),
          Text(
            strings.photoEffects,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: muted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            selectedPhoto == null
                ? strings.selectPhotoToEdit
                : strings.customizeEffect,
            style: const TextStyle(color: muted, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final option in [
                (PhotoEffectPreset.normal, strings.normal),
                (PhotoEffectPreset.sepia, strings.sepia),
                (PhotoEffectPreset.blue, strings.blue),
                (PhotoEffectPreset.custom, strings.custom),
              ])
                ChoiceChip(
                  label: Text(option.$2),
                  selected: effect.preset == option.$1 && selectedPhoto != null,
                  onSelected: selectedPhoto == null
                      ? null
                      : (_) => onEffectPreset(option.$1),
                  selectedColor: lime.withValues(alpha: .18),
                  side: BorderSide(
                    color: effect.preset == option.$1 && selectedPhoto != null
                        ? lime
                        : stroke,
                  ),
                  labelStyle: TextStyle(
                    color: effect.preset == option.$1 && selectedPhoto != null
                        ? lime
                        : muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 13),
          IgnorePointer(
            ignoring: selectedPhoto == null,
            child: Opacity(
              opacity: selectedPhoto == null ? .4 : 1,
              child: Column(
                children: [
                  _SliderSetting(
                    label: strings.brightness,
                    value: effect.brightness,
                    min: -1,
                    max: 1,
                    suffix: '${(effect.brightness * 100).round()}%',
                    onChanged: (value) =>
                        onEffectChanged(effect.copyWith(brightness: value)),
                  ),
                  _SliderSetting(
                    label: strings.contrast,
                    value: effect.contrast,
                    min: .5,
                    max: 1.5,
                    suffix: '${(effect.contrast * 100).round()}%',
                    onChanged: (value) =>
                        onEffectChanged(effect.copyWith(contrast: value)),
                  ),
                  _SliderSetting(
                    label: strings.saturation,
                    value: effect.saturation,
                    max: 2,
                    suffix: '${(effect.saturation * 100).round()}%',
                    onChanged: (value) =>
                        onEffectChanged(effect.copyWith(saturation: value)),
                  ),
                  _SliderSetting(
                    label: strings.temperature,
                    value: effect.warmth,
                    min: -1,
                    max: 1,
                    suffix: '${(effect.warmth * 100).round()}%',
                    onChanged: (value) =>
                        onEffectChanged(effect.copyWith(warmth: value)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.label,
    required this.value,
    this.min = 0,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(suffix, style: const TextStyle(fontSize: 10, color: muted)),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFF22262D),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: stroke),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: muted,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
