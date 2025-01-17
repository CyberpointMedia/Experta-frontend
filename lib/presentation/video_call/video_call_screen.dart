import 'dart:async';
import 'dart:developer';
import 'package:experta/core/app_export.dart' hide navigator;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:experta/presentation/give_rating/give_rating.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';
import 'package:http/http.dart' as http;

class VideoCallScreen extends StatefulWidget {
  final String userId;
  final String meetingId;
  final String userName;
  final String bookingId;
  final String profilePic;

  const VideoCallScreen({
    super.key,
    required this.userId,
    required this.meetingId,
    required this.userName,
    required this.bookingId,
    required this.profilePic,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final RTCVideoRenderer screenRenderer = RTCVideoRenderer();
  static const platform = MethodChannel('com.example.expert/screen_recording');
  final MethodChannel _methodChannel =
      MethodChannel('com.example.expert/screen_recording');

  late IO.Socket socket;
  late Peer peer;
  MediaConnection? mediaConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  bool isMicMuted = false;
  bool isCameraSwitched = false;
  bool showVideo = true;
  bool isMuted = false;
  bool isSpeakerOn = true;
  bool isRecording = false;
  bool isFrontCamera = true;
  String? remoteUserId;
  bool isSharing = false;
  Timer? callTimer;
  int callDuration = 0;
  bool isConnectionActive = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _initializeSignaling();
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == "saveRecordingPath") {
      final String filePath = call.arguments;
      log('Received recording path: $filePath');
      if (filePath != null) {
        await _uploadRecording(filePath);
      } else {
        log('Error: Received null file path from platform.');
        _showSnackBar('Failed to save recording: Received null file path');
      }
    }
  }

  @override
  void dispose() {
    isConnectionActive = false;
    mediaConnection?.close();
    stopCallTimer();
    localStream?.getTracks().forEach((track) => track.stop());
    localStream?.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    screenRenderer.dispose();
    peer.dispose();
    socket.disconnect();
    super.dispose();
  }

