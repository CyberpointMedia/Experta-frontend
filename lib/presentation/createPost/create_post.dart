import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/new_post/new_post.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:typed_data';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<AssetPathEntity> _albums = [];
  bool _showVideos = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    if (await Permission.photos.request().isGranted) {
      _loadAlbums();
    } else {
      PhotoManager.openSetting();
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 80.h,
      leading: TextButton(
        onPressed: onTapArrowLeft,
        child: Text(
          "Cancel",
          style: CustomTextStyles.bodyLargeGray90001,
        ),
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Select Albums"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Future<void> _loadAlbums() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: _showVideos ? RequestType.video : RequestType.image,
      onlyAll: false,
    );

    setState(() {
      _albums = albums;
    });
  }

  Future<Uint8List?> _getAlbumThumbnail(AssetPathEntity album) async {
    final List<AssetEntity> mediaFiles = await album.getAssetListPaged(
      page: 0,
      size: 1,
    );
    if (mediaFiles.isNotEmpty) {
      return await mediaFiles.first.thumbnailData;
    }
    return null;
  }

  void _toggleShowVideos() {
    setState(() {
      _showVideos = !_showVideos;
      _loadAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomIconButton(
                          height: 50.adaptSize,
                          width: 50.adaptSize,
                          padding: EdgeInsets.all(15.h),
                          decoration: IconButtonStyleHelper.fillGrayTL22,
                          onTap: () {
                            if (_showVideos) {
                              _toggleShowVideos();
                            }
                          },
                          child: CustomImageView(
                            imagePath: ImageConstant.recents,
                            color: appTheme.black900,
                          )),
                      Text(
                        "Recents",
                        style: CustomTextStyles.bodyMediumBlack90001,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomIconButton(
                          height: 50.adaptSize,
                          width: 50.adaptSize,
                          padding: EdgeInsets.all(15.h),
                          decoration: IconButtonStyleHelper.fillGrayTL22,
                          onTap: () {
                            if (!_showVideos) {
                              _toggleShowVideos();
                            }
                          },
                          child: CustomImageView(
                            imagePath: ImageConstant.videos,
                            color: appTheme.black900,
                          )),
                      Text(
                        "Videos",
                        style: CustomTextStyles.bodyMediumBlack90001,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Albums",
              style: CustomTextStyles.bodyMediumBlack90001,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                ),
                itemCount: _albums.length,
                itemBuilder: (context, index) {
                  final album = _albums[index];
                  return FutureBuilder<Uint8List?>(
                    future: _getAlbumThumbnail(album),
                    builder: (context, snapshot) {
                      final bytes = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewPostPage(album: album),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (bytes != null)
                              Image.memory(
                                bytes,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                width: double.infinity,
                                height: 80,
                                color: Colors.grey,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                album.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            FutureBuilder<int>(
                              future: album.assetCountAsync,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Text(
                                    '${snapshot.data} items',
                                    style: const TextStyle(fontSize: 12),
                                  );
                                } else {
                                  return const Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
