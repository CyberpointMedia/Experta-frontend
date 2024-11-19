// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:experta/core/app_export.dart';
import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';

import 'package:experta/data/models/request/verify_otp_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/data/models/response/resend_otp_response_model.dart';
import 'package:experta/data/models/response/verify_otp_response_model.dart';
import 'package:experta/data/models/transaction_list.dart';
import 'package:experta/presentation/additional_info/model/additional_model.dart';
import 'package:experta/presentation/additional_info/model/interest_model.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:experta/presentation/share_profile/models/share_profile_model.dart';
import 'package:experta/presentation/verify_account/Models/verify_account_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://3.110.252.174:8080/api';
  final String? token = PrefUtils().getToken();

  Future<dynamic> registerUser(RegisterRequestModel model) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()),
    );

    log('API call made to $url with body: ${jsonEncode(model.toJson())}');
    log('API response status: ${response.statusCode}, body: ${response.body}');

    return _processResponse2(response);
  }

  Future<ResendOtpResponseModel?> resendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNo': phoneNumber}),
    );

    return _processResponse<ResendOtpResponseModel>(response);
  }

  Future<VerifyOtpResponseModel?> verifyOtp(
      VerifyOtpRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      body: jsonEncode(requestModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    return _processResponse<VerifyOtpResponseModel>(response);
  }

  Future<LoginResponseModel?> loginUser(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      body: jsonEncode(requestModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    return _processResponse<LoginResponseModel>(response);
  }

  Future<List<WorkExperience>> fetchWorkExperience() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/work-experience'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _processResponse<List<WorkExperience>>(response);
  }

  Future<List<Expertise>> fetchExpertise() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/expertise'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return _processResponse<List<Expertise>>(response);
  }

  Future<List<Education>> fetchEducation() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/education'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Logger();
    return _processResponse<List<Education>>(response);
  }

  Future<Map<String, dynamic>> getFollowersAndFollowing(String userId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/profile/$userId/followersandfollowing'));

    if (response.statusCode == 200) {
      log("the response for followers is ${response.body}");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<ExpertiseItem>> fetchExpertiseItems() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/expertise-items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'] as List;
      return data.map((item) => ExpertiseItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load expertise items');
    }
  }

  Future<Map<String, dynamic>> saveExpertiseItems(
      List<String> expertiseIds) async {
    final url = Uri.parse('$_baseUrl/create-expertise');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"expertise": expertiseIds.toSet().toList()}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save expertise items');
    }
  }

  Future<List<dynamic>> fetchIndustries() async {
    final response = await _dio.get('$_baseUrl/industry');
    return response.data['data'];
  }

  Future<List<dynamic>> fetchOccupations(String industryId) async {
    final response = await _dio.get('$_baseUrl/occupation/$industryId');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createOrUpdateWorkExperience(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-work-experience'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save work experience');
    }
  }

  Future<void> createIndustryInfo(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-industry-info'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create industry info');
    }
  }

  Future<Map<String, dynamic>> fetchProfessionalInfo() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/industry-info'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load professional info');
    }
  }

  Future<void> saveEducation(Education education) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-education'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        '_id': education.id.isEmpty ? null : education.id,
        'degree': education.degree,
        'schoolCollege': education.schoolCollege,
        'startDate': education.startDate.toIso8601String(),
        'endDate': education.endDate.toIso8601String(),
      }),
    );

    print('Request Body: ${json.encode({
          '_id': education.id.isEmpty ? null : education.id,
          'degree': education.degree,
          'schoolCollege': education.schoolCollege,
          'startDate': education.startDate.toIso8601String(),
          'endDate': education.endDate.toIso8601String(),
        })}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to save education: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchBasicInfo() async {
    final url = '$_baseUrl/basic-info';
    log("Fetching basic info from: $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      log("Parsed data: $data");
      return data;
    } else {
      log("Failed to load basic info: ${response.body}");
      throw Exception('Failed to load basic info');
    }
  }

  Future<void> postBasicInfo(Map<String, dynamic> data, File? imageFile) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/create-basic-info'));

    // Add headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });

    // Add text fields
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add image file if it exists
    if (imageFile != null) {
      print('Uploading file: ${imageFile.path}');
      String mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      request.files.add(await http.MultipartFile.fromPath(
        'file', // The field name for the image file
        imageFile.path,
        filename: basename(imageFile.path),
        contentType: MediaType.parse(mimeType),
      ));
    }

    try {
      var response = await request.send();
      var responseString = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        log('${responseString.body} Uploaded successfully');
      } else {
        print(
            'Failed to upload: ${response.statusCode} - ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Failed to post basic info: $e');
    }
  }

  Future<LanguageResponseModel> fetchLanguages() async {
    final url = Uri.parse('$_baseUrl/language');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('API call made to $url');
    log('API response status: ${response.statusCode}, body: ${response.body}');
    return LanguageResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<InterestResponseModel> fetchInterests() async {
    final url = Uri.parse('$_baseUrl/interest');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    log('API call made to $url');
    log('API response status: ${response.statusCode}, body: ${response.body}');
    return InterestResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<List<Interest>> fetchAllInterests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/interest-items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      return data.map((json) => Interest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load interests list');
    }
  }

  Future<Map<String, dynamic>> fetchAllLanguages() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/all-languages-list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load languages');
    }
  }

  Future<Map<String, dynamic>> submitUserInterests(
      List<String> interestIds) async {
    final url = Uri.parse('$_baseUrl/create-user-interest');
    final body = jsonEncode({'interests': interestIds});

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to submit interests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting interests: $e');
    }
  }

  Future<Map<String, dynamic>> postSelectedLanguages(
      List<String> languageIds) async {
    final url = Uri.parse('$_baseUrl/create-user-language');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'language': languageIds}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post selected languages');
    }
  }

  Future<Map<String, dynamic>> fetchAvailability() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user-availability'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load availability data');
    }
  }

  Future<Map<String, dynamic>> deleteAvailability(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/availability/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete availability slot');
    }
  }

  Future<Map<String, dynamic>> createUserAvailability(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/create-user-availability');

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to create/update user availability: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> createUserPricing(
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-user-pricing'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save pricing');
    }
  }

  Future<Map<String, dynamic>> getUserData(
      String userId, String ownUserId) async {
    final body = {
      'userId': userId,
      'ownUserId': ownUserId,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/getUserData'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("profile response : $jsonData");
      return jsonData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<bool> followUser(String followedByUserId) async {
    final url = Uri.parse('$_baseUrl/profile/follow');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({"followedByUserId": followedByUserId});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // remove connection
  Future<Map<String, dynamic>> removeConnection(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/removeConnection');

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to  unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  bool isJson(String str) {
    try {
      json.decode(str);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> fetchFeeds(String type) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/posts/random/$type"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> likeUnlikePost(String postId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/post/likeUnlike/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> postComment(
      String postId, String comment) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/post/comment/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'comment': comment}),
    );
    return json.decode(response.body);
  }

  Future<List<Reason>> fetchReasons() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reasons'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      return data.map((json) => Reason.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reasons');
    }
  }

  Future<void> submitReport(Report report) async {
    try {
      final url = Uri.parse('$_baseUrl/report');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = json.encode(report.toJson());

      log('Submitting report to $url');
      log('Headers: $headers');
      log('Body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body.toString());
        log('Report submitted successfully');
      } else {
        log('Failed to submit report: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to submit report');
      }
    } catch (e) {
      log('Error submitting report: $e');
      throw Exception('Error submitting report');
    }
  }

  Future<Map<String, dynamic>> getAllBlockedUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/getAllBlockedUsers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load blocked users');
    }
  }

  Future<Map<String, dynamic>> unblockUser(String userId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/unblockUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'userToUnblockId': userId}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to unblock user');
    }
  }

  Future<void> updateAccountSettings(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/account-setting'),
      body: data,
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Account settings updated successfully');
    } else {
      // Handle failure
      print('Failed to update account settings');
    }
  }

  Future<bool> blockUser(String userToBlockId) async {
    final url = Uri.parse('$_baseUrl/blockUser');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userToBlockId': userToBlockId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        return true;
      }
    }

    return false;
  }

  Future<Map<String, dynamic>> fetchPostByUser(
      String userId, String type) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/posts"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Future<List<Map<String, dynamic>>> fetchChats() async {
  //   String url = '$_baseUrl/chat';
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //   int retryCount = 0;
  //   const maxRetries = 3;
  //   const retryDelay = Duration(seconds: 2);
  //   while (retryCount < maxRetries) {
  //     try {
  //       print('Making request to $url with headers $headers');
  //       final response = await http
  //           .get(Uri.parse(url), headers: headers)
  //           .timeout(Duration(seconds: 30)); // Increase timeout duration
  //       print('Response status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //       if (response.statusCode == 200) {
  //         return List<Map<String, dynamic>>.from(json.decode(response.body));
  //       } else {
  //         // Handle non-200 status codes
  //         print('Error: ${response.statusCode} - ${response.reasonPhrase}');
  //         throw Exception('Failed to load chats');
  //       }
  //     } catch (error) {
  //       print('Error fetching chats: $error');
  //       if (retryCount < maxRetries - 1) {
  //         retryCount++;
  //         print('Retrying... ($retryCount/$maxRetries)');
  //         await Future.delayed(retryDelay);
  //       } else {
  //         throw Exception('Failed to load chats after $maxRetries attempts');
  //       }
  //     }
  //   }
  //   throw Exception('Failed to load chats');
  // }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/message/$chatId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> markMessagesAsRead(String chatId) async {
    final url = '$_baseUrl/message/read/$chatId';
    print('Marking messages as read with URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print(
          'Failed to mark messages as read. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to mark messages as read');
    } else {
      print('Messages marked as read successfully');
    }
  }

  Future<Map<String, dynamic>> sendMessage(
      String content, String chatId, List<File> files) async {
    log("the sent message $content and chat id $chatId");

    var uri = Uri.parse('$_baseUrl/message');
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['content'] = content
      ..fields['chatId'] = chatId;

    for (var file in files) {
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'file', // This should match the key expected by your server
        stream,
        length,
        filename: basename(file.path),
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      log("Response body: $responseBody");
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<Map<String, dynamic>?> fetchChat(String userId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"userId": userId}),
    );
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      print('Failed to load chat ${response.body}');
      return null;
    }
  }

  T _processResponse<T>(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final jsonResponse = json.decode(response.body);
        print('Response JSON: $jsonResponse'); // Log the response

        if (T == LoginResponseModel) {
          return LoginResponseModel.fromJson(jsonResponse) as T;
        } else if (T == VerifyOtpResponseModel) {
          return VerifyOtpResponseModel.fromJson(jsonResponse) as T;
        } else if (T == ResendOtpResponseModel) {
          return ResendOtpResponseModel.fromJson(jsonResponse) as T;
        } else if (T == List<WorkExperience>) {
          return (jsonResponse['data'] as List)
              .map((item) => WorkExperience.fromJson(item))
              .toList() as T;
        } else if (T == List<Expertise>) {
          return (jsonResponse['data']['expertise'] as List)
              .map((item) => Expertise.fromJson(item))
              .toList() as T;
        } else if (T == List<Education>) {
          return (jsonResponse['data'] as List)
              .map((item) => Education.fromJson(item))
              .toList() as T;
        } else if (jsonResponse is Map<String, dynamic>) {
          return jsonResponse as T;
        }
        throw Exception('Unexpected response type');
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }

  dynamic _processResponse2(http.Response response) {
    final jsonResponse = json.decode(response.body);
    log('Response JSON: $jsonResponse'); // Log the response

    switch (response.statusCode) {
      case 200:
        if (jsonResponse['status'] == 'success') {
          return RegisterResponseSuccess.fromJson(jsonResponse);
        } else {
          return RegisterResponseError.fromJson(jsonResponse);
        }
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }

// wallet page apis

  Future<int?> getWalletBalance() async {
    const url = 'http://3.110.252.174:8080/api/wallet-balance';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['balance'];
        } else {
          throw Exception('Failed to get balance ${response.body}');
        }
      } else {
        throw Exception('Failed to connect to server ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> createOrder(double amount) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/create-razorpay-order"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'amount': (amount).toInt()}),
      );
      if (response.statusCode == 200) {
        log("hey the response is ${response.body}");
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      log('Error creating order: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
      String orderId, String paymentId, String signature) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/verify-payment"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        }),
      );
      if (response.statusCode == 200) {
        log("hey the response is ${response.body}");
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify payment');
      }
    } catch (e) {
      log('Error verifying payment: $e');
      rethrow;
    }
  }

  Future<List<Transaction>> fetchTransactionHistory() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/transaction-history'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List<dynamic> data = jsonResponse['data'];
        return data
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();
      } else {
        throw Exception('Failed to load transaction history');
      }
    } else {
      throw Exception('Failed to load transaction history');
    }
  }

  Future<Map<String, dynamic>> createBooking(
      Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-booking'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create booking');
    }
  }

  Future<Map<String, dynamic>> getUserAvailability(String userId) async {
    final String url = '$_baseUrl/user-availability/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user availability');
      }
    } catch (e) {
      throw Exception('Failed to load user availability: $e');
    }
  }

  Future<List<dynamic>> fetchClientBookings() async {
    print('Fetching client bookings...');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bookings-as-client'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      print('Client bookings response status: ${response.statusCode}');
      print('Client bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data'] as List<dynamic>;
      } else {
        throw Exception(
            'Failed to load client bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchClientBookings: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchExpertBookings() async {
    print('Fetching expert bookings...');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bookings-as-expert'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      print('Expert bookings response status: ${response.statusCode}');
      print('Expert bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data'] as List<dynamic>;
      } else {
        throw Exception(
            'Failed to load expert bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchExpertBookings: $e');
      rethrow;
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final url = Uri.parse('$_baseUrl/update-booking-status');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'bookingId': bookingId,
      'status': status,
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('API Response: $responseData');
        if (responseData['status'] == 'success') {
          // Handle success
          print('Booking status updated successfully!');
        } else {
          // Handle failure
          print('Failed to update booking status: ${responseData['message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating booking status: $error');
    }
  }

  Future<ShareProfileResponse> getShareProfile() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(
        Uri.parse('$_baseUrl/share-profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ShareProfileResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPAN(String panNumber) async {
    final url = Uri.parse('$_baseUrl/kyc/verify-pan');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({"panNumber": panNumber});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to verify PAN. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying PAN: $e');
    }
  }

  Future<Map<String, dynamic>> verifyBank({
    required String accountNumber,
    required String ifsc,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/kyc/verify-bank'),
        headers: headers,
        body: json.encode({
          'accountNumber': accountNumber,
          'ifsc': ifsc,
        }),
      );
      log(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to verify bank details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getPaymentMethodsStatus() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl/kyc/payment-methods-status'),
          headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load payment methods status');
      }
    } catch (e) {
      throw Exception('Error fetching payment methods status: $e');
    }
  }

  Future<Map<String, dynamic>> getBankingDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/kyc/banking-details'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['bankDetails'];
      } else {
        throw Exception('Failed to load banking details');
      }
    } catch (e) {
      throw Exception('Error fetching banking details: $e');
    }
  }

  Future<Map<String, dynamic>> getUpiDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/kyc/banking-details'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['upiDetails'];
      } else {
        throw Exception('Failed to load UPI details');
      }
    } catch (e) {
      throw Exception('Error fetching UPI details: $e');
    }
  }

  Future<Map<String, dynamic>> saveUpiId(String upiId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/kyc/save-upi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'upiId': upiId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save UPI ID');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyFaceLiveness(bool livenessStatus) async {
    final url = Uri.parse('$_baseUrl/kyc/face-liveness-client');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'livenessStatus': livenessStatus});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['data']['faceLiveness'];
        } else {
          throw Exception('Failed to verify face liveness.');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  Future<KYCResponse?> getKYCStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/kyc/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          log("${jsonResponse['data']}");
          return KYCResponse.fromJson(jsonResponse['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching KYC status: $e');
      return null;
    }
  }

  // Function to register device with API
  Future<void> registerDevice({
    required String fcmToken,
    required String deviceInfo,
  }) async {
    final url = Uri.parse("$_baseUrl/register-device");

    final body = jsonEncode({
      "fcmToken": fcmToken,
      "deviceInfo": deviceInfo,
    });

    try {
      log("Calling API to register device...");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        log("Device registered successfully: ${response.body}");
      } else {
        log("Failed to register device: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      log("Error registering device: $e", error: e);
    }
  }

  // Fetch Notifications API
  Future<Map<String, dynamic>> fetchNotifications(
      {int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications?page=$page&limit=$limit'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      rethrow;
    }
  }

  // Mark a specific notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/notifications/$notificationId/read'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/notifications/read-all'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read');
    }
  }
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorisedException implements Exception {
  final String message;
  UnauthorisedException(this.message);
}

class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);
}
