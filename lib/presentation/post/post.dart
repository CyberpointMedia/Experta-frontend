import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:experta/routes/app_routes.dart';
import 'package:experta/presentation/post/controller/post_controller.dart';

class PostPage extends StatelessWidget {
  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Handle 'Next' button functionality here
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display selected image or placeholder
          Obx(() {
            if (controller.selectedImage.value != null) {
              return SizedBox(
                height: 300,
                width: double.infinity,
                child: AssetThumbnail(asset: controller.selectedImage.value!),
              );
            } else if (controller.selectedCameraImage.value != null) {
              return SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.file(
                  controller.selectedCameraImage.value!,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return Container(
                height: 300,
                color: Colors.grey[300],
                child: const Center(child: Text('No Image Selected')),
              );
            }
          }),
          // Row for "Recents" button and dropdown button, camera, and multi-selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left section (Recents button and dropdown)
                Obx(() {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showFolderSelection(context);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Recent",
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_drop_down, color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                // Right section (Camera button and multi-selection toggle)
                Row(
                  children: [
                    Obx(() {
                      return IconButton(
                        icon: Icon(
                          controller.allowMultipleSelection.value
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.black,
                        ),
                        onPressed: () => controller.toggleMultiSelection(),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.black),
                      onPressed: () => _pickImageFromCamera(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grid view of gallery images
          Expanded(
            child: Obx(() {
              return GridView.builder(
                itemCount: controller.galleryImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final image = controller.galleryImages[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to AppRoutes.recent or other route as needed
                      Get.toNamed(AppRoutes.recent); // Example navigation
                      if (controller.allowMultipleSelection.value) {
                        if (controller.selectedImages.contains(image)) {
                          controller.selectedImages.remove(image);
                        } else {
                          controller.selectedImages.add(image);
                        }
                      } else {
                        controller.onSelectImage(image);
                      }
                    },
                    child: Stack(
                      children: [
                        AssetThumbnail(asset: image),
                        if (controller.allowMultipleSelection.value &&
                            controller.selectedImages.contains(image))
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFolderSelection(BuildContext context) {
    // Your modal bottom sheet code to show album list
  }

  void _pickImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      controller.onSelectCameraImage(File(pickedFile.path));
    }
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadThumbnail(),
      builder: (context, snapshot) {
        final Widget? thumbnail = snapshot.data;
        if (thumbnail == null) {
          return Container(
            color: const Color.fromARGB(255, 224, 224, 224),
          );
        }
        return thumbnail;
      },
    );
  }

  Future<Widget> _loadThumbnail() async {
    final thumbnailData =
        await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
    if (thumbnailData == null) {
      return Container(color: Colors.grey[300]);
    }
    return Image.memory(
      thumbnailData,
      fit: BoxFit.cover,
    );
  }
}
