import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'boot_media_writer.dart';

void main() => runApp(const WinUsbBootApp());

class WinUsbBootApp extends StatelessWidget {
  const WinUsbBootApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF14213D);
    const blue = Color(0xFF2563EB);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Win USB Boot',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            side: BorderSide(color: Color(0xFFE5EAF2)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class UsbDrive {
  const UsbDrive({
    required this.id,
    required this.name,
    required this.size,
    this.path = '',
  });
  final String id;
  final String name;
  final int size;
  final String path;
}

enum BootProfile { windows11, modernUefi, legacy }

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.scanOnStart = true});

  final bool scanOnStart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _iso;
  bool _dragging = false;
  bool _scanning = true;
  List<UsbDrive> _drives = const [];
  String? _selectedDrive;
  BootProfile _profile = BootProfile.windows11;
  bool _writing = false;
  double _progress = 0;
  String _progressMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.scanOnStart) {
      _scanDrives();
    } else {
      _scanning = false;
    }
  }

  Future<void> _pickIso() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Choose a Windows ISO',
      type: FileType.custom,
      allowedExtensions: const ['iso'],
    );
    if (result?.files.single.path case final String path) {
      _setIso(path);
    }
  }

  void _setIso(String path) {
    if (!path.toLowerCase().endsWith('.iso')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a file ending in .iso')),
      );
      return;
    }
    setState(() => _iso = File(path));
  }

  Future<void> _scanDrives() async {
    setState(() => _scanning = true);
    try {
      final drives = Platform.isWindows
          ? await _windowsDrives()
          : await _linuxDrives();
      if (!mounted) return;
      setState(() {
        _drives = drives;
        _selectedDrive = drives.any((d) => d.id == _selectedDrive)
            ? _selectedDrive
            : (drives.length == 1 ? drives.first.id : null);
      });
    } catch (_) {
      if (mounted) setState(() => _drives = const []);
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<List<UsbDrive>> _windowsDrives() async {
    const script =
        r'''Get-CimInstance Win32_DiskDrive | Where-Object {$_.InterfaceType -eq 'USB'} | Select-Object Index,Model,Size,DeviceID | ConvertTo-Json -Compress''';
    final result = await Process.run('powershell', [
      '-NoProfile',
      '-Command',
      script,
    ]);
    if (result.exitCode != 0 || result.stdout.toString().trim().isEmpty) {
      return [];
    }
    final decoded = jsonDecode(result.stdout.toString());
    final rows = decoded is List ? decoded : [decoded];
    return rows.map((row) {
      final map = row as Map<String, dynamic>;
      return UsbDrive(
        id: '${map['Index']}',
        name: '${map['Model'] ?? 'USB drive'}'.trim(),
        size: int.tryParse('${map['Size']}') ?? 0,
        path: '${map['DeviceID'] ?? ''}',
      );
    }).toList();
  }

  Future<List<UsbDrive>> _linuxDrives() async {
    final result = await Process.run('lsblk', [
      '-J',
      '-b',
      '-d',
      '-o',
      'NAME,MODEL,SIZE,TRAN,RM,TYPE',
    ]);
    if (result.exitCode != 0) return [];
    final rows = (jsonDecode(result.stdout.toString())['blockdevices'] as List);
    return rows
        .where(
          (row) =>
              row['type'] == 'disk' &&
              (row['tran'] == 'usb' || row['rm'] == true || row['rm'] == 1),
        )
        .map((row) {
          return UsbDrive(
            id: '${row['name']}',
            name: '${row['model'] ?? 'USB drive'}'.trim(),
            size: int.tryParse('${row['size']}') ?? 0,
            path: '/dev/${row['name']}',
          );
        })
        .toList();
  }

  String _bytes(int value) {
    if (value <= 0) return 'Unknown size';
    const gb = 1024 * 1024 * 1024;
    return '${(value / gb).toStringAsFixed(value >= 10 * gb ? 0 : 1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(onRefresh: _scanDrives),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 26),
                        Text(
                          'Create your Windows installer',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose an ISO and a USB drive. We’ll recommend the safest boot setup.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: const Color(0xFF667085)),
                        ),
                        const SizedBox(height: 26),
                        LayoutBuilder(
                          builder: (context, box) {
                            final narrow = box.maxWidth < 760;
                            final source = _IsoCard(
                              iso: _iso,
                              dragging: _dragging,
                              bytes: _iso == null
                                  ? ''
                                  : _bytes(_iso!.lengthSync()),
                              onPick: _pickIso,
                              onRemove: () => setState(() => _iso = null),
                              onDrag: (value) =>
                                  setState(() => _dragging = value),
                              onDrop: _setIso,
                            );
                            final target = _UsbCard(
                              scanning: _scanning,
                              drives: _drives,
                              selected: _selectedDrive,
                              bytes: _bytes,
                              onChanged: (id) =>
                                  setState(() => _selectedDrive = id),
                              onRefresh: _scanDrives,
                            );
                            return narrow
                                ? Column(
                                    children: [
                                      source,
                                      const SizedBox(height: 18),
                                      target,
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: source),
                                      const SizedBox(width: 18),
                                      Expanded(child: target),
                                    ],
                                  );
                          },
                        ),
                        const SizedBox(height: 18),
                        _OptionsCard(
                          profile: _profile,
                          onChanged: (value) =>
                              setState(() => _profile = value),
                        ),
                        const SizedBox(height: 18),
                        _ReadyBar(
                          ready:
                              _iso != null &&
                              _selectedDrive != null &&
                              !_writing,
                          writing: _writing,
                          progress: _progress,
                          progressMessage: _progressMessage,
                          onPressed: _confirmAndWrite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndWrite() async {
    final drive = _drives.firstWhere((d) => d.id == _selectedDrive);
    final isoSize = await _iso!.length();
    if (!mounted) return;
    if (drive.size < isoSize + 64 * 1024 * 1024) {
      _showError(
        'Not enough space',
        'The ISO needs ${_bytes(isoSize)}, but ${drive.name} only has ${_bytes(drive.size)}.',
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          size: 38,
          color: Color(0xFFD97706),
        ),
        title: const Text('Are you sure you want to proceed?'),
        content: Text(
          'All data on ${drive.name} (${drive.path}) will be permanently erased. The Windows ISO will then be written to this USB drive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Erase and create'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _writing = true;
      _progress = 0;
      _progressMessage = 'Preparing…';
    });
    try {
      await BootMediaWriter.write(
        isoPath: _iso!.path,
        devicePath: drive.path,
        diskId: drive.id,
        layout: _profile == BootProfile.legacy
            ? MediaLayout.mbr
            : (_profile == BootProfile.modernUefi
                  ? MediaLayout.gpt
                  : MediaLayout.windows11),
        onProgress: (value, message) {
          if (mounted) {
            setState(() {
              _progress = value;
              _progressMessage = message;
            });
          }
        },
      );
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Color(0xFF16A36A),
              size: 42,
            ),
            title: const Text('USB ready'),
            content: const Text(
              'The Windows bootable USB was created successfully.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (mounted) _showError('Could not create the USB', error.toString());
    } finally {
      if (mounted) setState(() => _writing = false);
    }
  }

  void _showError(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 42),
        title: Text(title),
        content: SelectableText(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onRefresh});
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.usb_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text(
          'Win USB Boot',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Refresh USB drives',
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
  );
}

