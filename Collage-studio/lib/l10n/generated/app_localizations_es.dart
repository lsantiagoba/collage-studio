// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Estudio de Collages';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get exporting => 'Exportando…';

  @override
  String get exportPng => 'Exportar PNG';

  @override
  String get exportDialog => 'Exportar collage';

  @override
  String exportedAs(String name) {
    return 'Collage exportado como $name';
  }

  @override
  String exportError(String directory) {
    return 'No se pudo exportar. Comprueba el acceso a $directory';
  }

  @override
  String get downloads => 'Descargas';

  @override
  String get canvas => 'Lienzo';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String dropPhoto(int number) {
    return 'SOLTAR FOTO $number';
  }

  @override
  String get layouts => 'DISEÑOS';

  @override
  String get chooseCollage => 'Elige un collage';

  @override
  String get layoutTip =>
      'Elige un diseño y arrastra las fotos a los cuadros. Arrastra una foto colocada sobre otro cuadro para intercambiarlas.';

  @override
  String get single => 'Una foto';

  @override
  String get duo => 'Dúo';

  @override
  String get duoRows => 'Dúo horizontal';

  @override
  String get triptych => 'Tríptico';

  @override
  String get spotlight => 'Destacado';

  @override
  String get hero => 'Portada';

  @override
  String get grid4 => 'Cuadrícula 4';

  @override
  String get editorial => 'Editorial';

  @override
  String get filmstrip => 'Tira de película';

  @override
  String get mosaic => 'Mosaico';

  @override
  String get grid6 => 'Cuadrícula 6';

  @override
  String get addPhotos => 'Agregar fotos';

  @override
  String get dropPhotosWorkspace =>
      'Suelta fotos en cualquier parte del área de trabajo';

  @override
  String get output => 'SALIDA';

  @override
  String get madeForAnywhere => 'Diseñado para cualquier lugar';

  @override
  String get instagramPost => 'Publicación de Instagram';

  @override
  String get instagramStory => 'Historia de Instagram';

  @override
  String get facebookCover => 'Portada de Facebook';

  @override
  String get twitterPost => 'Publicación de X / Twitter';

  @override
  String get presentation => 'Presentación';

  @override
  String get print => 'Impresión';

  @override
  String get square => 'Cuadrado';

  @override
  String get portrait => 'Vertical';

  @override
  String get landscape => 'Horizontal';

  @override
  String get widescreen => 'Pantalla ancha';

  @override
  String get spacing => 'Espaciado';

  @override
  String get cornerRadius => 'Radio de esquinas';

  @override
  String get background => 'Fondo';

  @override
  String get photoEffects => 'EFECTOS DE FOTO';

  @override
  String get selectPhotoToEdit =>
      'Selecciona una foto del collage para editarla.';

  @override
  String get customizeEffect => 'Aplica un ajuste o crea tu propio estilo.';

  @override
  String get normal => 'Normal';

  @override
  String get sepia => 'Sepia';

  @override
  String get blue => 'Azul';

  @override
  String get custom => 'Personalizado';

  @override
  String get brightness => 'Brillo';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturación';

  @override
  String get temperature => 'Temperatura';

  @override
  String get honeycomb => 'Panal';

  @override
  String get newCustomLayout => 'Nuevo diseño personalizado';

  @override
  String get editCustomLayout => 'Editar diseño personalizado';

  @override
  String get myLayouts => 'MIS DISEÑOS';

  @override
  String get layoutName => 'Nombre';

  @override
  String get defaultLayoutName => 'Mi diseño';

  @override
  String get pattern => 'Patrón';

  @override
  String get patternGrid => 'Cuadrícula';

  @override
  String get patternCircles => 'Círculos';

  @override
  String get rows => 'Filas';

  @override
  String get columns => 'Columnas';

  @override
  String get chooseCells => 'Elegir celdas';

  @override
  String get setOrder => 'Definir orden';

  @override
  String get chooseCellsHint =>
      'Haz clic en una celda para añadirla al collage o quitarla.';

  @override
  String get setOrderHint =>
      'Haz clic en las celdas en el orden en que quieres que se llenen con fotos. Las demás seguirán después.';

  @override
  String get resetOrder => 'Restablecer orden';

  @override
  String get useAllCells => 'Usar todas las celdas';

  @override
  String photoCount(int count) {
    return 'Fotos: $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';
}
