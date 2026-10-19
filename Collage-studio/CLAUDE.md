# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Collage Studio is a desktop-first (Linux only) Flutter photo collage editor. Users pick a layout, drop photos into frames, tweak per-photo effects, and export a PNG sized to a social/print preset. It is distributed as the snap `lsb-collage-studio`.

The git repository root is the parent directory (`../`). The app was moved into this `Collage-studio/` subfolder, so run git commands with that in mind.

## Commands

Flutter SDK is installed at `~/flutter` (use `~/flutter/bin/flutter` if `flutter` is not on PATH). Linux builds need `clang cmake ninja-build pkg-config libgtk-3-dev`.

```bash
flutter pub get                      # install deps (also regenerates l10n)
flutter run -d linux                 # run in debug (r = hot reload, q = quit)
flutter analyze                      # lint (flutter_lints; build/ and linux/ excluded)
flutter test                         # all tests
flutter test test/widget_test.dart --plain-name "allows overriding"   # single test
flutter build linux --release        # output: build/linux/x64/release/bundle
snapcraft pack                       # package the release bundle as a snap
```

If CMake fails with "CMakeCache.txt directory ... is different", the build cache came from another path. Run `flutter clean` and rebuild.

## Architecture

All app code lives in a single file, `lib/main.dart`:

- **Theme constants** (`ink`, `panel`, `stroke`, `lime`, `muted`): a fixed dark theme with a lime accent.
- **`CollageApp`** holds only the user-selected `Locale?`. `null` means "follow the system language".
- **`_CollageStudioState`** owns all editor state:
  - `_template` / `_preset` are indexes into the top-level `templates` and `presets` lists.
  - `_photos` is the tray of imported file paths.
  - `_slots` and `_effects` are parallel lists, one entry per cell of the current layout.
  - `_selectedSlot` is the photo being edited.

  Switching layouts resizes `_slots`/`_effects` and keeps entries by index. The UI is split into private stateless widgets (`_Header`, `_TemplatesPanel`, `_PhotoTray`, `_SettingsPanel`, …) that receive state and callbacks from this one state class. There is no state management package.
- **Layouts**: `LayoutTemplate` cells are `Rect`s in normalized 0–1 coordinates. They are scaled to the canvas, which takes its aspect ratio from the selected `ExportPreset`.
- **Effects**: `PhotoEffect` (brightness/contrast/saturation/warmth + preset enum) is turned into a 5×4 color matrix by `_effectMatrix` and applied with `ColorFiltered`. Editing any slider switches the preset to `custom`.
- **Export**: the canvas is wrapped in a `RepaintBoundary` (`_canvasKey`). `_export` renders it with `toImage` at `pixelRatio = preset.width / logicalWidth` (clamped 1–6), then saves the PNG through `FilePicker.saveFile`.
- **Input**: photos come from `file_picker` or OS drag-and-drop through `desktop_drop`.
- Undo/redo buttons are placeholders (`onPressed: () {}`).

## Localization

- `l10n.yaml` uses `flutter gen-l10n` with `generate: true`. ARB sources are in `lib/l10n/`, with `app_en.arb` as the template (placeholder metadata lives only there). Generated code goes to `lib/l10n/generated/`. Never hand-edit the generated files.
- Supported: en, es, fr, pt, de, zh, ja, ru, ar.
- Adding a string means updating all nine ARB files.
- Adding a language also means adding it to the hardcoded menu list in `_Header`.
- Layout and preset names are English identifiers in the data lists. They map to translated strings through `_layoutName` (by name) and `_presetName`/`_presetShape` (by index). Adding or reordering a template or preset requires updating these switches, and the tests assert specific English names.

## Packaging

`snap/snapcraft.yaml` (core24, strict confinement, gnome extension) dumps the prebuilt `build/linux/x64/release/bundle`. Run `flutter build linux --release` before `snapcraft pack`. The desktop entry and icon are in `snap/local/`.
