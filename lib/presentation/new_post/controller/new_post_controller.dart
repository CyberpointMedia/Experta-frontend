import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class NewPostController extends GetxController {
  final String? token = PrefUtils().getToken();
  var isLoading = false.obs; // Observable loading state

  Future<void> createPost({
    required List<Uint8List>? imageDataList,
    required Uint8List? imageData,
    required File? videoFile,
    required String caption,
    required String location,
    required String basicInfoId,
    required context,
  }) async {
    isLoading.value = true; // Set loading state to true
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://3.110.252.174:8080/api/post/create'),
      );

      // Add headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add files
      if (imageDataList != null && imageDataList.isNotEmpty) {
        for (var imageData in imageDataList) {
          // Convert image to JPEG format
          Uint8List jpegData = convertToJpeg(imageData);
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            jpegData,
            filename: 'image.jpg',
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      } else if (videoFile != null) {
        String mimeType = lookupMimeType(videoFile.path) ?? 'video/mp4';
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          videoFile.path,
          contentType: MediaType.parse(mimeType),
        ));
      } else if (imageData != null) {
        // Convert image to JPEG format
        Uint8List jpegData = convertToJpeg(imageData);
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          jpegData,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Add fields
      request.fields['caption'] = caption;
      request.fields['location'] = location;
      request.fields['basicInfoId'] = basicInfoId;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        Navigator.pop(context);
        // Get.toNamed(AppRoutes.dashboard);
        print('Post created successfully: $jsonResponse');
      } else {
        var responseData = await response.stream.bytesToString();
        print('Failed to create post: ${response.reasonPhrase}');
        print('Response data: $responseData');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  Uint8List convertToJpeg(Uint8List imageData) {
    // Decode the image
    img.Image? image = img.decodeImage(imageData);
    if (image == null) {
      throw Exception('Invalid image data');
    }

    // Encode the image to JPEG format
    return Uint8List.fromList(img.encodeJpg(image));
  }
}
