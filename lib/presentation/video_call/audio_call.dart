import 'dart:async';
import 'dart:developer';
import 'package:experta/core/utils/image_constant.dart';
import 'package:experta/core/utils/size_utils.dart';
import 'package:experta/presentation/give_rating/give_rating.dart';
import 'package:experta/theme/theme_helper.dart';
import 'package:experta/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/utils/pref_utils.dart';

class AudioCallScreen extends StatefulWidget {
  final String userId;
  final String meetingId;
  final String userName;
  final String bookingId;
  final String profilePic;

  const AudioCallScreen({
    super.key,
    required this.userId,
    required this.meetingId,
    required this.userName,
    required this.bookingId,
    required this.profilePic,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
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
  bool isSpeakerOn = true;
  bool isRecording = false;
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
    stopCallTimer();
    localStream?.dispose();
    peer.dispose();
    socket.disconnect();
    super.dispose();
  }

  // Start call timer
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

  // Format duration as MM:SS
  String formatDuration(int duration) {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    setState(() {});
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
        'video': false,
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
          stopCallTimer();

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
      mediaConnection?.on('close').listen((_) {
        log('Call closed by remote peer');
        if (mounted) {
          endCall();
        }
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
        throw Exception('Local stream is not initialized');
      }

      // Answer the call with local stream
      call.answer(localStream!);

      // Handle remote stream
      call.on<MediaStream>('stream').listen((stream) {
        log('Remote stream received in answer.');
        if (!mounted) return;

        setState(() {
          remoteStream = stream;
          remoteRenderer.srcObject = stream;
          startCallTimer();
        });
      });
      call.on('close').listen((_) {
        log('Call closed by remote peer');
        if (mounted) {
          endCall();
        }
      });
      // Handle errors
      call.on('error').listen((error) {
        log('Call answer error: $error');
      });

      // Store the media connection
      mediaConnection = call;
    } catch (e) {
      log('Error answering call: $e');
      _showSnackBar('Failed to answer call: $e');
    }
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

    stopCallTimer();

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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
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
                          : RTCVideoView(remoteRenderer),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.userName ?? '',
                          style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 20, color: appTheme.whiteA700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: appTheme.whiteA700,
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: appTheme.red500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatDuration(callDuration),
                              style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 14, color: appTheme.whiteA700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: CustomImageView(
                    imagePath: "assets/call/callAudio.svg",
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
                                child: CustomImageView(
                                height: 80.adaptSize,
                                width: 80.adaptSize,
                                imagePath: imagePath,
                                placeHolder: ImageConstant.imageNotFound,
                                radius: BorderRadius.circular(40.adaptSize),
                              ))
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
                  icon: Icon(isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white, size: 32),
                  onPressed: toggleSpeaker,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
