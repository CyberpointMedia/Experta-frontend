import 'dart:async';
import 'dart:developer';
import 'package:experta/core/utils/size_utils.dart';
import 'package:experta/presentation/give_rating/give_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/pref_utils.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_six.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';

class VideoCallScreen extends StatefulWidget {
  final String userId;
  final String meetingId;
  final String userName;

  const VideoCallScreen({
    super.key,
    required this.userId,
    required this.meetingId,
    required this.userName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? imagePath = PrefUtils().getProfileImage();
  String? name = PrefUtils().getProfileName();
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
  Timer? callTimer;
  int callDuration = 0;

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
    callTimer?.cancel();
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

  // Start call timer
  void startCallTimer() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        callDuration++;
      });
    });
  }

  // Format duration as MM:SS
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
    final Map<String, dynamic> config = {
      'iceServers': [
        {
          'urls': 'stun:stun.l.google.com:19302',
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
      'iceCandidatePoolSize': 1
    };

    peer = Peer(
      options: PeerOptions(
        host: 'videoproxy.experta.io',
        port: 443,
        secure: true,
        config: config,
        debug: LogLevel.All,
        // constraints: {
        //   'mandatory': {
        //     'OfferToReceiveAudio': true,
        //     'OfferToReceiveVideo': true,
        //   },
        //   'optional': []
        // },
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
    });
  }

  void _handleReconnection() {
    log('Attempting to reconnect peer...');
    if (peer != null && peer.disconnected) {
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
      if (peer.id != null && widget.userId != null) {
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
          // Clear remote stream
          remoteStream?.getTracks().forEach((track) => track.stop());
          remoteStream?.dispose();
          remoteStream = null;
          remoteRenderer.srcObject = null;

          // Stop timer
          callTimer?.cancel();

          // Close media connection
          if (mediaConnection != null) {
            mediaConnection!.close();
            mediaConnection = null;
          }
        });

        // Navigate back
        Navigator.of(context).pop();
      }
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
    try {
      if (localStream == null) {
        throw Exception('Local stream is not initialized');
      }

      // Create media connection with local stream
      mediaConnection = peer.call(peerId, localStream!);

      if (mediaConnection == null) {
        throw Exception('Failed to create media connection');
      }

      // Handle remote stream
      mediaConnection?.on<MediaStream>('stream').listen((stream) {
        log('Remote stream received.');
        if (!mounted) return;

        setState(() {
          remoteStream = stream;
          remoteRenderer.srcObject = stream;
          startCallTimer();
        });
      });

      // Handle errors
      mediaConnection?.on('error').listen((error) {
        log('Media connection error: $error');
      });
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

      log('Local stream tracks before answering:');
      localStream!.getTracks().forEach((track) {
        log('Track kind: ${track.kind}, enabled: ${track.enabled}, id: ${track.id}');
      });

      call.answer(localStream!);
      log('Call answered with local stream');

      call.on<MediaStream>('stream').listen((stream) {
        log('Remote stream received in answer');
        log('Remote stream tracks: ${stream.getTracks().length}');
        stream.getTracks().forEach((track) {
          log('Remote track kind: ${track.kind}, enabled: ${track.enabled}, id: ${track.id}');
        });

        if (!mounted) {
          log('Widget not mounted, returning');
          return;
        }

        setState(() {
          remoteStream = stream;
          remoteRenderer.srcObject = stream;
          startCallTimer();
          log('Remote renderer updated with new stream');
        });
      });

      // Add track event listener
      call.on('track').listen((event) {
        log('New track received');
        log('Track kind: ${event.track.kind}, enabled: ${event.track.enabled}, id: ${event.track.id}');

        if (event.track.kind == 'video') {
          setState(() {
            if (remoteStream != null) {
              remoteStream!.addTrack(event.track);
              remoteRenderer.srcObject = remoteStream;
              log('New video track added to remote stream');
            } else {
              log('Remote stream is null, cannot add track');
            }
          });
        }
      });

      call.on('error').listen((error) {
        log('Call answer error: $error');
      });

      mediaConnection = call;
      log('Media connection stored');
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
      log('Starting screen share...');
      const platform = MethodChannel('com.example.expert/screen_capture');
      await platform.invokeMethod('startService');
      log('Foreground service started');

      MediaStream screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': {'mediaSource': 'screen'},
        'audio': true
      });

      log('Screen stream obtained');
      log('Screen stream tracks: ${screenStream.getTracks().length}');
      screenStream.getTracks().forEach((track) {
        log('Track kind: ${track.kind}, enabled: ${track.enabled}, id: ${track.id}');
      });

      if (mediaConnection != null) {
        // Store old tracks to stop them later
        final oldTracks = localStream?.getTracks();

        // Add the new screen share stream to existing connection
        log('Adding screen share stream to existing connection');
        mediaConnection!.addStream(screenStream);

        // Update local stream reference
        localStream = screenStream;

        // Update local renderer
        setState(() {
          log('Updating local renderer with screen stream');
          localRenderer.srcObject = screenStream;
        });

        // Stop old tracks after successful switch
        oldTracks?.forEach((track) => track.stop());

        isSharing = true;
      }
    } catch (e) {
      _showSnackBar('Failed to start screen sharing: $e');
      log("Error starting screen share: $e");
    }
  }

  Future<void> stopScreenShare() async {
    try {
      if (isSharing) {
        log('Stopping screen share...');
        // Store screen sharing tracks to stop them later
        final screenTracks = localStream?.getTracks();

        // Reinitialize camera stream
        await _startLocalStream();

        if (mediaConnection != null && localStream != null) {
          log('Adding camera stream to existing connection');
          mediaConnection!.addStream(localStream!);

          // Update local renderer
          setState(() {
            log('Updating local renderer with camera stream');
            localRenderer.srcObject = localStream;
          });

          // Stop screen sharing tracks after successful switch
          screenTracks?.forEach((track) => track.stop());
        }

        setState(() {
          isSharing = false;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to stop screen sharing: $e');
      log('Error stopping screen share: $e');
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
      isRecording = !isRecording;
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
    log('Ending call...');

    // Stop timer
    callTimer?.cancel();

    // Clean up media streams
    remoteStream?.getTracks().forEach((track) => track.stop());
    localStream?.getTracks().forEach((track) => track.stop());

    // Clean up connections
    if (mediaConnection != null) {
      mediaConnection!.close();
      mediaConnection = null;
    }

    // Clean up renderers
    if (mounted) {
      setState(() {
        remoteRenderer.srcObject = null;
        localRenderer.srcObject = null;
      });
    }

    // Dispose resources
    remoteStream?.dispose();
    localStream?.dispose();

    // Disconnect socket and peer
    socket.disconnect();
    peer.dispose();

    // Navigate back if context is still valid
    if (mounted && Navigator.canPop(context)) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const RatingPage()));
      // Navigator.pop(context);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: appTheme.blackCall,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: remoteRenderer.srcObject == null
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[700],
                                child: Text(
                                  widget.userName[0] ?? '',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Waiting for ${widget.userName ?? ''}...",
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ))
                        : (remoteStream!.getVideoTracks().isEmpty)
                            ? Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[700],
                                  child: Text(
                                    widget.userName != null
                                        ? widget.userName![0]
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : RTCVideoView(
                                remoteRenderer,
                                objectFit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                              ),
                  ),
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
