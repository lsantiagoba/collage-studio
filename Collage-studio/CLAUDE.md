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

App code is in `lib/main.dart` plus three files under `lib/src/`:

- **`src/theme.dart`**: a fixed dark theme with a lime accent (`ink`, `panel`, `stroke`, `lime`, `muted`, `card`, `sectionLabelStyle`).
- **`src/layout.dart`**: the layout model and geometry (re-exported by `main.dart`).
  - `LayoutTemplate` cells are `Rect`s in normalized 0–1 coordinates, listed in photo order. `shape` (`CellShape.rectangle/hexagon/circle`) sets the frame outline. Rectangle layouts stretch to the canvas. When `aspectRatio` is set, `cellsFor(size)` centers the cells at that ratio, which keeps hexagons and circles regular.
  - `CustomGridSpec` is a user-built layout: a `rows × columns` grid (max 8×8) in a `GridPattern` (grid, honeycomb or circles). `order` lists the cells that are used, in fill order (cell `i` = row `i ~/ columns`, column `i % columns`). Honeycomb rows are offset by half a cell. `toTemplate()` turns it into a `LayoutTemplate`.
  - `cellBorder()` / `HexagonBorder` draw and clip frames. Cells are wrapped in `ClipPath(ShapeBorderClipper)` so overlapping hexagon bounds don't steal each other's clicks and drops.
  - `CustomLayoutStore` saves custom layouts as JSON in `getApplicationSupportDirectory()/custom_layouts.json`.
- **`src/custom_layout_editor.dart`**: the `CustomLayoutEditor` dialog. It has two modes: choose cells (toggle) and set order (cells you click come first).
- **`main.dart`**:
  - `CollageApp` holds only the user-selected `Locale?`. `null` means "follow the system language".
  - `_CollageStudioState` owns all editor state. `_templateId` is a `LayoutTemplate.id`: the English name for built-ins, `custom:<id>` for custom layouts. `_slots`/`_effects` are parallel lists, one entry per cell. `_fitSlotsToLayout()` resizes them, keeping entries by index. The UI is split into private stateless widgets (`_Header`, `_TemplatesPanel`, `_PhotoTray`, `_SettingsPanel`, …) that get state and callbacks from this class. There is no state management package.
  - **Undo/redo**: call `_record()` before any change you want to be undoable. It pushes a `_Snapshot` (template, preset, gap, radius, background, photos, slots, effects). Sliders record once on `onChangeStart`. Custom layout definitions are not part of history. Shortcuts: Ctrl+Z, Ctrl+Shift+Z / Ctrl+Y, and Delete (clears the selected frame).
  - **Effects**: `PhotoEffect` (brightness/contrast/saturation/warmth + preset enum) becomes a 5×4 color matrix in `_effectMatrix`, applied with `ColorFiltered`. Editing any color slider switches the preset to `custom`. `PhotoEffect` also holds the photo's rotation (`quarterTurns` 0–3 via `RotatedBox`, plus a fine `angle` of ±45° via `Transform.rotate`, zoomed by `rotationCoverScale` so the frame stays covered). Switching color presets keeps the rotation (`withRotationOf`). Shortcuts: R / Shift+R rotate the selected photo.
  - **Export**: the canvas is wrapped in a `RepaintBoundary` (`_canvasKey`). `_export` renders it with `toImage` at `pixelRatio = preset.width / logicalWidth` (clamped 1–6) and saves through `FilePicker.saveFile`. While `_exporting` is true, frame outlines, placeholders and remove buttons are hidden.
  - **Input**: photos come from `file_picker` or OS drag-and-drop (`desktop_drop`). Tray thumbnails drag as `String` paths. Placed photos drag as `_SlotDrag` to swap two frames.

## Localization

- `l10n.yaml` uses `flutter gen-l10n` with `generate: true`. ARB sources are in `lib/l10n/`, with `app_en.arb` as the template (placeholder metadata lives only there). Generated code goes to `lib/l10n/generated/`. Never hand-edit the generated files.
- Supported: en, es, fr, pt, de, zh, ja, ru, ar.
- Adding a string means updating all nine ARB files.
- Adding a language also means adding it to the hardcoded menu list in `_Header`.
- Built-in layout and preset names are English identifiers in the data lists. They map to translated strings through `_layoutName` (by name) and `_presetName`/`_presetShape` (by index). Adding or reordering a template or preset requires updating these switches, and the tests assert specific English names. Custom layout names are user text and are shown as-is.

## Packaging

`snap/snapcraft.yaml` (core24, strict confinement, gnome extension) dumps the prebuilt `build/linux/x64/release/bundle`. Run `flutter build linux --release` before `snapcraft pack`. The desktop entry and icon are in `snap/local/`.
