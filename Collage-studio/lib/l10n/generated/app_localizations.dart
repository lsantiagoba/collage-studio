import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Collage Studio'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get exporting;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'Export PNG'**
  String get exportPng;

  /// No description provided for @exportDialog.
  ///
  /// In en, this message translates to:
  /// **'Export collage'**
  String get exportDialog;

  /// No description provided for @exportedAs.
  ///
  /// In en, this message translates to:
  /// **'Collage exported as {name}'**
  String exportedAs(String name);

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Could not export. Check access to {directory}'**
  String exportError(String directory);

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @canvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas'**
  String get canvas;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @dropPhoto.
  ///
  /// In en, this message translates to:
  /// **'DROP PHOTO {number}'**
  String dropPhoto(int number);

  /// No description provided for @layouts.
  ///
  /// In en, this message translates to:
  /// **'LAYOUTS'**
  String get layouts;

  /// No description provided for @chooseCollage.
  ///
  /// In en, this message translates to:
  /// **'Choose a collage'**
  String get chooseCollage;

  /// No description provided for @layoutTip.
  ///
  /// In en, this message translates to:
  /// **'Pick a layout, then drag photos into frames. Drag a placed photo onto another frame to swap them.'**
  String get layoutTip;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @duo.
  ///
  /// In en, this message translates to:
  /// **'Duo'**
  String get duo;

  /// No description provided for @duoRows.
  ///
  /// In en, this message translates to:
  /// **'Duo rows'**
  String get duoRows;

  /// No description provided for @triptych.
  ///
  /// In en, this message translates to:
  /// **'Triptych'**
  String get triptych;

  /// No description provided for @spotlight.
  ///
  /// In en, this message translates to:
  /// **'Spotlight'**
  String get spotlight;

  /// No description provided for @hero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get hero;

  /// No description provided for @grid4.
  ///
  /// In en, this message translates to:
  /// **'Grid 4'**
  String get grid4;

  /// No description provided for @editorial.
  ///
  /// In en, this message translates to:
  /// **'Editorial'**
  String get editorial;

  /// No description provided for @filmstrip.
  ///
  /// In en, this message translates to:
  /// **'Filmstrip'**
  String get filmstrip;

  /// No description provided for @mosaic.
  ///
  /// In en, this message translates to:
  /// **'Mosaic'**
  String get mosaic;

  /// No description provided for @grid6.
  ///
  /// In en, this message translates to:
  /// **'Grid 6'**
  String get grid6;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @dropPhotosWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Drop photos anywhere in the workspace'**
  String get dropPhotosWorkspace;

  /// No description provided for @output.
  ///
  /// In en, this message translates to:
  /// **'OUTPUT'**
  String get output;

  /// No description provided for @madeForAnywhere.
  ///
  /// In en, this message translates to:
  /// **'Made for anywhere'**
  String get madeForAnywhere;

  /// No description provided for @instagramPost.
  ///
  /// In en, this message translates to:
  /// **'Instagram post'**
  String get instagramPost;

  /// No description provided for @instagramStory.
  ///
  /// In en, this message translates to:
  /// **'Instagram story'**
  String get instagramStory;

  /// No description provided for @facebookCover.
  ///
  /// In en, this message translates to:
  /// **'Facebook cover'**
  String get facebookCover;

  /// No description provided for @twitterPost.
  ///
  /// In en, this message translates to:
  /// **'X / Twitter post'**
  String get twitterPost;

  /// No description provided for @presentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get presentation;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @square.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get square;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// No description provided for @widescreen.
  ///
  /// In en, this message translates to:
  /// **'Widescreen'**
  String get widescreen;

  /// No description provided for @spacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get spacing;

  /// No description provided for @cornerRadius.
  ///
  /// In en, this message translates to:
  /// **'Corner radius'**
  String get cornerRadius;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @photoEffects.
  ///
  /// In en, this message translates to:
  /// **'PHOTO EFFECTS'**
  String get photoEffects;

  /// No description provided for @selectPhotoToEdit.
  ///
  /// In en, this message translates to:
  /// **'Select a photo in the collage to edit it.'**
  String get selectPhotoToEdit;

  /// No description provided for @customizeEffect.
  ///
  /// In en, this message translates to:
  /// **'Apply a preset or create your own look.'**
  String get customizeEffect;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @sepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get sepia;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @contrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get contrast;

  /// No description provided for @saturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get saturation;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @honeycomb.
  ///
  /// In en, this message translates to:
  /// **'Honeycomb'**
  String get honeycomb;

  /// No description provided for @newCustomLayout.
  ///
  /// In en, this message translates to:
  /// **'New custom layout'**
  String get newCustomLayout;

  /// No description provided for @editCustomLayout.
  ///
  /// In en, this message translates to:
  /// **'Edit custom layout'**
  String get editCustomLayout;

  /// No description provided for @myLayouts.
  ///
  /// In en, this message translates to:
  /// **'MY LAYOUTS'**
  String get myLayouts;

  /// No description provided for @layoutName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get layoutName;

  /// No description provided for @defaultLayoutName.
  ///
  /// In en, this message translates to:
  /// **'My layout'**
  String get defaultLayoutName;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @patternGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get patternGrid;

  /// No description provided for @patternCircles.
  ///
  /// In en, this message translates to:
  /// **'Circles'**
  String get patternCircles;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rows;

  /// No description provided for @columns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get columns;

  /// No description provided for @chooseCells.
  ///
  /// In en, this message translates to:
  /// **'Choose cells'**
  String get chooseCells;

  /// No description provided for @setOrder.
  ///
  /// In en, this message translates to:
  /// **'Set order'**
  String get setOrder;

  /// No description provided for @chooseCellsHint.
  ///
  /// In en, this message translates to:
  /// **'Click a cell to add it to the collage or remove it.'**
  String get chooseCellsHint;

  /// No description provided for @setOrderHint.
  ///
  /// In en, this message translates to:
  /// **'Click the cells in the order you want photos to fill them. Cells you don\'t click follow afterwards.'**
  String get setOrderHint;

  /// No description provided for @resetOrder.
  ///
  /// In en, this message translates to:
  /// **'Reset order'**
  String get resetOrder;

  /// No description provided for @useAllCells.
  ///
  /// In en, this message translates to:
  /// **'Use all cells'**
  String get useAllCells;

  /// No description provided for @photoCount.
  ///
  /// In en, this message translates to:
  /// **'Photos: {count}'**
  String photoCount(int count);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
