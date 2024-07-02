import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class RecentsController extends GetxController {
  var galleryImages = <AssetEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentAssets();
  }

  void loadRecentAssets() async {
    final recentAssets = await PhotoManager.getAssetPathList(
      type: RequestType.common, // Fetch both images and videos
      hasAll: true,
    );
    if (recentAssets.isNotEmpty) {
      final recentAssetPath = recentAssets.first;
      final recentAssetsList = await recentAssetPath.getAssetListRange(
        start: 0,
        end: 100, // Adjust as per your requirement
      );
      galleryImages.assignAll(recentAssetsList);
    }
  }
}