class _IsoCard extends StatelessWidget {
  const _IsoCard({
    required this.iso,
    required this.dragging,
    required this.bytes,
    required this.onPick,
    required this.onRemove,
    required this.onDrag,
    required this.onDrop,
  });
  final File? iso;
  final bool dragging;
  final String bytes;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final ValueChanged<bool> onDrag;
  final ValueChanged<String> onDrop;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepTitle(
            number: '1',
            title: 'Windows ISO',
            subtitle: 'Drop an official Windows image',
          ),
          const SizedBox(height: 20),
          DropTarget(
            onDragEntered: (_) => onDrag(true),
            onDragExited: (_) => onDrag(false),
            onDragDone: (detail) {
              onDrag(false);
              if (detail.files.isNotEmpty) onDrop(detail.files.first.path);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: dragging
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dragging
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1),
                  width: dragging ? 2 : 1,
                ),
              ),
              child: iso == null
                  ? InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: onPick,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            size: 42,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Drag & drop your ISO here',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'or click to browse',
                            style: TextStyle(color: Color(0xFF667085)),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            color: Color(0xFF16A36A),
                            size: 40,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  iso!.path.split(Platform.pathSeparator).last,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  bytes,
                                  style: const TextStyle(
                                    color: Color(0xFF667085),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onRemove,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _UsbCard extends StatelessWidget {
  const _UsbCard({
    required this.scanning,
    required this.drives,
    required this.selected,
    required this.bytes,
    required this.onChanged,
    required this.onRefresh,
  });
  final bool scanning;
  final List<UsbDrive> drives;
  final String? selected;
  final String Function(int) bytes;
  final ValueChanged<String?> onChanged;
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepTitle(
            number: '2',
            title: 'USB drive',
            subtitle: 'Removable drives are detected automatically',
          ),
          const SizedBox(height: 20),
          Container(
            height: 190,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: scanning
                ? const Center(child: CircularProgressIndicator())
                : drives.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.usb_off_outlined,
                        size: 38,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No USB drive found',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Connect one, then scan again',
                        style: TextStyle(color: Color(0xFF667085)),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: onRefresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Scan again'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target drive',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selected,
                        isExpanded: true,
                        hint: const Text('Choose a USB drive'),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        items: drives
                            .map(
                              (d) => DropdownMenuItem(
                                value: d.id,
                                child: Text(
                                  '${d.name} • ${bytes(d.size)}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: onChanged,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: Color(0xFFD97706),
                          ),
                          const SizedBox(width: 7),
                          const Expanded(
                            child: Text(
                              'The selected drive will be completely erased.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    ),
  );
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({
    required this.number,
    required this.title,
    required this.subtitle,
  });
  final String number;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFEFF6FF),
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: const TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
            ),
          ],
        ),
      ),
    ],
  );
}

