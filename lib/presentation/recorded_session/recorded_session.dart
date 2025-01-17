import 'dart:io';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class RecordedSessionsPage extends StatefulWidget {
  const RecordedSessionsPage({super.key});

  @override
  State<RecordedSessionsPage> createState() => _RecordedSessionsPageState();
}

class _RecordedSessionsPageState extends State<RecordedSessionsPage> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 60,
                sigmaY: 60,
              ),
              child: Align(
                child: SizedBox(
                  width: 252,
                  height: 252,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: const Color(0xFFFF7514).withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              Expanded(child: _buildRecordedSessionsList()),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text("Recorded Sessions"),
    );
  }

  Widget _buildRecordedSessionsList() {
    return ListView.builder(
      itemCount: sessions.length,
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecordedSessionTile(
            session: sessions[index],
          ),
        );
      },
    );
  }
}

class RecordedSessionTile extends StatelessWidget {
  final Map<String, dynamic> session;

  const RecordedSessionTile({
    required this.session,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (session['path'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    videoPath: session['path'],
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Video path is not available')),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300],
                width: 150,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CustomImageView(
                    imagePath: ImageConstant.imageNotFound,
                    width: 50,
                    height: 50,
                    color: Colors.grey[500],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white.withOpacity(0.7),
                    size: 40.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session['name'] ?? 'Unknown Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Delete') {}
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            height: 30,
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      padding: const EdgeInsets.all(4),
                      offset: const Offset(0, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2.0,
                    ),
                  ),
                ],
              ),
              Text(
                session['title'] ?? 'Unknown Title',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['date'] ?? 'Unknown Date',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    session['time'] ?? 'Unknown Time',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({super.key, required this.videoPath});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false; 

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); 
        _enterFullScreen(); 
      });
  }

  @override
  void dispose() {
    _exitFullScreen(); 
    _controller.dispose();
    super.dispose();
  }
  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).then((_) {
      setState(() {
        _isFullScreen = true;
      });
    });
  }
  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      setState(() {
        _isFullScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _isFullScreen ? _exitFullScreen() : _enterFullScreen();
        },
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
