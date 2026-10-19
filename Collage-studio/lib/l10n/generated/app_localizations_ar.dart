// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'استوديو الكولاج';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

  @override
  String get exporting => 'جارٍ التصدير…';

  @override
  String get exportPng => 'تصدير PNG';

  @override
  String get exportDialog => 'تصدير الكولاج';

  @override
  String exportedAs(String name) {
    return 'تم تصدير الكولاج باسم $name';
  }

  @override
  String exportError(String directory) {
    return 'تعذر التصدير. تحقق من الوصول إلى $directory';
  }

  @override
  String get downloads => 'التنزيلات';

  @override
  String get canvas => 'لوحة العمل';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String dropPhoto(int number) {
    return 'أفلت الصورة $number';
  }

  @override
  String get layouts => 'التخطيطات';

  @override
  String get chooseCollage => 'اختر كولاجًا';

  @override
  String get layoutTip =>
      'اختر تخطيطًا ثم اسحب الصور إلى الإطارات. اسحب صورة موضوعة إلى إطار آخر لتبديلهما.';

  @override
  String get single => 'صورة واحدة';

  @override
  String get duo => 'ثنائي';

  @override
  String get duoRows => 'ثنائي أفقي';

  @override
  String get triptych => 'ثلاثي';

  @override
  String get spotlight => 'بارز';

  @override
  String get hero => 'رئيسي';

  @override
  String get grid4 => 'شبكة 4';

  @override
  String get editorial => 'تحريري';

  @override
  String get filmstrip => 'شريط فيلم';

  @override
  String get mosaic => 'فسيفساء';

  @override
  String get grid6 => 'شبكة 6';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get dropPhotosWorkspace => 'أفلت الصور في أي مكان ضمن مساحة العمل';

  @override
  String get output => 'الإخراج';

  @override
  String get madeForAnywhere => 'مناسب لكل مكان';

  @override
  String get instagramPost => 'منشور Instagram';

  @override
  String get instagramStory => 'قصة Instagram';

  @override
  String get facebookCover => 'غلاف Facebook';

  @override
  String get twitterPost => 'منشور X / Twitter';

  @override
  String get presentation => 'عرض تقديمي';

  @override
  String get print => 'طباعة';

  @override
  String get square => 'مربع';

  @override
  String get portrait => 'عمودي';

  @override
  String get landscape => 'أفقي';

  @override
  String get widescreen => 'شاشة عريضة';

  @override
  String get spacing => 'التباعد';

  @override
  String get cornerRadius => 'استدارة الزوايا';

  @override
  String get background => 'الخلفية';

  @override
  String get photoEffects => 'تأثيرات الصور';

  @override
  String get selectPhotoToEdit => 'حدد صورة في الكولاج لتحريرها.';

  @override
  String get customizeEffect => 'طبق إعدادًا مسبقًا أو أنشئ مظهرك الخاص.';

  @override
  String get normal => 'عادي';

  @override
  String get sepia => 'بني داكن';

  @override
  String get blue => 'أزرق';

  @override
  String get custom => 'مخصص';

  @override
  String get brightness => 'السطوع';

  @override
  String get contrast => 'التباين';

  @override
  String get saturation => 'التشبع';

  @override
  String get temperature => 'الحرارة';

  @override
  String get honeycomb => 'خلية نحل';

  @override
  String get newCustomLayout => 'تخطيط مخصص جديد';

  @override
  String get editCustomLayout => 'تعديل التخطيط المخصص';

  @override
  String get myLayouts => 'تخطيطاتي';

  @override
  String get layoutName => 'الاسم';

  @override
  String get defaultLayoutName => 'تخطيطي';

  @override
  String get pattern => 'النمط';

  @override
  String get patternGrid => 'شبكة';

  @override
  String get patternCircles => 'دوائر';

  @override
  String get rows => 'صفوف';

  @override
  String get columns => 'أعمدة';

  @override
  String get chooseCells => 'اختيار الخلايا';

  @override
  String get setOrder => 'تحديد الترتيب';

  @override
  String get chooseCellsHint =>
      'انقر على خلية لإضافتها إلى الكولاج أو إزالتها منه.';

  @override
  String get setOrderHint =>
      'انقر على الخلايا بالترتيب الذي تريد أن تملأها به الصور. تأتي الخلايا الأخرى بعدها.';

  @override
  String get resetOrder => 'إعادة ضبط الترتيب';

  @override
  String get useAllCells => 'استخدام كل الخلايا';

  @override
  String photoCount(int count) {
    return 'الصور: $count';
  }

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';
}
