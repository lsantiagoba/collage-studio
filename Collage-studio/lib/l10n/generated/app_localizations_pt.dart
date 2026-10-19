// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Estúdio de Colagens';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma do sistema';

  @override
  String get exporting => 'Exportando…';

  @override
  String get exportPng => 'Exportar PNG';

  @override
  String get exportDialog => 'Exportar colagem';

  @override
  String exportedAs(String name) {
    return 'Colagem exportada como $name';
  }

  @override
  String exportError(String directory) {
    return 'Não foi possível exportar. Verifique o acesso a $directory';
  }

  @override
  String get downloads => 'Downloads';

  @override
  String get canvas => 'Tela';

  @override
  String get undo => 'Desfazer';

  @override
  String get redo => 'Refazer';

  @override
  String dropPhoto(int number) {
    return 'SOLTAR FOTO $number';
  }

  @override
  String get layouts => 'LAYOUTS';

  @override
  String get chooseCollage => 'Escolha uma colagem';

  @override
  String get layoutTip =>
      'Escolha um layout e arraste as fotos para os quadros. Arraste uma foto já posicionada para outro quadro para trocá-las.';

  @override
  String get single => 'Única';

  @override
  String get duo => 'Dupla';

  @override
  String get duoRows => 'Dupla horizontal';

  @override
  String get triptych => 'Tríptico';

  @override
  String get spotlight => 'Destaque';

  @override
  String get hero => 'Principal';

  @override
  String get grid4 => 'Grade 4';

  @override
  String get editorial => 'Editorial';

  @override
  String get filmstrip => 'Tira de filme';

  @override
  String get mosaic => 'Mosaico';

  @override
  String get grid6 => 'Grade 6';

  @override
  String get addPhotos => 'Adicionar fotos';

  @override
  String get dropPhotosWorkspace =>
      'Solte fotos em qualquer lugar da área de trabalho';

  @override
  String get output => 'SAÍDA';

  @override
  String get madeForAnywhere => 'Feito para qualquer lugar';

  @override
  String get instagramPost => 'Publicação do Instagram';

  @override
  String get instagramStory => 'Story do Instagram';

  @override
  String get facebookCover => 'Capa do Facebook';

  @override
  String get twitterPost => 'Publicação do X / Twitter';

  @override
  String get presentation => 'Apresentação';

  @override
  String get print => 'Impressão';

  @override
  String get square => 'Quadrado';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisagem';

  @override
  String get widescreen => 'Tela ampla';

  @override
  String get spacing => 'Espaçamento';

  @override
  String get cornerRadius => 'Raio dos cantos';

  @override
  String get background => 'Fundo';

  @override
  String get photoEffects => 'EFEITOS DE FOTO';

  @override
  String get selectPhotoToEdit => 'Selecione uma foto na colagem para editar.';

  @override
  String get customizeEffect => 'Aplique uma predefinição ou crie seu estilo.';

  @override
  String get normal => 'Normal';

  @override
  String get sepia => 'Sépia';

  @override
  String get blue => 'Azul';

  @override
  String get custom => 'Personalizado';

  @override
  String get brightness => 'Brilho';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturação';

  @override
  String get temperature => 'Temperatura';

  @override
  String get honeycomb => 'Favo de mel';

  @override
  String get newCustomLayout => 'Novo layout personalizado';

  @override
  String get editCustomLayout => 'Editar layout personalizado';

  @override
  String get myLayouts => 'MEUS LAYOUTS';

  @override
  String get layoutName => 'Nome';

  @override
  String get defaultLayoutName => 'Meu layout';

  @override
  String get pattern => 'Padrão';

  @override
  String get patternGrid => 'Grade';

  @override
  String get patternCircles => 'Círculos';

  @override
  String get rows => 'Linhas';

  @override
  String get columns => 'Colunas';

  @override
  String get chooseCells => 'Escolher células';

  @override
  String get setOrder => 'Definir ordem';

  @override
  String get chooseCellsHint =>
      'Clique em uma célula para adicioná-la à colagem ou removê-la.';

  @override
  String get setOrderHint =>
      'Clique nas células na ordem em que as fotos devem preenchê-las. As demais vêm depois.';

  @override
  String get resetOrder => 'Redefinir ordem';

  @override
  String get useAllCells => 'Usar todas as células';

  @override
  String photoCount(int count) {
    return 'Fotos: $count';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';
}
