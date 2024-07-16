import 'dart:convert';
import 'package:experta/core/app_export.dart';
import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';
import 'package:experta/data/models/request/resend_otp_request_model.dart';
import 'package:experta/data/models/request/verify_otp_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/data/models/response/resend_otp_response_model.dart';
import 'package:experta/data/models/response/verify_otp_response_model.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:experta/presentation/following/following.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
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

    return _processResponse(response);
  }

  Future<ResendOtpResponseModel?> resendOtp(
      ResendOtpRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/resend-otp'),
      body: jsonEncode(requestModel.toJson()),
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

  // Future<List<Follower>> fetchFollowers() async {
  //   final response = await http.get(Uri.parse('$_baseUrl/followers'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(response.body);
  //     List<Follower> followers = body.map((dynamic item) => Follower.fromJson(item)).toList().cast<Follower>();
  //     return followers;
  //   } else {
  //     throw Exception('Failed to load followers');
  //   }
  // }

   Future<Map<String, dynamic>> getFollowersAndFollowing(String userId) async {
  final response = await http.get(Uri.parse('$_baseUrl/profile/$userId/followersandfollowing'));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<FollowersAndFollowing> followers = (data['data']['followers'] as List)
        .map((follower) => FollowersAndFollowing.fromJson(follower))
        .toList();
    List<FollowersAndFollowing> following = (data['data']['following'] as List)
        .map((following) => FollowersAndFollowing.fromJson(following))
        .toList();
    return {
      'followers': followers,
      'following': following,
    };
  } else {
    throw Exception('Failed to load data');
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
