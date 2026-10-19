import 'dart:io';

enum MediaLayout { windows11, gpt, mbr }

class BootMediaException implements Exception {
  const BootMediaException(this.message);
  final String message;
  @override
  String toString() => message;
}

class BootMediaWriter {
  static Future<void> write({
    required String isoPath,
    required String devicePath,
    required String diskId,
    required MediaLayout layout,
    required void Function(double progress, String message) onProgress,
  }) async {
    if (Platform.isWindows) {
      await _writeWindows(isoPath, diskId, layout, onProgress);
    } else if (Platform.isLinux) {
      await _writeLinux(isoPath, devicePath, layout, onProgress);
    } else {
      throw const BootMediaException(
        'USB writing is currently supported on Windows and Linux only.',
      );
    }
  }

  static Future<void> _writeLinux(
    String iso,
    String device,
    MediaLayout layout,
    void Function(double, String) progress,
  ) async {
    progress(0.05, 'Checking required system tools…');
    for (final tool in ['pkexec', 'parted', 'mkfs.vfat', 'mount', 'rsync']) {
      final check = await Process.run('sh', [
        '-c',
        r'command -v "$1"',
        'check',
        tool,
      ]);
      if (check.exitCode != 0) {
        throw BootMediaException(
          'The required tool “$tool” is not installed. Install it and try again.',
        );
      }
    }
    final temp = await Directory.systemTemp.createTemp('win-usb-boot-');
    final snapCommon = Platform.environment['SNAP_COMMON'];
    final mountRoot = snapCommon == null || snapCommon.isEmpty
        ? temp.path
        : '$snapCommon/mnt/write-${DateTime.now().microsecondsSinceEpoch}';
    var rootIso = iso;
    if (iso.startsWith('/run/user/') && iso.contains('/doc/')) {
      final source = File(iso);
      final total = await source.length();
      final copy = File('${temp.path}/windows.iso');
      final sink = copy.openWrite();
      var copied = 0;
      progress(0.06, 'Preparing the ISO for administrator access…');
      try {
        await for (final chunk in source.openRead()) {
          sink.add(chunk);
          copied += chunk.length;
          progress(
            0.06 + (total == 0 ? 0 : copied / total) * 0.10,
            'Preparing the ISO… ${(copied * 100 / total).clamp(0, 100).round()}%',
          );
        }
      } finally {
        await sink.close();
      }
      await Process.run('chmod', ['644', copy.path]);
      rootIso = copy.path;
    }
    final script = File('${temp.path}/write-usb.sh');
    await script.writeAsString(r'''#!/bin/bash
set -euo pipefail
ISO="$1"; DEV="$2"; TABLE="$3"; ROOT="$4"
SRC="$ROOT/iso"; DST="$ROOT/usb"
mkdir -p "$SRC" "$DST"
cleanup() { umount "$DST" 2>/dev/null || true; umount "$SRC" 2>/dev/null || true; }
trap cleanup EXIT
test -b "$DEV" || { echo "The selected USB device no longer exists." >&2; exit 20; }
case "$DEV" in /dev/sd*|/dev/nvme*|/dev/mmcblk*) ;; *) echo "Unsafe device path refused." >&2; exit 21;; esac
BASE="$(basename "$DEV")"
SYS="/sys/class/block/$BASE"
test -e "$SYS" || { echo "The selected block device cannot be verified." >&2; exit 22; }
REAL="$(readlink -f "$SYS/device")"
REMOVABLE="$(cat "$SYS/removable" 2>/dev/null || echo 0)"
if [[ "$REAL" != *usb* && "$REMOVABLE" != 1 ]]; then
  echo "Safety check refused to erase a device that is not removable USB media." >&2
  exit 23
fi
mount -o loop,ro "$ISO" "$SRC"
WIM="$SRC/sources/install.wim"
if [ -f "$WIM" ] && [ "$(stat -c%s "$WIM")" -ge 4294967295 ] && ! command -v wimlib-imagex >/dev/null; then
  echo "This ISO contains an install.wim larger than 4 GB. Ubuntu has no built-in tool that can split it. Install the official 'wimtools' package and try again." >&2
  exit 24
fi
umount "${DEV}"* 2>/dev/null || true
wipefs -a "$DEV"
parted -s "$DEV" mklabel "$TABLE"
parted -s "$DEV" mkpart primary fat32 1MiB 100%
if [ "$TABLE" = gpt ]; then parted -s "$DEV" set 1 esp on; else parted -s "$DEV" set 1 boot on; fi
partprobe "$DEV"; udevadm settle
if [[ "$DEV" == *nvme* || "$DEV" == *mmcblk* ]]; then PART="${DEV}p1"; else PART="${DEV}1"; fi
mkfs.vfat -F 32 -n WINUSB "$PART"
mount "$PART" "$DST"
if [ -f "$WIM" ] && [ "$(stat -c%s "$WIM")" -ge 4294967295 ]; then
  rsync -rt --info=progress2 --exclude=/sources/install.wim "$SRC/" "$DST/"
  wimlib-imagex split "$WIM" "$DST/sources/install.swm" 3800
else
  rsync -rt --info=progress2 "$SRC/" "$DST/"
fi
sync
''');
    await Process.run('chmod', ['700', script.path]);
    progress(0.18, 'Waiting for administrator authorization…');
    final table = layout == MediaLayout.mbr ? 'msdos' : 'gpt';
    final process = await Process.start('pkexec', [
      script.path,
      rootIso,
      device,
      table,
      mountRoot,
    ]);
    final errors = StringBuffer();
    process.stderr.transform(SystemEncoding().decoder).listen(errors.write);
    var current = 0.22;
    process.stdout.transform(SystemEncoding().decoder).listen((line) {
      current = (current + 0.015).clamp(0.22, 0.92);
      progress(
        current,
        current < 0.4 ? 'Formatting the USB drive…' : 'Copying Windows files…',
      );
    });
    final code = await process.exitCode;
    if (code != 0) {
      throw BootMediaException(
        errors.toString().trim().isEmpty
            ? 'Formatting was cancelled or failed (error $code).'
            : errors.toString().trim(),
      );
    }
    progress(1, 'Windows USB created successfully.');
    await temp.delete(recursive: true);
  }

