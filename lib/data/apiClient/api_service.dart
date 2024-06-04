import 'dart:convert';

import 'package:experta/core/app_export.dart';
import 'package:experta/data/models/request/login_request_model.dart';
import 'package:experta/data/models/request/register_request_model.dart';
import 'package:experta/data/models/request/resend_otp_request_model.dart';
import 'package:experta/data/models/request/verify_otp_request_model.dart';
import 'package:experta/data/models/response/login_response_model.dart';
import 'package:experta/data/models/response/register_response_model.dart';
import 'package:experta/data/models/response/resend_otp_response_model.dart';
import 'package:experta/data/models/response/verify_otp_response_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://3.110.252.174:8080/api';

  Future<dynamic> registerUser(RegisterRequestModel model) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return RegisterResponseSuccess.fromJson(jsonResponse);
      } else {
        return RegisterResponseError.fromJson(jsonResponse);
      }
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<ResendOtpResponseModel?> resendOtp(
      ResendOtpRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('http://3.110.252.174:8080/api/resend-otp'),
      body: jsonEncode(requestModel.toJson()),
    );
    if (response.statusCode == 200) {
      return ResendOtpResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to resend OTP');
    }
  }

  Future<VerifyOtpResponseModel?> verifyOtp(
      VerifyOtpRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('http://3.110.252.174:8080/api/verify-otp'),
      body: jsonEncode(requestModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return VerifyOtpResponseModel.fromJson(json.decode(response.body));
    } else {
      // Handle errors
      print('HTTP Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to verify OTP');
    }
  }

  Future<LoginResponseModel?> loginUser(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse('http://3.110.252.174:8080/api/login'),
      body: jsonEncode(requestModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    Logger();
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