class _OptionsCard extends StatelessWidget {
  const _OptionsCard({required this.profile, required this.onChanged});
  final BootProfile profile;
  final ValueChanged<BootProfile> onChanged;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepTitle(
            number: '3',
            title: 'Boot compatibility',
            subtitle: 'Windows 11 recommended settings are selected for you',
          ),
          const SizedBox(height: 18),
          SegmentedButton<BootProfile>(
            segments: const [
              ButtonSegment(
                value: BootProfile.windows11,
                icon: Icon(Icons.recommend_outlined),
                label: Text('Windows 11'),
              ),
              ButtonSegment(
                value: BootProfile.modernUefi,
                icon: Icon(Icons.security_outlined),
                label: Text('UEFI / GPT'),
              ),
              ButtonSegment(
                value: BootProfile.legacy,
                icon: Icon(Icons.history),
                label: Text('Legacy / MBR'),
              ),
            ],
            selected: {profile},
            onSelectionChanged: (value) => onChanged(value.first),
          ),
        ],
      ),
    ),
  );
}

class _ReadyBar extends StatelessWidget {
  const _ReadyBar({
    required this.ready,
    required this.writing,
    required this.progress,
    required this.progressMessage,
    required this.onPressed,
  });
  final bool ready;
  final bool writing;
  final double progress;
  final String progressMessage;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => writing
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              progressMessage,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress <= 0 ? null : progress),
            const SizedBox(height: 5),
            Text(
              '${(progress * 100).round()}%',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
          ],
        )
      : Row(
          children: [
            const Icon(Icons.lock_outline, size: 18, color: Color(0xFF667085)),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Nothing is erased until you review and confirm.',
                style: TextStyle(color: Color(0xFF667085)),
              ),
            ),
            FilledButton.icon(
              onPressed: ready ? onPressed : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Create bootable USB'),
              ),
            ),
          ],
        );
}
