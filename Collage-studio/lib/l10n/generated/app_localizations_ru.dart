// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Студия коллажей';

  @override
  String get language => 'Язык';

  @override
  String get systemLanguage => 'Язык системы';

  @override
  String get exporting => 'Экспорт…';

  @override
  String get exportPng => 'Экспорт PNG';

  @override
  String get exportDialog => 'Экспорт коллажа';

  @override
  String exportedAs(String name) {
    return 'Коллаж экспортирован как $name';
  }

  @override
  String exportError(String directory) {
    return 'Не удалось экспортировать. Проверьте доступ к $directory';
  }

  @override
  String get downloads => 'Загрузки';

  @override
  String get canvas => 'Холст';

  @override
  String get undo => 'Отменить';

  @override
  String get redo => 'Повторить';

  @override
  String dropPhoto(int number) {
    return 'ПОМЕСТИТЬ ФОТО $number';
  }

  @override
  String get layouts => 'МАКЕТЫ';

  @override
  String get chooseCollage => 'Выберите коллаж';

  @override
  String get layoutTip => 'Выберите макет и перетащите фотографии в рамки.';

  @override
  String get single => 'Одно фото';

  @override
  String get duo => 'Дуэт';

  @override
  String get duoRows => 'Дуэт по горизонтали';

  @override
  String get triptych => 'Триптих';

  @override
  String get spotlight => 'Акцент';

  @override
  String get hero => 'Главный кадр';

  @override
  String get grid4 => 'Сетка 4';

  @override
  String get editorial => 'Редакционный';

  @override
  String get filmstrip => 'Фотоплёнка';

  @override
  String get mosaic => 'Мозаика';

  @override
  String get grid6 => 'Сетка 6';

  @override
  String get addPhotos => 'Добавить фото';

  @override
  String get dropPhotosWorkspace => 'Перетащите фото в рабочую область';

  @override
  String get output => 'ВЫВОД';

  @override
  String get madeForAnywhere => 'Для любых площадок';

  @override
  String get instagramPost => 'Публикация Instagram';

  @override
  String get instagramStory => 'История Instagram';

  @override
  String get facebookCover => 'Обложка Facebook';

  @override
  String get twitterPost => 'Публикация X / Twitter';

  @override
  String get presentation => 'Презентация';

  @override
  String get print => 'Печать';

  @override
  String get square => 'Квадрат';

  @override
  String get portrait => 'Портрет';

  @override
  String get landscape => 'Альбом';

  @override
  String get widescreen => 'Широкий экран';

  @override
  String get spacing => 'Интервал';

  @override
  String get cornerRadius => 'Скругление углов';

  @override
  String get background => 'Фон';

  @override
  String get photoEffects => 'ФОТОЭФФЕКТЫ';

  @override
  String get selectPhotoToEdit => 'Выберите фото в коллаже для редактирования.';

  @override
  String get customizeEffect => 'Примените шаблон или создайте свой стиль.';

  @override
  String get normal => 'Обычный';

  @override
  String get sepia => 'Сепия';

  @override
  String get blue => 'Синий';

  @override
  String get custom => 'Свой';

  @override
  String get brightness => 'Яркость';

  @override
  String get contrast => 'Контраст';

  @override
  String get saturation => 'Насыщенность';

  @override
  String get temperature => 'Температура';
}