  void _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    await screenRenderer.initialize();
    setState(() {});
  }

  void startCallTimer() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          callDuration++;
        });
      }
    });
  }

  void stopCallTimer() {
    callTimer?.cancel();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => RatingPage(
                  bookingId: widget.bookingId,
                  userName: widget.userName,
                  profilePic: widget.profilePic,
                )));
  }

  String formatDuration(int duration) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _initializeSignaling() async {
    try {
      await _startLocalStream();
      if (localStream == null) {
        throw Exception('Failed to initialize local stream');
      }
      _setupPeerConnection();
      _connectSocket();
    } catch (e) {
      _showSnackBar('Error initializing signaling: $e');
      log('Error initializing signaling: $e');
    }
  }

  Future<void> _startLocalStream() async {
    try {
      log('Starting local stream...');
      final mediaConstraints = {
        'audio': {
          'mandatory': [],
          'optional': [
            {'googNoiseSuppression': true},
            {'googEchoCancellation': true},
            {'echoCancellation': true},
            {'googEchoCancellation2': true},
            {'googDAEchoCancellation': true},
          ],
        },
        'video': {
          'mandatory': {
            'minWidth': '1280',
            'minHeight': '720',
            'maxWidth': '1920',
            'maxHeight': '1080',
            'minFrameRate': '30',
            'maxFrameRate': '60'
          },
          'facingMode': isFrontCamera ? 'user' : 'environment',
        },
      };

      localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      if (localStream != null) {
        localRenderer.srcObject = localStream;
      } else {
        log('Error: Local stream is null');
      }
    } catch (e) {
      _showSnackBar('Failed to start local stream: $e');
      log('Failed to start local stream: $e');
    }
  }

  void _setupPeerConnection() {
    final Map<String, dynamic> config = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
            'stun:stun3.l.google.com:19302',
            'stun:stun4.l.google.com:19302',
          ],
        },
        {
          'urls': [
            'turn:turn.experta.io:3478?transport=udp',
            'turn:turn.experta.io:3478?transport=tcp',
            'turns:turn.experta.io:5349?transport=tcp'
          ],
          'username': 'admin',
          'credential': 'experta',
          'credentialType': 'password'
        }
      ],
      'sdpSemantics': 'unified-plan',
      'iceTransportPolicy': 'all',
      'bundlePolicy': 'max-bundle',
      'rtcpMuxPolicy': 'require',
      'iceCandidatePoolSize': 1,
      'enableDtlsSrtp': true,
      'enableRtpDataChannels': false,
      'sdpConstraints': {
        'mandatory': {
          'OfferToReceiveAudio': true,
          'OfferToReceiveVideo': true,
        },
      },
    };

    peer = Peer(
      options: PeerOptions(
        host: 'videoproxy.experta.io',
        port: 443,
        secure: true,
        config: config,
        debug: LogLevel.All,
      ),
    );

    peer.on('open').listen((id) {
      log('Peer connection opened with ID: $id');
      _joinMeeting();
    });

    peer.on<MediaConnection>('call').listen((call) {
      log('Incoming call...');
      _answerCall(call);
    });

    peer.on('disconnected').listen((_) {
      log('Peer connection disconnected.');
      _handleReconnection();
    });

    peer.on('error').listen((error) {
      log('Peer connection error: $error');
      _showSnackBar('Peer connection error: $error');
    });
  }

  void _handleReconnection() {
    log('Attempting to reconnect peer...');
    if (peer.destroyed && peer.disconnected) {
      peer.reconnect();
    }
  }

  void _connectSocket() {
    log('Connecting to signaling server...');
    socket = IO.io('wss://video.experta.io', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    socket.on('connect', (_) {
      log('Connected to signaling server.');
      if (peer.id != null && widget.userId.isNotEmpty) {
        _joinMeeting();
      } else {
        log('Error: peerId or userId is null');
      }
    });

    socket.on('user-connected', (data) {
      log('User connected: $data');
      remoteUserId = data['userId'];
      if (data['peerId'] != null) {
        _makeCall(data['peerId']);
      } else {
        log('Error: peerId is null for connected user.');
      }
    });

    socket.on('user-disconnected', (data) {
      log('User disconnected');
      if (mounted) {
        setState(() {
          remoteStream?.getTracks().forEach((track) => track.stop());
          remoteStream?.dispose();
          remoteStream = null;
          remoteRenderer.srcObject = null;
          stopCallTimer();
          mediaConnection?.close();
          mediaConnection = null;
        });
        Navigator.of(context).pop();
      }
    });

    socket.on('error', (error) {
      log('Socket connection error: $error');
      _showSnackBar('Socket connection error: $error');
    });
  }

  Future<void> _joinMeeting() async {
    log('Joining meeting...');
    socket.emit('join-room', {
      'roomId': widget.meetingId,
      'peerId': peer.id,
      'userId': widget.userId,
    });
  }

  void _makeCall(String peerId) {
    log('Making a call to $peerId');
    try {
      if (localStream == null) {
        throw Exception('Local stream is not initialized');
      }

      mediaConnection?.close();
      mediaConnection = null;

      mediaConnection = peer.call(peerId, localStream!);
      isConnectionActive = true;

      mediaConnection?.on<MediaStream>('stream').listen(
        (stream) {
          if (!mounted || !isConnectionActive) return;

          setState(() {
            remoteStream = stream;
            remoteRenderer.srcObject = stream;
            startCallTimer();
          });
        },
        onError: (error) {
          log('Media stream error: $error');
          _showSnackBar('Stream error: $error');
        },
        cancelOnError: false,
      );
    } catch (e) {
      log('Error making call: $e');
      _showSnackBar('Failed to make call: $e');
    }
  }

  void _answerCall(MediaConnection call) {
    log('Answering call...');
    try {
      if (localStream == null) {
        log('Error: Local stream is null');
        throw Exception('Local stream is not initialized');
      }

      call.answer(localStream!);
      log('Call answered with local stream');

      call.on<MediaStream>('stream').listen((stream) {
        log('Remote stream received in answer');
        if (!mounted) return;

        setState(() {
          remoteStream = stream;
          remoteRenderer.srcObject = stream;
          startCallTimer();
        });
      });

      call.on('track').listen((event) {
        log('New track received: ${event.track.kind}');
        if (event.track.kind == 'video') {
          setState(() {
            if (event.streams.isNotEmpty) {
              if (event.track.id.contains('screen')) {
                screenRenderer.srcObject = event.streams[0];
                isSharing = true;
              } else {
                remoteRenderer.srcObject = event.streams[0];
              }
            }
          });
        }
      });

      call.on('error').listen((error) {
        log('Call answer error: $error');
        _showSnackBar('Call answer error: $error');
      });

      mediaConnection = call;
    } catch (e) {
      log('Error answering call: $e');
      _showSnackBar('Failed to answer call: $e');
    }
  }

  void toggleVideo() {
    setState(() {
      showVideo = !showVideo;
      if (localStream?.getVideoTracks().isNotEmpty ?? false) {
        localStream?.getVideoTracks().first.enabled = showVideo;
      }
    });
  }

  void toggleAudio() {
    setState(() {
      isMuted = !isMuted;
      localStream?.getAudioTracks().first.enabled = !isMuted;
    });
  }

  void toggleSpeaker() async {
    isSpeakerOn = !isSpeakerOn;
    await _setSpeakerMode(isSpeakerOn);
  }

  void switchCam() {
    if (localStream != null) {
      final videoTrack = localStream!.getVideoTracks().first;
      Helper.switchCamera(videoTrack);
      setState(() {
        isFrontCamera = !isFrontCamera;
      });
    }
  }

  Future<void> _setSpeakerMode(bool speakerOn) async {
    try {
      await Helper.setSpeakerphoneOn(speakerOn);
      log(speakerOn ? 'Speaker on' : 'Speaker off');
    } catch (e) {
      _showSnackBar('Failed to set speaker mode: $e');
      log('Failed to set speaker mode: $e');
    }
  }

  Future<void> _startForegroundService() async {
    if (Platform.isAndroid) {
      var methodChannel =
          MethodChannel('com.example.expert/foreground_service');
      try {
        await methodChannel.invokeMethod('startForegroundService');
      } catch (e) {
        log('Failed to start foreground service: $e');
        _showSnackBar('Failed to start foreground service: $e');
      }
    }
  }

  Future<void> startScreenShare() async {
    if (!isConnectionActive) return;

    try {
      log('Starting screen share...');
      await _startForegroundService();

      MediaStream? screenStream;
      if (Platform.isAndroid) {
        screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': {
            'mandatory': {
              'minWidth': 1280,
              'minHeight': 720,
              'maxWidth': 1920,
              'maxHeight': 1080,
              'minFrameRate': 30,
              'maxFrameRate': 60
            },
            'facingMode': 'user',
          },
          'audio': false,
        });
      } else if (Platform.isIOS) {
        screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': {
            'mandatory': {
              'minWidth': '1280',
              'minHeight': '720',
              'maxWidth': '1920',
              'maxHeight': '1080',
              'minFrameRate': '30',
              'maxFrameRate': '60'
            },
            'facingMode': 'user',
          },
          'audio': false,
        });
      }

      if (mediaConnection != null &&
          screenStream != null &&
          screenStream.getVideoTracks().isNotEmpty) {
        final screenTrack = screenStream.getVideoTracks().first;
        final senders = await mediaConnection!.peerConnection?.getSenders();
        if (senders != null) {
          for (var sender in senders) {
            if (sender.track?.kind == 'video') {
              await sender.replaceTrack(screenTrack);
            }
          }
        }

        screenTrack.onEnded = () {
          stopScreenShare();
        };

        setState(() {
          screenRenderer.srcObject = screenStream;
          isSharing = true;
        });

        if (mediaConnection?.peerConnection != null) {
          final offer = await mediaConnection!.peerConnection!.createOffer({
            'offerToReceiveVideo': 1,
            'offerToReceiveAudio': 1,
          });
          await mediaConnection!.peerConnection!.setLocalDescription(offer);
        }
      }
    } catch (e) {
      isSharing = false;
      _showSnackBar('Screen sharing failed: $e');
      log("Screen share error: $e");
    }
  }

  Future<void> stopScreenShare() async {
    if (!isSharing) return;

    try {
      final senders = await mediaConnection!.peerConnection?.getSenders();
      if (senders != null) {
        for (var sender in senders) {
          if (sender.track?.kind == 'video') {
            await sender.replaceTrack(localStream?.getVideoTracks().first);
          }
        }
      }

      screenRenderer.srcObject = null;
      setState(() {
        isSharing = false;
      });
      if (mediaConnection?.peerConnection != null) {
        final offer = await mediaConnection!.peerConnection!.createOffer({
          'offerToReceiveVideo': 1,
          'offerToReceiveAudio': 1,
        });
        await mediaConnection!.peerConnection!.setLocalDescription(offer);
      }
    } catch (e) {
      log("Error stopping screen share: $e");
    }
  }

  Future<void> startScreenRecording() async {
    if (isRecording) return;

    try {
      await platform.invokeMethod('startScreenCapture');
      setState(() {
        isRecording = true;
      });
      _showSnackBar('Recording started');
    } catch (e) {
      _showSnackBar('Failed to start recording: $e');
    }
  }

  Future<void> stopScreenRecording() async {
    if (!isRecording) return;

    try {
      await platform
          .invokeMethod('stopScreenCapture'); // This stops the service.
      setState(() {
        isRecording = false;
      });
      _showSnackBar('Recording stopped. Waiting for file path...');
      // Don't try to access filePath here, wait for _handleMethodCall.
    } catch (e) {
      _showSnackBar('Failed to stop recording: $e');
    }
  }

  Future<void> _uploadRecording(String filePath) async {
    final url = Uri.parse('http://3.110.252.174:8080/api/uploadRecordingVideo');
    final token = PrefUtils().getToken();

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token';

    // Modify the file path to use the correct one from the cache
    File fileToUpload = File(filePath);

    request.files.add(
      http.MultipartFile(
        'file',
        fileToUpload.readAsBytes().asStream(),
        fileToUpload.lengthSync(),
        filename: path.basename(fileToUpload.path),
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        _showSnackBar('Recording uploaded successfully');
        log('Recording uploaded successfully');

        // Clear the video file from the cache after successful upload
        try {
          await platform.invokeMethod('clearVideoFileFromCache');
          log('Video file cleared from cache.');
        } catch (e) {
          log('Failed to clear video file from cache: $e');
        }
      } else {
        _showSnackBar('Failed to upload recording: ${response.statusCode}');
        log('Failed to upload recording: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error uploading recording: $e');
      log('Error uploading recording: $e');
    }
  }

  Future<void> _saveRecordingMetadata(String recordingId, String status,
      {int? duration, String? filePath}) async {
    try {
      final box = await Hive.openBox('recordings');
      String? savedPath;
      if (filePath != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(filePath);
        final newPath = path.join(appDir.path, 'recordings', fileName);

        final recordingsDir = Directory(path.dirname(newPath));
        if (!await recordingsDir.exists()) {
          await recordingsDir.create(recursive: true);
        }
        await File(filePath).copy(newPath);
        savedPath = newPath;
      }

      final recording = {
        'id': recordingId,
        'meetingId': widget.meetingId,
        'userId': widget.userId,
        'userName': widget.userName,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
        'duration': duration,
        'filePath': savedPath,
        'participants': [
          {
            'id': widget.userId,
            'name': widget.userName,
          },
          if (remoteUserId != null)
            {
              'id': remoteUserId,
              'name': widget.userName,
            }
        ],
      };

      await box.put(recordingId, recording);
      log('Recording metadata saved successfully: $recordingId');
    } catch (e) {
      log('Failed to save recording metadata: $e');
      throw Exception('Failed to save recording metadata: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    log(message);
  }

  void endCall() {
    log('Ending call...');
    stopCallTimer();
    remoteStream?.getTracks().forEach((track) => track.stop());
    localStream?.getTracks().forEach((track) => track.stop());
    mediaConnection?.close();
    if (mounted) {
      setState(() {
        remoteRenderer.srcObject = null;
        localRenderer.srcObject = null;
      });
    }
    remoteStream?.dispose();
    localStream?.dispose();
    socket.disconnect();
    peer.dispose();
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      backgroundColor: Colors.transparent,
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        imgColor: Colors.white,
        onTap: endCall,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
        text: 'End-to-end Encrypted',
        textColor: Colors.white,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomImageView(
            imagePath: ImageConstant.camera,
            onTap: switchCam,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildMainVideoContainer(),
                if (isSharing) _buildScreenSharingIndicator(),
                if (!isSharing) _buildPiPViewPositioned(),
              ],
            ),
          ),
          _buildControlBar(),
        ],
      ),
    );
  }

  Widget _buildMainVideoContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: isSharing ? _buildScreenShareLayout() : _buildNormalCallLayout(),
      ),
    );
  }

  Widget _buildScreenSharingIndicator() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.screen_share, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Screen sharing active',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPiPViewPositioned() {
    return Positioned(
      top: 0.02 * MediaQuery.of(context).size.height,
      right: 0.03 * MediaQuery.of(context).size.width,
      child: _buildPiPView(),
    );
  }

  Widget _buildScreenShareLayout() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.white24)),
            child: screenRenderer.srcObject != null
                ? RTCVideoView(screenRenderer,
                    objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black54,
            child: Row(
              children: [
                _buildVideoContainer(localRenderer, isFrontCamera, 'You', null),
                _buildVideoContainer(
                    remoteRenderer, false, widget.userName, widget.profilePic),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoContainer(
      RTCVideoRenderer renderer, bool mirror, String name, String? imagePath) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: renderer.srcObject != null
              ? RTCVideoView(renderer,
                  mirror: mirror,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
              : _buildParticipantTile(
                  isLocal: name == 'You', name: name, imagePath: imagePath),
        ),
      ),
    );
  }

  Widget _buildParticipantTile(
      {required bool isLocal, required String name, String? imagePath}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: imagePath != null ? NetworkImage(imagePath) : null,
            child: imagePath == null ? Text(name[0]) : null,
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(isLocal ? 'You' : 'Remote',
              style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildNormalCallLayout() {
    return remoteRenderer.srcObject == null
        ? _buildWaitingView()
        : RTCVideoView(remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover);
  }

  Widget _buildWaitingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[700],
            child: Text(widget.userName[0],
                style: const TextStyle(fontSize: 40, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Text("Waiting for ${widget.userName}...",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPiPView() {
    return GestureDetector(
      onTap: () {
        // Toggle PiP size or position if needed
      },
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF3B4043),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: localRenderer.srcObject == null ||
                  (localStream?.getVideoTracks().isEmpty ?? true) ||
                  !showVideo
              ? _buildLocalAvatarView()
              : RTCVideoView(localRenderer,
                  mirror: isFrontCamera,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
        ),
      ),
    );
  }

  Widget _buildLocalAvatarView() {
    return Center(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[700],
        child: Text(widget.userId[0],
            style: const TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
              icon: Icons.call_end, color: Colors.red, onPressed: endCall),
          _buildControlButton(
              icon: isMuted ? Icons.mic_off : Icons.mic,
              onPressed: toggleAudio),
          _buildControlButton(
              icon: showVideo ? Icons.videocam : Icons.videocam_off,
              onPressed: toggleVideo),
          _buildControlButton(
              icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
              onPressed: toggleScreenRecording),
          _buildControlButton(
              icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
              onPressed: toggleSpeaker),
          _buildControlButton(
              icon: !isSharing ? Icons.screen_share : Icons.stop_screen_share,
              onPressed: toggleScreenShare),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      {required IconData icon,
      Color color = Colors.white,
      required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
      child: IconButton(
          icon: Icon(icon, color: color, size: 32), onPressed: onPressed),
    );
  }

  void toggleScreenRecording() {
    if (isRecording) {
      stopScreenRecording();
    } else {
      startScreenRecording();
    }
  }

  void toggleScreenShare() {
    if (isSharing) {
      stopScreenShare();
    } else {
      startScreenShare();
    }
    setState(() {
      isSharing = !isSharing;
    });
  }
}
