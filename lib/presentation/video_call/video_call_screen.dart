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
  bool isSpeakerOn = true;
  bool isRecording = false;
  MediaRecorder? _mediaRecorder;
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
  }

  @override
  void dispose() {
    isConnectionActive = false;
    if (mediaConnection != null) {
      mediaConnection!.close();
      mediaConnection = null;
    }
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
      setState(() {
        callDuration++;
      });
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
          if (mediaConnection != null) {
            mediaConnection!.close();
            mediaConnection = null;
          }
        });
        Navigator.of(context).pop();
      }
    });

    socket.on('screen-share-started', (data) {
      if (mounted) {
        setState(() {
          isSharing = true;
        });
      }
    });

    socket.on('screen-share-stopped', (data) {
      if (mounted) {
        setState(() {
          isSharing = false;
          screenRenderer.srcObject = null;
        });
      }
    });

    socket.on('error', (error) {
      log('Socket connection error: $error');
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

      // Check if there's an existing connection
      if (mediaConnection != null) {
        mediaConnection?.close();
        mediaConnection = null;
      }

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
      call.on('track').listen((event) {
        log('New track received: ${event.track.kind}');

        if (event.track.kind == 'video') {
          setState(() {
            if (event.streams.isNotEmpty) {
              // Check if this is a screen share stream
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
      await Helper.setSpeakerphoneOn(speakerOn);
      log(speakerOn ? 'Speaker on' : 'Speaker off');
    } catch (e) {
      _showSnackBar('Failed to set speaker mode: $e');
      log('Failed to set speaker mode: $e');
    }
  }

  Future<void> startScreenShare() async {
    if (!isConnectionActive) return;

    try {
      log('Starting screen share...');

      MediaStream? screenStream = await navigator.mediaDevices
          .getDisplayMedia({'video': true, 'audio': true});

      if (screenStream == null || !isConnectionActive) {
        throw Exception('Failed to get screen stream');
      }

      if (mediaConnection != null) {
        // Remove existing video tracks
        screenStream.getVideoTracks().forEach((track) {
          mediaConnection!.peerConnection?.addTrack(track, screenStream);
        });

        setState(() {
          screenRenderer.srcObject = screenStream;
          isSharing = true;
        });
        socket.emit('screen-share-started', {
          'roomId': widget.meetingId,
          'peerId': peer.id,
        });
      }
    } catch (e) {
      isSharing = false;
      _showSnackBar('Screen sharing failed: $e');
      log("Screen share error: $e");
    }
  }

  Future<void> stopScreenShare() async {
    try {
      if (isSharing) {
        log('Stopping screen share...');

        final screenStream = screenRenderer.srcObject;
        if (screenStream != null) {
          screenStream.getTracks().forEach((track) {
            track.stop();
          });
          if (mediaConnection?.peerConnection != null) {
            final senders = await mediaConnection!.peerConnection!.getSenders();
            for (var sender in senders) {
              if (sender.track != null &&
                  screenStream
                      .getTracks()
                      .any((track) => track.id == sender.track!.id)) {
                await mediaConnection!.peerConnection!.removeTrack(sender);
              }
            }
          }
        }

        setState(() {
          screenRenderer.srcObject = null;
          isSharing = false;
        });
        socket.emit('screen-share-stopped', {
          'roomId': widget.meetingId,
          'peerId': peer.id,
        });
      }
    } catch (e) {
      _showSnackBar('Failed to stop screen sharing: $e');
      log('Error stopping screen share: $e');
    }
  }

  Future<void> startScreenRecording() async {
    _mediaRecorder ??= MediaRecorder();
    if (!isRecording) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/screen_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    log(message); // Always log the message
  }

  void endCall() {
    log('Ending call...');
    stopCallTimer();
    remoteStream?.getTracks().forEach((track) => track.stop());
    localStream?.getTracks().forEach((track) => track.stop());
    if (mediaConnection != null) {
      mediaConnection!.close();
      mediaConnection = null;
    }
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
                // Main Video Container
                Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: appTheme.blackCall,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: isSharing
                        ? _buildScreenShareLayout()
                        : _buildNormalCallLayout(),
                  ),
                ),

                // Screen Sharing Indicator
                if (isSharing)
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.black54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.screen_share,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Screen sharing active',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Small Video Container (PiP)
                if (!isSharing)
                  Positioned(
                    top: 0.02 * screenHeight,
                    right: 0.03 * screenWidth,
                    child: _buildPiPView(),
                  ),
              ],
            ),
          ),
          _buildControlBar(),
        ],
      ),
    );
  }

  Widget _buildScreenShareLayout() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
            ),
            child: screenRenderer.srcObject != null
                ? RTCVideoView(
                    screenRenderer,
                    objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black54,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: localRenderer.srcObject != null
                          ? RTCVideoView(
                              localRenderer,
                              mirror: isFrontCamera,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            )
                          : _buildParticipantTile(
                              isLocal: true,
                              name: name ?? '',
                              imagePath: imagePath,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: remoteRenderer.srcObject != null
                          ? RTCVideoView(
                              remoteRenderer,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            )
                          : _buildParticipantTile(
                              isLocal: false,
                              name: widget.userName,
                              imagePath: widget.profilePic,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantTile({
    required bool isLocal,
    required String name,
    String? imagePath,
  }) {
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
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            isLocal ? 'You' : 'Remote',
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalCallLayout() {
    return remoteRenderer.srcObject == null
        ? _buildWaitingView()
        : RTCVideoView(
            remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          );
  }

  Widget _buildWaitingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[700],
            child: Text(
              widget.userName[0],
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Waiting for ${widget.userName}...",
            style: const TextStyle(color: Colors.white),
          ),
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
              : RTCVideoView(
                  localRenderer,
                  mirror: isFrontCamera,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
        ),
      ),
    );
  }

  Widget _buildLocalAvatarView() {
    return Center(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[700],
        child: Text(
          widget.userId[0],
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
        color: Colors.black.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.red,
            onPressed: endCall,
          ),
          _buildControlButton(
            icon: isMuted ? Icons.mic_off : Icons.mic,
            onPressed: toggleAudio,
          ),
          _buildControlButton(
            icon: showVideo ? Icons.videocam : Icons.videocam_off,
            onPressed: toggleVideo,
          ),
          _buildControlButton(
            icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
            onPressed: startScreenRecording,
          ),
          _buildControlButton(
            icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            onPressed: toggleSpeaker,
          ),
          _buildControlButton(
            icon: !isSharing ? Icons.screen_share : Icons.stop_screen_share,
            onPressed: toggleScreenShare,
          )
        ]));
  }

  Widget _buildControlButton({
    required IconData icon,
    Color color = Colors.white,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 32),
        onPressed: onPressed,
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
