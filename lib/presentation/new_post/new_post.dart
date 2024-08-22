// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/dashboard/dashboard.dart';
import 'package:experta/presentation/new_posting/new_posting.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';

class NewPostPage extends StatefulWidget {
  final AssetPathEntity? album;

  const NewPostPage({this.album, super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  List<AssetEntity> _mediaFiles = [];
  final List<AssetEntity> _selectedFiles = [];
  AssetEntity? _selectedFile;
  bool _isMultiSelectMode = false;
  VideoPlayerController? _videoController;
  String? _currentVideoFile;
  Uint8List? imageData;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadMediaFiles();
  // }

  void _requestPermissions() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      _loadMediaFiles();
    } else {
      // Handle permission denial
      log('Permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void loadAsset() async {
    if (_selectedFiles.isNotEmpty || _selectedFile != null) {
      var file = await (_isMultiSelectMode
          ? _selectedFiles.first.originFile
          : _selectedFile!.originFile);
      if (file != null) {
        var data = await file.readAsBytes();
        setState(() => imageData = data);
      }
    }
  }

  Future<void> _loadMediaFiles() async {
    try {
      AssetPathEntity? album = widget.album;

      if (album == null) {
        List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          type: RequestType.common,
          // onlyAll: true,
        );
        if (albums.isNotEmpty) {
          album = albums.firstWhere(
            (element) => element.name.toLowerCase() == 'recents',
            orElse: () => albums.first,
          );
        }
      }

      if (album != null) {
        List<AssetEntity> mediaFiles = await album.getAssetListPaged(
          page: 0,
          size: 5000,
        );

        setState(() {
          _mediaFiles = mediaFiles;
          _selectedFile = _mediaFiles.isNotEmpty ? _mediaFiles.first : null;
        });
      }
    } catch (e) {
      log('Error loading media files: $e');
    }
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selectedFiles.contains(asset)) {
        _selectedFiles.remove(asset);
      } else {
        _selectedFiles.add(asset);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/captured_image.jpg');
        await tempFile.writeAsBytes(await imageFile.readAsBytes());

        setState(() {
          _selectedFile = null;
          _videoController?.dispose();
          _videoController = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayCapturedImagePage(imageFile: tempFile),
          ),
        );
      }
    } catch (e) {
      log('Error picking image from camera: $e');
    }
  }

  bool get _isVideoSelected => _selectedFile?.type == AssetType.video;

  Widget _buildSelectedMedia() {
    if (_isMultiSelectMode && _selectedFiles.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.4,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
        ),
        items: _selectedFiles.map((asset) {
          return FutureBuilder<Uint8List?>(
            future:
                asset.thumbnailDataWithSize(const ThumbnailSize(1000, 1000)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return asset.type == AssetType.video
                    ? _buildVideoPlayer(asset)
                    : _buildImage(asset, snapshot.data!);
              } else {
                return Container(color: Colors.grey[300]);
              }
            },
          );
        }).toList(),
      );
    } else if (_selectedFile == null) {
      return const Center(child: Text('No media selected'));
    } else {
      return FutureBuilder<Uint8List?>(
        future:
            _selectedFile!.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return _selectedFile!.type == AssetType.video
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: _buildVideoPlayer(_selectedFile!))
                : _buildImage(_selectedFile!, snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  Widget _buildImage(AssetEntity asset, Uint8List imageData) {
    return GestureDetector(
      onTap: () async {
        final file = await asset.file;
        if (file != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayCapturedImagePage(imageFile: file),
            ),
          );
        }
      },
      child: PhotoView(
        imageProvider: MemoryImage(imageData),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }

  Widget _buildVideoPlayer(AssetEntity asset) {
    asset.file.then((file) {
      if (file != null && file.path != _currentVideoFile) {
        _currentVideoFile = file.path;
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            _videoController!.setLooping(true);
            _videoController!.play();
            setState(() {});
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to initialize video player: $error'),
              ),
            );
          });
      }
    });

    return _videoController?.value.isInitialized ?? false
        ? VideoPlayer(_videoController!)
        : const Center(child: CircularProgressIndicator());
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      backgroundColor: appTheme.black900,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.cross,
        imgColor: appTheme.whiteA700,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          Navigator.pop(context);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DashboardPage(),
          //   ),
          //   (Route<dynamic> route) => false,
          // );
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
        text: "New Post",
        textColor: appTheme.whiteA700,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_isVideoSelected) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PostingPage(videoFile: _selectedFile!.file),
                ),
              );
            } else if (_isMultiSelectMode && _selectedFiles.isNotEmpty) {
              // Navigate directly to PostingPage with selected images
              List<Uint8List> selectedImagesData = [];
              for (var asset in _selectedFiles) {
                var file = await asset.originFile;
                if (file != null) {
                  var data = await file.readAsBytes();
                  selectedImagesData.add(data);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PostingPage(imageDataList: selectedImagesData),
                ),
              );
            } else if (_selectedFiles.isNotEmpty || _selectedFile != null) {
              // loadAsset();
              var file = await (_isMultiSelectMode
                  ? _selectedFiles.first.originFile
                  : _selectedFile!.originFile);
              if (file != null) {
                var data = await file.readAsBytes();
                setState(() => imageData = data);
              }
              if (imageData != null) {
                var editedImage = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditor(image: imageData!),
                  ),
                );
                if (editedImage != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostingPage(imageData: editedImage),
                    ),
                  );
                }
              }
            }
          },
          child: Text(
            "Next",
            style: CustomTextStyles.textButton,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.black,
            child: _buildSelectedMedia(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CustomElevatedButton(
                    height: 30,
                    width: 110,
                    text: widget.album?.name.split(' ').first ?? 'Recents',
                    buttonStyle: CustomButtonStyles.none,
                    rightIcon: CustomImageView(
                      imagePath: ImageConstant.imgArrowDown,
                      color: Colors.white,
                    ),
                    buttonTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    onPressed: () {
                      Get.offAndToNamed(AppRoutes.createPost);
                    },
                  ),
                ),
                const Spacer(),
                CustomIconButton(
                  height: 44.adaptSize,
                  width: 44.adaptSize,
                  onTap: _isVideoSelected
                      ? null
                      : () {
                          setState(() {
                            _isMultiSelectMode = !_isMultiSelectMode;
                            if (!_isMultiSelectMode) {
                              _selectedFiles.clear();
                            }
                          });
                        },
                  padding: EdgeInsets.all(10.h),
                  decoration: IconButtonStyleHelper.fillGreenTL24,
                  child: CustomImageView(
                    imagePath: ImageConstant.multiSelect,
                    color:
                        _isMultiSelectMode ? theme.primaryColor : Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CustomIconButton(
                    height: 44.adaptSize,
                    width: 44.adaptSize,
                    onTap: _isVideoSelected ? null : _pickImageFromCamera,
                    padding: EdgeInsets.all(10.h),
                    decoration: IconButtonStyleHelper.fillGreenTL24,
                    child: CustomImageView(
                      imagePath: ImageConstant.camera,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Colors.black,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _mediaFiles.length,
                itemBuilder: (context, index) {
                  final asset = _mediaFiles[index];
                  return FutureBuilder<Uint8List?>(
                    future: asset
                        .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return GestureDetector(
                          onTap: () {
                            if (_isMultiSelectMode) {
                              _toggleSelection(asset);
                            } else {
                              setState(() {
                                _selectedFile = asset;
                                _videoController?.dispose();
                                _videoController = null;
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.memory(snapshot.data!,
                                    fit: BoxFit.cover),
                              ),
                              if (_selectedFiles.contains(asset))
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: theme.primaryColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      } else {
                        return Container(color: Colors.grey[300]);
                      }
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

class DisplayCapturedImagePage extends StatelessWidget {
  final File imageFile;

  const DisplayCapturedImagePage({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
