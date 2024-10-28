// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/new_post/controller/new_post_controller.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class PostingPage extends StatefulWidget {
  final List<Uint8List>? imageDataList;
  final Uint8List? imageData;
  final Future<File?>? videoFile;

  const PostingPage(
      {this.imageDataList, this.imageData, this.videoFile, super.key});

  @override
  State<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final NewPostController _controller = Get.put(NewPostController());
  final TextEditingController _captionController = TextEditingController();
  List<String> selectedLocations = [];
  VideoPlayerController? _videoController;
  String? _currentVideoFile;
  final String? basic = PrefUtils().getbasic();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            _buildBackgroundBlur(),
            Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10.0),
                            if (widget.imageDataList != null &&
                                widget.imageDataList!.isNotEmpty)
                              Expanded(
                                child: SizedBox(
                                  height: 100,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing: 1.0,
                                      mainAxisSpacing: 1.0,
                                    ),
                                    itemCount: widget.imageDataList!.length,
                                    itemBuilder: (context, index) {
                                      return Image.memory(
                                        widget.imageDataList![index],
                                      );
                                    },
                                  ),
                                ),
                              )
                            else if (widget.imageData != null &&
                                widget.imageData!.isNotEmpty)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Image.memory(
                                  widget.imageData!,
                                  width: 50,
                                  height: 50,
                                ),
                              )
                            else
                              FutureBuilder<File?>(
                                future: widget.videoFile,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data != null) {
                                    return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child:
                                            _buildVideoPlayer(snapshot.data!));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextField(
                                controller: _captionController,
                                decoration: const InputDecoration(
                                  hintText: 'What\'s on your mind?',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              "Add Location",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationSearchPage(
                                      onLocationSelected: (location) {
                                        setState(() {
                                          selectedLocations.add(location);
                                          print('Location added: $location');
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Add',
                                style: CustomTextStyles.textButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          children: selectedLocations
                              .map((location) => Chip(
                                    label: Text(
                                      location,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        selectedLocations.remove(location);
                                        print('Location removed: $location');
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_controller.isLoading.value)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildVideoPlayer(File file) {
    if (_currentVideoFile != file.path) {
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

    return _videoController?.value.isInitialized ?? false
        ? VideoPlayer(_videoController!)
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter:
            ImageFilter.blur(tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
        child: Align(
          child: SizedBox(
            width: 252,
            height: 252,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(126),
                color: Colors.deepOrange.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40,
      leadingWidth: 40,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              _createPost();
            },
            child: Text(
              "Share",
              style: CustomTextStyles.textButton,
            ))
      ],
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Create Post"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Future<void> _createPost() async {
    final caption = _captionController.text;
    final location =
        selectedLocations.isNotEmpty ? selectedLocations.first : '';
    String basicInfoId = basic.toString();

    File? videoFile;
    if (widget.videoFile != null) {
      videoFile = await widget.videoFile;
    }

    _controller.createPost(
      imageDataList: widget.imageDataList,
      imageData: widget.imageData,
      videoFile: videoFile,
      caption: caption,
      location: location,
      basicInfoId: basicInfoId,
      context: context,
    );
  }
}

class LocationSearchPage extends StatefulWidget {
  final Function(String) onLocationSelected;

  const LocationSearchPage({required this.onLocationSelected, super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  List<Map<String, dynamic>> _places = [];

  Future<void> _searchLocations(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1'));
      if (response.statusCode == 200) {
        setState(() {
          _places = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request location permissions
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final response = await http.get(Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&addressdetails=1'));
        if (response.statusCode == 200) {
          setState(() {
            _places = [json.decode(response.body)];
          });
        } else {
          print('Error: ${response.reasonPhrase}');
        }
      } else if (status.isDenied) {
        print('Location permission denied');
        // Optionally, you can show a dialog to the user explaining why the permission is needed
      } else if (status.isPermanentlyDenied) {
        print('Location permission permanently denied');
        // Optionally, you can open the app settings so the user can grant the permission
        openAppSettings();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for locations',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {});
                          _searchLocations(value);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _places.length,
                          itemBuilder: (context, index) {
                            final place = _places[index];
                            final displayName = place['display_name'] ?? '';

                            return ListTile(
                              title: Text(displayName),
                              onTap: () {
                                log("Selected place: $displayName");
                                widget.onLocationSelected(displayName);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter:
            ImageFilter.blur(tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
        child: Align(
          child: SizedBox(
            width: 252,
            height: 252,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(126),
                color: Colors.deepOrange.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40,
      leadingWidth: 40,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Search Location"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
