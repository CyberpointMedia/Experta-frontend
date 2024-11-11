import 'package:camera/camera.dart';
import 'package:experta/core/app_export.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'face.dart/detector.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String _spokenText = "";
  String targetSentence = "I am the Boss";
  final ApiService apiService = ApiService();
  bool isLoading = false;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  void checkFaceLiveness() async {
    setState(() {
      isLoading = true;
    });

    try {
      final faceLiveness = await apiService.verifyFaceLiveness(true);
      final status = faceLiveness['status'];
      final confidence = faceLiveness['confidence'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Face Liveness Status: $status, Confidence: $confidence'),
          backgroundColor: status ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Start speech recognition when a face is detected
  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {});
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });

        // Check if the result is final and matches the target sentence
        if (result.finalResult &&
            _spokenText.toLowerCase() == targetSentence.toLowerCase()) {
          checkFaceLiveness();
          // _showSnackbar("Verification complete", Colors.green);
        } else if (result.finalResult) {
          _showSnackbar(
              "Speech did not match the required sentence", Colors.red);
        }
      });
    }
  }

  // Show Snackbar after speech completes
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // final painter = FaceDetectorPainter(
      //   faces,
      //   inputImage.metadata!.size,
      //   inputImage.metadata!.rotation,
      //   _cameraLensDirection,
      // );
      if (faces.isNotEmpty) {
        _startListening();
      }

      // _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
