// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Collage Studio';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get exporting => 'Exporting…';

  @override
  String get exportPng => 'Export PNG';

  @override
  String get exportDialog => 'Export collage';

  @override
  String exportedAs(String name) {
    return 'Collage exported as $name';
  }

  @override
  String exportError(String directory) {
    return 'Could not export. Check access to $directory';
  }

  @override
  String get downloads => 'Downloads';

  @override
  String get canvas => 'Canvas';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String dropPhoto(int number) {
    return 'DROP PHOTO $number';
  }

  @override
  String get layouts => 'LAYOUTS';

  @override
  String get chooseCollage => 'Choose a collage';

  @override
  String get layoutTip => 'Pick a layout, then drag each photo into any frame.';

  @override
  String get single => 'Single';

  @override
  String get duo => 'Duo';

  @override
  String get duoRows => 'Duo rows';

  @override
  String get triptych => 'Triptych';

  @override
  String get spotlight => 'Spotlight';

  @override
  String get hero => 'Hero';

  @override
  String get grid4 => 'Grid 4';

  @override
  String get editorial => 'Editorial';

  @override
  String get filmstrip => 'Filmstrip';

  @override
  String get mosaic => 'Mosaic';

  @override
  String get grid6 => 'Grid 6';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get dropPhotosWorkspace => 'Drop photos anywhere in the workspace';

  @override
  String get output => 'OUTPUT';

  @override
  String get madeForAnywhere => 'Made for anywhere';

  @override
  String get instagramPost => 'Instagram post';

  @override
  String get instagramStory => 'Instagram story';

  @override
  String get facebookCover => 'Facebook cover';

  @override
  String get twitterPost => 'X / Twitter post';

  @override
  String get presentation => 'Presentation';

  @override
  String get print => 'Print';

  @override
  String get square => 'Square';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Landscape';

  @override
  String get widescreen => 'Widescreen';

  @override
  String get spacing => 'Spacing';

  @override
  String get cornerRadius => 'Corner radius';

  @override
  String get background => 'Background';

  @override
  String get photoEffects => 'PHOTO EFFECTS';

  @override
  String get selectPhotoToEdit => 'Select a photo in the collage to edit it.';

  @override
  String get customizeEffect => 'Apply a preset or create your own look.';

  @override
  String get normal => 'Normal';

  @override
  String get sepia => 'Sepia';

  @override
  String get blue => 'Blue';

  @override
  String get custom => 'Custom';

  @override
  String get brightness => 'Brightness';

  @override
  String get contrast => 'Contrast';

  @override
  String get saturation => 'Saturation';

  @override
  String get temperature => 'Temperature';
}