  static Future<void> _writeWindows(
    String iso,
    String diskId,
    MediaLayout layout,
    void Function(double, String) progress,
  ) async {
    final temp = await Directory.systemTemp.createTemp('win-usb-boot-');
    final script = File('${temp.path}/write-usb.ps1');
    final style = layout == MediaLayout.mbr ? 'MBR' : 'GPT';
    await script.writeAsString(r'''param([string]$Iso,[int]$Disk,[string]$Style)
$ErrorActionPreference='Stop'
$image=$null
try {
  $target=Get-Disk -Number $Disk
  if ($target.BusType -ne 'USB') { throw 'The selected disk is no longer identified as a USB device.' }
  $image=Mount-DiskImage -ImagePath $Iso -PassThru
  $source=($image | Get-Volume).DriveLetter + ':\'
  Clear-Disk -Number $Disk -RemoveData -RemoveOEM -Confirm:$false
  Initialize-Disk -Number $Disk -PartitionStyle $Style
  $max=[Math]::Min((Get-Disk -Number $Disk).LargestFreeExtent,32GB)
  $part=New-Partition -DiskNumber $Disk -Size $max -AssignDriveLetter
  if ($Style -eq 'MBR') { Set-Partition -DiskNumber $Disk -PartitionNumber $part.PartitionNumber -IsActive $true }
  Format-Volume -Partition $part -FileSystem FAT32 -NewFileSystemLabel WINUSB -Confirm:$false
  $dest=$part.DriveLetter + ':\'
  $wim=Join-Path $source 'sources\install.wim'
  if ((Test-Path $wim) -and ((Get-Item $wim).Length -ge 4GB)) {
    robocopy $source $dest /E /XF install.wim | Out-Null
    & dism.exe /Split-Image /ImageFile:$wim /SWMFile:"${dest}sources\install.swm" /FileSize:3800
    if ($LASTEXITCODE -ne 0) { throw "DISM failed with error $LASTEXITCODE." }
  } else {
    robocopy $source $dest /E | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "File copy failed with error $LASTEXITCODE." }
  }
} finally { if ($image) { Dismount-DiskImage -ImagePath $Iso -ErrorAction SilentlyContinue } }
''');
    final output = File('${temp.path}/output.txt');
    final errors = File('${temp.path}/error.txt');
    progress(0.12, 'Waiting for administrator authorization…');
    final args =
        '-NoProfile -ExecutionPolicy Bypass -File "${script.path}" -Iso "${iso.replaceAll('"', '""')}" -Disk $diskId -Style $style';
    final result = await Process.run('powershell', [
      '-NoProfile',
      '-Command',
      'Start-Process powershell -Verb RunAs -Wait -ArgumentList @(${_psQuote(args)}) -RedirectStandardOutput ${_psQuote(output.path)} -RedirectStandardError ${_psQuote(errors.path)}',
    ]);
    progress(0.85, 'Finalizing the Windows USB…');
    final errorText = await errors.exists() ? await errors.readAsString() : '';
    if (result.exitCode != 0 || errorText.trim().isNotEmpty) {
      throw BootMediaException(
        errorText.trim().isEmpty
            ? 'Formatting was cancelled or failed.'
            : errorText.trim(),
      );
    }
    progress(1, 'Windows USB created successfully.');
    await temp.delete(recursive: true);
  }

  static String _psQuote(String value) => "'${value.replaceAll("'", "''")}'";
}
