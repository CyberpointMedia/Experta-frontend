import 'dart:io';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class PostController extends GetxController {
  var selectedImage = Rxn<AssetEntity>(); // For gallery images
  var selectedCameraImage = Rxn<File>();  // For camera images

  var selectedFolder = ''.obs;
  var albums = <AssetPathEntity>[].obs;
  var galleryImages = <AssetEntity>[].obs;
  var selectedImages = <AssetEntity>[].obs;
  var allowMultipleSelection = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAlbums();
  }

  void loadAlbums() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final fetchedAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );
      albums.value = fetchedAlbums;
      if (albums.isNotEmpty) {
        changeSelectedFolder(albums.first.id);
      }
    } else {
      // Handle permission denied
      PhotoManager.openSetting();
    }
  }

  void changeSelectedFolder(String folderId) async {
    selectedFolder.value = folderId;
    if (folderId.isNotEmpty) {
      final selectedAlbum = albums.firstWhere((album) => album.id == folderId);
      // Fix: Added the required 'page' parameter
      galleryImages.value = await selectedAlbum.getAssetListPaged(page: 0, size: 100);
    }
  }

  void onSelectImage(AssetEntity image) {
    selectedImage.value = image;
    selectedCameraImage.value = null; // Clear camera image selection
  }

  void onSelectCameraImage(File image) {
    selectedCameraImage.value = image;
    selectedImage.value = null; // Clear gallery image selection
  }

  void toggleMultiSelection() {
    allowMultipleSelection.value = !allowMultipleSelection.value;
    selectedImages.clear();
  }
}
