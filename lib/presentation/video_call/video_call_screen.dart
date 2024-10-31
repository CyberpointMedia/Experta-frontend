import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String userId;
  final String meetingId;

  const VideoCallScreen({
    super.key,
    required this.userId,
    required this.meetingId,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late IO.Socket socket;
  late Peer peer;
  MediaConnection? mediaConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  bool isMicMuted = false;
  bool isCameraSwitched = false;
  bool showVideo = true;
  bool isMuted = false;
  bool isSpeakerOn = false;
  bool isRecording = false;
  MediaRecorder? _mediaRecorder;
  bool isFrontCamera = true;
  String? remoteUserId;
  bool isSharing = false;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _initializeSignaling();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    localStream?.dispose();
    peer.dispose();
    socket.disconnect();
    super.dispose();
  }

  void _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    setState(() {});
  }

  Future<void> _initializeSignaling() async {
    try {
      await _startLocalStream();
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
        'audio': true,
        'video': {
          'mandatory': {
            'minWidth': '1920',
            'minHeight': '1080',
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
    final config = {
      'iceServers': [
        {
          'urls': [
            'stun:stun.l.google.com:19302',
            'stun:stun2.l.google.com:19302',
            'stun:stun.stunprotocol.org:3478'
          ]
        },
        {
          'urls': 'turn:openrelay.metered.ca:80',
          'username': 'openrelayproject',
          'credential': 'openrelayproject',
        },
      ]
    };

    peer = Peer(
      options: PeerOptions(
        host: 'videoproxy.experta.io',
        port: 443,
        secure: true,
        config: config,
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
      _handleReconnection(); // Handle reconnections when peer disconnects
    });

    peer.on('error').listen((error) {
      log('Peer connection error: $error');
      // Handle any peer connection errors
    });
  }

  void _handleReconnection() {
    log('Attempting to reconnect peer...');
    if (peer.disconnected) {
      peer.reconnect(); // Reconnect if the peer was disconnected
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
      if (peer.id != null) {
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

    socket.on('user-disconnected', (_) {
      log('User disconnected');
      _removeRemoteStream();
    });

    socket.on('error', (error) {
      log('Socket connection error: $error');
      // Handle any socket errors
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
    mediaConnection = peer.call(peerId, localStream!);

    mediaConnection?.on<MediaStream>('stream').listen((remoteStream) {
      log('Remote stream received.');
      setState(() {
        remoteRenderer.srcObject = remoteStream;
        this.remoteStream = remoteStream;
      });
    });
  }

  void _answerCall(MediaConnection call) {
    log('Answering call...');
    call.answer(localStream!);

    call.on<MediaStream>('stream').listen((remoteStream) {
      log('Remote stream received.');
      setState(() {
        remoteRenderer.srcObject = remoteStream;
        this.remoteStream = remoteStream;
      });
    });
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
      // Switch the audio output between speaker and earpiece
      await Helper.setSpeakerphoneOn(speakerOn);
      log(speakerOn ? 'Speaker on' : 'Speaker off');
    } catch (e) {
      _showSnackBar('Failed to set speaker mode: $e');
      log('Failed to set speaker mode: $e');
    }
  }

  Future<void> startScreenShare() async {
    try {
      // Start the foreground service
      const platform =
          MethodChannel('com.example.video_call_testing/screen_capture');
      await platform.invokeMethod('startService');

      MediaStream screenStream;
      if (WebRTC.platformIsWeb) {
        screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': true,
        });
      } else {
        screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': {'mediaSource': 'screen'},
          'audio': true
        });
      }

      if (localStream != null && mediaConnection != null) {
        mediaConnection!.addStream(screenStream);
        localRenderer.srcObject = screenStream;
      } else {
        throw Exception("PeerConnection or LocalStream is not initialized.");
      }
    } catch (e) {
      _showSnackBar('Failed to start screen sharing: $e');
      log("Error starting screen share: $e");
    }
  }

  Future<void> stopScreenShare() async {
    if (isSharing) {
      // Stop sharing and switch back to the local video stream
      localStream?.getVideoTracks().forEach((track) {
        track.enabled = true; // Re-enable local video
      });
      isSharing = false;
      setState(() {
        // Update UI if necessary
      });
    }
  }

  Future<void> startScreenRecording() async {
    _mediaRecorder ??= MediaRecorder();

    // Check if we are already recording
    if (!isRecording) {
      // Get a valid file path to save the video
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/screen_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Extract video and audio tracks
      MediaStreamTrack? videoTrack;
      RecorderAudioChannel? audioChannel;

      if (localStream != null) {
        videoTrack = localStream!.getVideoTracks().isNotEmpty
            ? localStream!.getVideoTracks().first
            : null;
        audioChannel = RecorderAudioChannel.INPUT;
      }

      try {
        await _mediaRecorder?.start(
          filePath,
          videoTrack: videoTrack,
          audioChannel: audioChannel,
        );
        log('Recording started, saving to: $filePath');
      } catch (e) {
        _showSnackBar('Failed to start recording: $e');
        log('Failed to start recording: $e');
      }
    } else {
      // Stop the recording and save the file
      try {
        await _mediaRecorder?.stop();
        log('Recording stopped');
      } catch (e) {
        _showSnackBar('Failed to stop recording: $e');
        log('Failed to stop recording: $e');
      }
    }

    setState(() {
      isRecording = !isRecording; // Toggle the recording state
    });
  }

  void _removeRemoteStream() {
    log('Removing remote stream...');
    setState(() {
      remoteRenderer.srcObject = null;
      remoteStream?.dispose();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void endCall() {
    socket.close();
    peer.close();
    localRenderer.dispose();
    localStream!.dispose();
    _removeRemoteStream();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Video Call',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          IconButton(
              onPressed: switchCam,
              icon: Image.asset(
                height: 30,
                "assets/images/camera.png",
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: remoteRenderer.srcObject == null
                      ? const Center(
                          child: Text("Waiting for remote user...",
                              style: TextStyle(color: Colors.white)))
                      : (remoteStream!.getVideoTracks().isEmpty)
                          ? Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[700],
                                child: Text(
                                  remoteUserId != null ? remoteUserId![0] : '',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : RTCVideoView(remoteRenderer),
                ),
                Positioned(
                  top: 0.02 * screenHeight,
                  right: 0.03 * screenWidth,
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B4043),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: localRenderer.srcObject == null ||
                                (localStream?.getVideoTracks().isEmpty ??
                                    true) ||
                                !showVideo
                            ? Center(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[700],
                                  child: Text(
                                    widget.userId[0],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : RTCVideoView(
                                localRenderer,
                                mirror: isFrontCamera,
                                objectFit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                              )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red, size: 32),
                  onPressed: endCall,
                ),
                IconButton(
                  icon: Icon(isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white, size: 32),
                  onPressed: toggleAudio,
                ),
                IconButton(
                  icon: Icon(showVideo ? Icons.videocam : Icons.videocam_off,
                      color: Colors.white, size: 32),
                  onPressed: toggleVideo,
                ),
                IconButton(
                  icon: Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: Colors.white,
                      size: 32),
                  onPressed: startScreenRecording,
                ),
                IconButton(
                  icon: Icon(isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white, size: 32),
                  onPressed: toggleSpeaker,
                ),
                IconButton(
                  icon: Icon(
                      !isSharing ? Icons.screen_share : Icons.stop_screen_share,
                      color: Colors.white,
                      size: 32),
                  onPressed: toggleScreenShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
