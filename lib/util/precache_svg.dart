import 'package:flutter_svg/svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrecacheSvg {
  static Future<void> loadPictures() async {
    const SvgAssetLoader rasselBannerLoader =
        SvgAssetLoader(AssPath.rasselBanner);
    await svg.cache.putIfAbsent(
      rasselBannerLoader.cacheKey(null),
      () => rasselBannerLoader.loadBytes(null),
    );
  }
}
