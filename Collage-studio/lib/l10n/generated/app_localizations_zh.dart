// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '拼贴工作室';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '系统语言';

  @override
  String get exporting => '正在导出…';

  @override
  String get exportPng => '导出 PNG';

  @override
  String get exportDialog => '导出拼贴';

  @override
  String exportedAs(String name) {
    return '拼贴已导出为 $name';
  }

  @override
  String exportError(String directory) {
    return '无法导出。请检查对 $directory 的访问权限';
  }

  @override
  String get downloads => '下载';

  @override
  String get canvas => '画布';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String dropPhoto(int number) {
    return '拖放照片 $number';
  }

  @override
  String get layouts => '布局';

  @override
  String get chooseCollage => '选择拼贴布局';

  @override
  String get layoutTip => '选择布局，然后将照片拖入任意相框。';

  @override
  String get single => '单张';

  @override
  String get duo => '双栏';

  @override
  String get duoRows => '双行';

  @override
  String get triptych => '三联画';

  @override
  String get spotlight => '焦点';

  @override
  String get hero => '主视觉';

  @override
  String get grid4 => '四宫格';

  @override
  String get editorial => '杂志风';

  @override
  String get filmstrip => '胶片条';

  @override
  String get mosaic => '马赛克';

  @override
  String get grid6 => '六宫格';

  @override
  String get addPhotos => '添加照片';

  @override
  String get dropPhotosWorkspace => '将照片拖放到工作区任意位置';

  @override
  String get output => '输出';

  @override
  String get madeForAnywhere => '适用于各种平台';

  @override
  String get instagramPost => 'Instagram 帖子';

  @override
  String get instagramStory => 'Instagram 快拍';

  @override
  String get facebookCover => 'Facebook 封面';

  @override
  String get twitterPost => 'X / Twitter 帖子';

  @override
  String get presentation => '演示文稿';

  @override
  String get print => '打印';

  @override
  String get square => '方形';

  @override
  String get portrait => '竖向';

  @override
  String get landscape => '横向';

  @override
  String get widescreen => '宽屏';

  @override
  String get spacing => '间距';

  @override
  String get cornerRadius => '圆角';

  @override
  String get background => '背景';

  @override
  String get photoEffects => '照片效果';

  @override
  String get selectPhotoToEdit => '选择拼贴中的照片进行编辑。';

  @override
  String get customizeEffect => '应用预设或创建自己的风格。';

  @override
  String get normal => '正常';

  @override
  String get sepia => '棕褐色';

  @override
  String get blue => '蓝色';

  @override
  String get custom => '自定义';

  @override
  String get brightness => '亮度';

  @override
  String get contrast => '对比度';

  @override
  String get saturation => '饱和度';

  @override
  String get temperature => '色温';
}
