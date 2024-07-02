import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'controller/recents_controller.dart';

class RecentsPage extends StatelessWidget {
  final RecentsController controller = Get.put(RecentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Images & Videos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.galleryImages.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return GridView.builder(
                  itemCount: controller.galleryImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final image = controller.galleryImages[index];
                    return GestureDetector(
                      onTap: () {
                        Get.back(result: image); // Return selected image to previous page
                      },
                      child: AssetThumbnail(asset: image),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
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
    final thumbnailData = await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));
    if (thumbnailData == null) {
      return Container(color: Colors.grey[300]);
    }
    return Image.memory(
      thumbnailData,
      fit: BoxFit.cover,
    );
  }
}
