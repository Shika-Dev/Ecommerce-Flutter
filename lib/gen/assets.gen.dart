/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Documents.svg
  String get documents => 'assets/icons/Documents.svg';

  /// File path: assets/icons/Search.svg
  String get search => 'assets/icons/Search.svg';

  /// File path: assets/icons/drop_box.svg
  String get dropBox => 'assets/icons/drop_box.svg';

  /// File path: assets/icons/folder.svg
  String get folder => 'assets/icons/folder.svg';

  /// File path: assets/icons/logo.svg
  String get logo => 'assets/icons/logo.svg';

  /// File path: assets/icons/media.svg
  String get media => 'assets/icons/media.svg';

  /// File path: assets/icons/menu_dashbord.svg
  String get menuDashbord => 'assets/icons/menu_dashbord.svg';

  /// File path: assets/icons/menu_doc.svg
  String get menuDoc => 'assets/icons/menu_doc.svg';

  /// File path: assets/icons/menu_notification.svg
  String get menuNotification => 'assets/icons/menu_notification.svg';

  /// File path: assets/icons/menu_profile.svg
  String get menuProfile => 'assets/icons/menu_profile.svg';

  /// File path: assets/icons/menu_setting.svg
  String get menuSetting => 'assets/icons/menu_setting.svg';

  /// File path: assets/icons/menu_store.svg
  String get menuStore => 'assets/icons/menu_store.svg';

  /// File path: assets/icons/menu_task.svg
  String get menuTask => 'assets/icons/menu_task.svg';

  /// File path: assets/icons/menu_tran.svg
  String get menuTran => 'assets/icons/menu_tran.svg';

  /// File path: assets/icons/sevva_logo.png
  AssetGenImage get sevvaLogo =>
      const AssetGenImage('assets/icons/sevva_logo.png');

  /// File path: assets/icons/sevva_logo_jpg.jpg
  AssetGenImage get sevvaLogoJpg =>
      const AssetGenImage('assets/icons/sevva_logo_jpg.jpg');

  /// File path: assets/icons/unknown.svg
  String get unknown => 'assets/icons/unknown.svg';

  /// List of all assets
  List<dynamic> get values => [
        documents,
        search,
        dropBox,
        folder,
        logo,
        media,
        menuDashbord,
        menuDoc,
        menuNotification,
        menuProfile,
        menuSetting,
        menuStore,
        menuTask,
        menuTran,
        sevvaLogo,
        sevvaLogoJpg,
        unknown
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/ic_call_24.png
  AssetGenImage get icCall24 =>
      const AssetGenImage('assets/images/ic_call_24.png');

  /// File path: assets/images/ic_cashback.png
  AssetGenImage get icCashback =>
      const AssetGenImage('assets/images/ic_cashback.png');

  /// File path: assets/images/ic_delivery.png
  AssetGenImage get icDelivery =>
      const AssetGenImage('assets/images/ic_delivery.png');

  /// File path: assets/images/ic_google.png
  AssetGenImage get icGoogle =>
      const AssetGenImage('assets/images/ic_google.png');

  /// File path: assets/images/ic_premium.png
  AssetGenImage get icPremium =>
      const AssetGenImage('assets/images/ic_premium.png');

  /// File path: assets/images/img_clock.png
  AssetGenImage get imgClock =>
      const AssetGenImage('assets/images/img_clock.png');

  /// File path: assets/images/img_wardrobe.png
  AssetGenImage get imgWardrobe =>
      const AssetGenImage('assets/images/img_wardrobe.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        icCall24,
        icCashback,
        icDelivery,
        icGoogle,
        icPremium,
        imgClock,
        imgWardrobe
      ];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/logo.png
  AssetGenImage get logoPng => const AssetGenImage('assets/logo/logo.png');

  /// File path: assets/logo/logo.svg
  String get logoSvg => 'assets/logo/logo.svg';

  /// File path: assets/logo/logo_icon.png
  AssetGenImage get logoIcon =>
      const AssetGenImage('assets/logo/logo_icon.png');

  /// File path: assets/logo/logo_name.svg
  String get logoName => 'assets/logo/logo_name.svg';

  /// File path: assets/logo/logo_text.png
  AssetGenImage get logoText =>
      const AssetGenImage('assets/logo/logo_text.png');

  /// List of all assets
  List<dynamic> get values => [logoPng, logoSvg, logoIcon, logoName, logoText];
}

class $AssetsSlidesGen {
  const $AssetsSlidesGen();

  /// File path: assets/slides/background-1.jpeg
  AssetGenImage get background1 =>
      const AssetGenImage('assets/slides/background-1.jpeg');

  /// File path: assets/slides/background-2.jpeg
  AssetGenImage get background2 =>
      const AssetGenImage('assets/slides/background-2.jpeg');

  /// File path: assets/slides/background-3.jpeg
  AssetGenImage get background3 =>
      const AssetGenImage('assets/slides/background-3.jpeg');

  /// File path: assets/slides/background.jpeg
  AssetGenImage get background =>
      const AssetGenImage('assets/slides/background.jpeg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [background1, background2, background3, background];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
  static const $AssetsSlidesGen slides = $AssetsSlidesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
