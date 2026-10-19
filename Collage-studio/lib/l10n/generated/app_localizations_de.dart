// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Collage-Studio';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get exporting => 'Exportieren…';

  @override
  String get exportPng => 'PNG exportieren';

  @override
  String get exportDialog => 'Collage exportieren';

  @override
  String exportedAs(String name) {
    return 'Collage exportiert als $name';
  }

  @override
  String exportError(String directory) {
    return 'Export nicht möglich. Zugriff auf $directory prüfen';
  }

  @override
  String get downloads => 'Downloads';

  @override
  String get canvas => 'Leinwand';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String dropPhoto(int number) {
    return 'FOTO $number ABLEGEN';
  }

  @override
  String get layouts => 'LAYOUTS';

  @override
  String get chooseCollage => 'Collage auswählen';

  @override
  String get layoutTip => 'Layout auswählen und Fotos in die Rahmen ziehen.';

  @override
  String get single => 'Einzelfoto';

  @override
  String get duo => 'Duo';

  @override
  String get duoRows => 'Duo horizontal';

  @override
  String get triptych => 'Triptychon';

  @override
  String get spotlight => 'Blickfang';

  @override
  String get hero => 'Titelbild';

  @override
  String get grid4 => 'Raster 4';

  @override
  String get editorial => 'Editorial';

  @override
  String get filmstrip => 'Filmstreifen';

  @override
  String get mosaic => 'Mosaik';

  @override
  String get grid6 => 'Raster 6';

  @override
  String get addPhotos => 'Fotos hinzufügen';

  @override
  String get dropPhotosWorkspace => 'Fotos im Arbeitsbereich ablegen';

  @override
  String get output => 'AUSGABE';

  @override
  String get madeForAnywhere => 'Für jeden Einsatz';

  @override
  String get instagramPost => 'Instagram-Beitrag';

  @override
  String get instagramStory => 'Instagram-Story';

  @override
  String get facebookCover => 'Facebook-Titelbild';

  @override
  String get twitterPost => 'X-/Twitter-Beitrag';

  @override
  String get presentation => 'Präsentation';

  @override
  String get print => 'Druck';

  @override
  String get square => 'Quadratisch';

  @override
  String get portrait => 'Hochformat';

  @override
  String get landscape => 'Querformat';

  @override
  String get widescreen => 'Breitbild';

  @override
  String get spacing => 'Abstand';

  @override
  String get cornerRadius => 'Eckenradius';

  @override
  String get background => 'Hintergrund';

  @override
  String get photoEffects => 'FOTOEFFEKTE';

  @override
  String get selectPhotoToEdit =>
      'Foto in der Collage zum Bearbeiten auswählen.';

  @override
  String get customizeEffect => 'Vorgabe anwenden oder eigenen Look erstellen.';

  @override
  String get normal => 'Normal';

  @override
  String get sepia => 'Sepia';

  @override
  String get blue => 'Blau';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Sättigung';

  @override
  String get temperature => 'Temperatur';
}
