// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Studio de Collage';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get exporting => 'Exportation…';

  @override
  String get exportPng => 'Exporter en PNG';

  @override
  String get exportDialog => 'Exporter le collage';

  @override
  String exportedAs(String name) {
    return 'Collage exporté sous $name';
  }

  @override
  String exportError(String directory) {
    return 'Impossible d’exporter. Vérifiez l’accès à $directory';
  }

  @override
  String get downloads => 'Téléchargements';

  @override
  String get canvas => 'Toile';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String dropPhoto(int number) {
    return 'DÉPOSER PHOTO $number';
  }

  @override
  String get layouts => 'MISES EN PAGE';

  @override
  String get chooseCollage => 'Choisissez un collage';

  @override
  String get layoutTip =>
      'Choisissez une mise en page, puis glissez chaque photo dans un cadre.';

  @override
  String get single => 'Unique';

  @override
  String get duo => 'Duo';

  @override
  String get duoRows => 'Duo horizontal';

  @override
  String get triptych => 'Triptyque';

  @override
  String get spotlight => 'À la une';

  @override
  String get hero => 'Vedette';

  @override
  String get grid4 => 'Grille 4';

  @override
  String get editorial => 'Éditorial';

  @override
  String get filmstrip => 'Pellicule';

  @override
  String get mosaic => 'Mosaïque';

  @override
  String get grid6 => 'Grille 6';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get dropPhotosWorkspace =>
      'Déposez des photos dans l’espace de travail';

  @override
  String get output => 'SORTIE';

  @override
  String get madeForAnywhere => 'Adapté à tous les usages';

  @override
  String get instagramPost => 'Publication Instagram';

  @override
  String get instagramStory => 'Story Instagram';

  @override
  String get facebookCover => 'Couverture Facebook';

  @override
  String get twitterPost => 'Publication X / Twitter';

  @override
  String get presentation => 'Présentation';

  @override
  String get print => 'Impression';

  @override
  String get square => 'Carré';

  @override
  String get portrait => 'Portrait';

  @override
  String get landscape => 'Paysage';

  @override
  String get widescreen => 'Écran large';

  @override
  String get spacing => 'Espacement';

  @override
  String get cornerRadius => 'Rayon des angles';

  @override
  String get background => 'Arrière-plan';

  @override
  String get photoEffects => 'EFFETS PHOTO';

  @override
  String get selectPhotoToEdit =>
      'Sélectionnez une photo du collage à modifier.';

  @override
  String get customizeEffect => 'Appliquez un préréglage ou créez votre style.';

  @override
  String get normal => 'Normal';

  @override
  String get sepia => 'Sépia';

  @override
  String get blue => 'Bleu';

  @override
  String get custom => 'Personnalisé';

  @override
  String get brightness => 'Luminosité';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturation';

  @override
  String get temperature => 'Température';
}
