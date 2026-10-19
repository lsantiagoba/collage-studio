// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'コラージュスタジオ';

  @override
  String get language => '言語';

  @override
  String get systemLanguage => 'システム言語';

  @override
  String get exporting => '書き出し中…';

  @override
  String get exportPng => 'PNGを書き出す';

  @override
  String get exportDialog => 'コラージュを書き出す';

  @override
  String exportedAs(String name) {
    return '$name として書き出しました';
  }

  @override
  String exportError(String directory) {
    return '書き出せません。$directory へのアクセスを確認してください';
  }

  @override
  String get downloads => 'ダウンロード';

  @override
  String get canvas => 'キャンバス';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直す';

  @override
  String dropPhoto(int number) {
    return '写真 $number をドロップ';
  }

  @override
  String get layouts => 'レイアウト';

  @override
  String get chooseCollage => 'コラージュを選択';

  @override
  String get layoutTip =>
      'レイアウトを選び、写真をフレームへドラッグします。配置済みの写真を別のフレームへドラッグすると入れ替わります。';

  @override
  String get single => '1枚';

  @override
  String get duo => 'デュオ';

  @override
  String get duoRows => '横デュオ';

  @override
  String get triptych => '三連';

  @override
  String get spotlight => 'スポットライト';

  @override
  String get hero => 'メイン';

  @override
  String get grid4 => '4分割';

  @override
  String get editorial => 'エディトリアル';

  @override
  String get filmstrip => 'フィルムストリップ';

  @override
  String get mosaic => 'モザイク';

  @override
  String get grid6 => '6分割';

  @override
  String get addPhotos => '写真を追加';

  @override
  String get dropPhotosWorkspace => 'ワークスペースに写真をドロップ';

  @override
  String get output => '出力';

  @override
  String get madeForAnywhere => 'さまざまな用途に対応';

  @override
  String get instagramPost => 'Instagram投稿';

  @override
  String get instagramStory => 'Instagramストーリー';

  @override
  String get facebookCover => 'Facebookカバー';

  @override
  String get twitterPost => 'X / Twitter投稿';

  @override
  String get presentation => 'プレゼンテーション';

  @override
  String get print => '印刷';

  @override
  String get square => '正方形';

  @override
  String get portrait => '縦向き';

  @override
  String get landscape => '横向き';

  @override
  String get widescreen => 'ワイドスクリーン';

  @override
  String get spacing => '間隔';

  @override
  String get cornerRadius => '角の丸み';

  @override
  String get background => '背景';

  @override
  String get photoEffects => '写真エフェクト';

  @override
  String get selectPhotoToEdit => '編集する写真をコラージュから選択してください。';

  @override
  String get customizeEffect => 'プリセットを適用するか独自のスタイルを作成します。';

  @override
  String get normal => '標準';

  @override
  String get sepia => 'セピア';

  @override
  String get blue => 'ブルー';

  @override
  String get custom => 'カスタム';

  @override
  String get brightness => '明るさ';

  @override
  String get contrast => 'コントラスト';

  @override
  String get saturation => '彩度';

  @override
  String get temperature => '色温度';

  @override
  String get honeycomb => 'ハニカム';

  @override
  String get newCustomLayout => '新しいカスタムレイアウト';

  @override
  String get editCustomLayout => 'カスタムレイアウトを編集';

  @override
  String get myLayouts => 'マイレイアウト';

  @override
  String get layoutName => '名前';

  @override
  String get defaultLayoutName => 'マイレイアウト';

  @override
  String get pattern => 'パターン';

  @override
  String get patternGrid => 'グリッド';

  @override
  String get patternCircles => '円';

  @override
  String get rows => '行';

  @override
  String get columns => '列';

  @override
  String get chooseCells => 'セルを選択';

  @override
  String get setOrder => '順番を設定';

  @override
  String get chooseCellsHint => 'セルをクリックしてコラージュに追加・削除します。';

  @override
  String get setOrderHint => '写真を入れたい順番でセルをクリックします。クリックしていないセルはその後に続きます。';

  @override
  String get resetOrder => '順番をリセット';

  @override
  String get useAllCells => 'すべてのセルを使用';

  @override
  String photoCount(int count) {
    return '写真: $count';
  }

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';
}
