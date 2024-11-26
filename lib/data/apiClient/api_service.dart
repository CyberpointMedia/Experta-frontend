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
import 'package:experta/presentation/signin_page/signup_page.dart';
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
    final body = jsonEncode(model.toJson());

    AppLogger.request('POST', url.toString(),
        body: body, headers: {'Content-Type': 'application/json'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return _processResponse2(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to register user', stackTrace: stackTrace);
      throw Exception('Failed to register user: $e');
    }
  }

  Future<ResendOtpResponseModel?> resendOtp(String phoneNumber) async {
    final url = Uri.parse('$_baseUrl/resend-otp');
    final body = jsonEncode({'phoneNo': phoneNumber});

    AppLogger.request('POST', url.toString(),
        body: body, headers: {'Content-Type': 'application/json'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return _processResponse<ResendOtpResponseModel>(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to resend OTP', stackTrace: stackTrace);
      throw Exception('Failed to resend OTP: $e');
    }
  }

  Future<VerifyOtpResponseModel?> verifyOtp(
      VerifyOtpRequestModel requestModel) async {
    final url = Uri.parse('$_baseUrl/verify-otp');
    final body = jsonEncode(requestModel.toJson());

    AppLogger.request('POST', url.toString(),
        body: body, headers: {'Content-Type': 'application/json'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return _processResponse<VerifyOtpResponseModel>(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to verify OTP', stackTrace: stackTrace);
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<LoginResponseModel?> loginUser(
      LoginRequestModel requestModel, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = jsonEncode(requestModel.toJson());

    AppLogger.request('POST', url.toString(),
        body: body, headers: {'Content-Type': 'application/json'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return LoginResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 403) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['code'] == 453) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
          );
        }
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to login user', stackTrace: stackTrace);
      throw Exception('Failed to login user: $e');
    }
    return null; // Ensure a return statement is present
  }

  Future<List<WorkExperience>> fetchWorkExperience() async {
    final url = Uri.parse('$_baseUrl/work-experience');

    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      return _processResponse<List<WorkExperience>>(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch work experience',
          stackTrace: stackTrace);
      throw Exception('Failed to fetch work experience: $e');
    }
  }

  Future<List<Expertise>> fetchExpertise() async {
    final url = Uri.parse('$_baseUrl/expertise');

    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      return _processResponse<List<Expertise>>(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch expertise', stackTrace: stackTrace);
      throw Exception('Failed to fetch expertise: $e');
    }
  }

  Future<List<Education>> fetchEducation() async {
    final url = Uri.parse('$_baseUrl/education');

    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      return _processResponse<List<Education>>(response);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch education', stackTrace: stackTrace);
      throw Exception('Failed to fetch education: $e');
    }
  }

  Future<Map<String, dynamic>> getFollowersAndFollowing(String userId) async {
    final url = Uri.parse('$_baseUrl/profile/$userId/followersandfollowing');
    AppLogger.request('GET', url.toString());

    try {
      final response = await http.get(url);

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get followers and following',
          stackTrace: stackTrace);
      throw Exception('Failed to get followers and following: $e');
    }
  }

  Future<List<ExpertiseItem>> fetchExpertiseItems() async {
    final url = Uri.parse('$_baseUrl/expertise-items');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = jsonResponse['data'] as List;
        return data.map((item) => ExpertiseItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load expertise items');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch expertise items',
          stackTrace: stackTrace);
      throw Exception('Failed to fetch expertise items: $e');
    }
  }

  Future<Map<String, dynamic>> saveExpertiseItems(
      List<String> expertiseIds) async {
    final url = Uri.parse('$_baseUrl/create-expertise');
    final body = jsonEncode({"expertise": expertiseIds.toSet().toList()});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save expertise items');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save expertise items', stackTrace: stackTrace);
      throw Exception('Failed to save expertise items: $e');
    }
  }

  Future<List<dynamic>> fetchIndustries() async {
    final url = '$_baseUrl/industry';
    AppLogger.request('GET', url);

    try {
      final response = await _dio.get(url);

      AppLogger.response(
          'GET', url, response.statusCode!.toInt(), response.data.toString());

      return response.data['data'];
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch industries', stackTrace: stackTrace);
      throw Exception('Failed to fetch industries: $e');
    }
  }

  Future<List<dynamic>> fetchOccupations(String industryId) async {
    final url = '$_baseUrl/occupation/$industryId';
    AppLogger.request('GET', url);

    try {
      final response = await _dio.get(url);

      AppLogger.response(
          'GET', url, response.statusCode!.toInt(), response.data.toString());

      return response.data['data'];
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch occupations', stackTrace: stackTrace);
      throw Exception('Failed to fetch occupations: $e');
    }
  }

  Future<Map<String, dynamic>> createOrUpdateWorkExperience(
      Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/create-work-experience');
    final body = json.encode(data);
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save work experience');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create or update work experience',
          stackTrace: stackTrace);
      throw Exception('Failed to create or update work experience: $e');
    }
  }

  Future<void> createIndustryInfo(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/create-industry-info');
    final body = json.encode(data);
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to create industry info');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create industry info', stackTrace: stackTrace);
      throw Exception('Failed to create industry info: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProfessionalInfo() async {
    final url = Uri.parse('$_baseUrl/industry-info');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load professional info');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch professional info',
          stackTrace: stackTrace);
      throw Exception('Failed to fetch professional info: $e');
    }
  }

  Future<void> saveEducation(Education education) async {
    final url = Uri.parse('$_baseUrl/create-education');
    final body = json.encode({
      '_id': education.id.isEmpty ? null : education.id,
      'degree': education.degree,
      'schoolCollege': education.schoolCollege,
      'startDate': education.startDate.toIso8601String(),
      'endDate': education.endDate.toIso8601String(),
    });
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to save education: ${response.body}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save education', stackTrace: stackTrace);
      throw Exception('Failed to save education: $e');
    }
  }

  Future<Map<String, dynamic>> fetchBasicInfo() async {
    final url = '$_baseUrl/basic-info';
    AppLogger.request('GET', url);

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load basic info');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch basic info', stackTrace: stackTrace);
      throw Exception('Failed to fetch basic info: $e');
    }
  }

  Future<void> postBasicInfo(Map<String, dynamic> data, File? imageFile) async {
    final url = Uri.parse('$_baseUrl/create-basic-info');
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (imageFile != null) {
      String mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: basename(imageFile.path),
        contentType: MediaType.parse(mimeType),
      ));
    }

    AppLogger.request('POST', url.toString(),
        headers: request.headers, body: data.toString());

    try {
      var response = await request.send();
      var responseString = await http.Response.fromStream(response);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, responseString.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to post basic info');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to post basic info', stackTrace: stackTrace);
      throw Exception('Failed to post basic info: $e');
    }
  }

  Future<LanguageResponseModel> fetchLanguages() async {
    final url = Uri.parse('$_baseUrl/language');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      return LanguageResponseModel.fromJson(jsonDecode(response.body));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch languages', stackTrace: stackTrace);
      throw Exception('Failed to fetch languages: $e');
    }
  }

  Future<InterestResponseModel> fetchInterests() async {
    final url = Uri.parse('$_baseUrl/interest');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      return InterestResponseModel.fromJson(jsonDecode(response.body));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch interests', stackTrace: stackTrace);
      throw Exception('Failed to fetch interests: $e');
    }
  }

  Future<List<Interest>> fetchAllInterests() async {
    final url = Uri.parse('$_baseUrl/interest-items');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Interest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load interests list');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch all interests', stackTrace: stackTrace);
      throw Exception('Failed to fetch all interests: $e');
    }
  }

  Future<Map<String, dynamic>> fetchAllLanguages() async {
    final url = Uri.parse('$_baseUrl/all-languages-list');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch all languages', stackTrace: stackTrace);
      throw Exception('Failed to fetch all languages: $e');
    }
  }

  Future<Map<String, dynamic>> submitUserInterests(
      List<String> interestIds) async {
    final url = Uri.parse('$_baseUrl/create-user-interest');
    final body = jsonEncode({'interests': interestIds});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit interests: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error submitting interests', stackTrace: stackTrace);
      throw Exception('Error submitting interests: $e');
    }
  }

  Future<Map<String, dynamic>> postSelectedLanguages(
      List<String> languageIds) async {
    final url = Uri.parse('$_baseUrl/create-user-language');
    final body = jsonEncode({'language': languageIds});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post selected languages');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error posting selected languages',
          stackTrace: stackTrace);
      throw Exception('Error posting selected languages: $e');
    }
  }

  Future<Map<String, dynamic>> fetchAvailability() async {
    final url = Uri.parse('$_baseUrl/user-availability');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load availability data');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching availability', stackTrace: stackTrace);
      throw Exception('Error fetching availability: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAvailability(String id) async {
    final url = Uri.parse('$_baseUrl/availability/$id');
    AppLogger.request('DELETE', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'DELETE', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete availability slot');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting availability', stackTrace: stackTrace);
      throw Exception('Error deleting availability: $e');
    }
  }

  Future<Map<String, dynamic>> createUserAvailability(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/create-user-availability');
    AppLogger.request('POST', url.toString(),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to create/update user availability: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating/updating user availability',
          stackTrace: stackTrace);
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> createUserPricing(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/create-user-pricing');
    AppLogger.request('POST', url.toString(),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save pricing');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving pricing', stackTrace: stackTrace);
      throw Exception('Error saving pricing: $e');
    }
  }

  Future<Map<String, dynamic>> getUserData(
      String userId, String ownUserId) async {
    final url = Uri.parse('$_baseUrl/getUserData');
    final body = json.encode({'userId': userId, 'ownUserId': ownUserId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error loading user data', stackTrace: stackTrace);
      throw Exception('Error loading user data: $e');
    }
  }

  Future<bool> followUser(String followedByUserId) async {
    final url = Uri.parse('$_baseUrl/profile/follow');
    final body = jsonEncode({"followedByUserId": followedByUserId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      AppLogger.error('Error following user', stackTrace: stackTrace);
      return false;
    }
  }

  Future<Map<String, dynamic>> removeConnection(
      Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/removeConnection');
    AppLogger.request('POST', url.toString(),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to unfollow user: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error removing connection', stackTrace: stackTrace);
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> fetchFeeds(String type) async {
    final url = Uri.parse("$_baseUrl/posts/random/$type");
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching feeds', stackTrace: stackTrace);
      throw Exception('Error fetching feeds: $e');
    }
  }

  Future<Map<String, dynamic>> likeUnlikePost(String postId) async {
    final url = Uri.parse('$_baseUrl/post/likeUnlike/$postId');
    AppLogger.request('POST', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return json.decode(response.body);
    } catch (e, stackTrace) {
      AppLogger.error('Error liking/unliking post', stackTrace: stackTrace);
      throw Exception('Error liking/unliking post: $e');
    }
  }

  Future<Map<String, dynamic>> postComment(
      String postId, String comment) async {
    final url = Uri.parse('$_baseUrl/post/comment/$postId');
    final body = json.encode({'comment': comment});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      return json.decode(response.body);
    } catch (e, stackTrace) {
      AppLogger.error('Error posting comment', stackTrace: stackTrace);
      throw Exception('Error posting comment: $e');
    }
  }

  Future<Map<String, dynamic>> deleteComment(
      String postId, String commentId) async {
    final url = Uri.parse('$_baseUrl/post/comment');
    final body = json.encode({'postId': postId, 'commentId': commentId});

    AppLogger.request('DELETE', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      AppLogger.response(
          'DELETE', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to delete comment. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting comment', stackTrace: stackTrace);
      throw Exception('Error deleting comment: $e');
    }
  }

  Future<List<Reason>> fetchReasons() async {
    final url = Uri.parse('$_baseUrl/reasons');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Reason.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reasons');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching reasons', stackTrace: stackTrace);
      throw Exception('Error fetching reasons: $e');
    }
  }

  Future<void> submitReport(Report report) async {
    final url = Uri.parse('$_baseUrl/report');
    final body = json.encode(report.toJson());
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to submit report');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error submitting report', stackTrace: stackTrace);
      throw Exception('Error submitting report: $e');
    }
  }

  Future<Map<String, dynamic>> getAllBlockedUsers() async {
    final url = Uri.parse('$_baseUrl/getAllBlockedUsers');
    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load blocked users');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching blocked users', stackTrace: stackTrace);
      throw Exception('Error fetching blocked users: $e');
    }
  }

  Future<Map<String, dynamic>> unblockUser(String userId) async {
    final url = Uri.parse('$_baseUrl/unblockUser');
    final body = json.encode({'userToUnblockId': userId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to unblock user');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error unblocking user', stackTrace: stackTrace);
      throw Exception('Error unblocking user: $e');
    }
  }

  Future<void> updateAccountSettings(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/account-setting');
    AppLogger.request('POST', url.toString(),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(data));

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to update account settings');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating account settings',
          stackTrace: stackTrace);
      throw Exception('Error updating account settings: $e');
    }
  }

  Future<bool> blockUser(String userToBlockId) async {
    final url = Uri.parse('$_baseUrl/blockUser');
    final body = jsonEncode({'userToBlockId': userToBlockId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      }
      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Error blocking user', stackTrace: stackTrace);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchPostByUser(
      String userId, String type) async {
    final url = Uri.parse("$_baseUrl/posts");
    final body = jsonEncode({'userId': userId, 'type': type});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching posts by user', stackTrace: stackTrace);
      throw Exception('Error fetching posts by user: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatId) async {
    final url = Uri.parse('$_baseUrl/message/$chatId');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching messages', stackTrace: stackTrace);
      throw Exception('Error fetching messages: $e');
    }
  }

  Future<void> markMessagesAsRead(String chatId) async {
    final url = '$_baseUrl/message/read/$chatId';
    AppLogger.request('GET', url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to mark messages as read');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error marking messages as read', stackTrace: stackTrace);
      throw Exception('Error marking messages as read: $e');
    }
  }

  Future<Map<String, dynamic>> sendMessage(
      String content, String chatId, List<File> files) async {
    final url = Uri.parse('$_baseUrl/message');
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['content'] = content
      ..fields['chatId'] = chatId;

    for (var file in files) {
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(file.path),
        contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream'),
      );
      request.files.add(multipartFile);
    }

    AppLogger.request('POST', url.toString(),
        headers: request.headers,
        body: {'content': content, 'chatId': chatId}.toString());

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, responseBody.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(responseBody.body);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error sending message', stackTrace: stackTrace);
      throw Exception('Error sending message: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchChat(String userId) async {
    final url = Uri.parse('$_baseUrl/chat');
    final body = jsonEncode({"userId": userId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching chat', stackTrace: stackTrace);
      return null;
    }
  }

  T _processResponse<T>(http.Response response) {
    try {
      switch (response.statusCode) {
        case 200:
          final jsonResponse = json.decode(response.body);
          AppLogger.debug('Processing successful response: $jsonResponse');
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
          AppLogger.error(
              'Error occurred with status code: ${response.statusCode}');
          throw FetchDataException(
              'Error occurred while communicating with server with status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error processing response', stackTrace: stackTrace);
      rethrow;
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
    final url = '$_baseUrl/wallet-balance';
    AppLogger.request('GET', url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['balance'];
        } else {
          throw Exception('Failed to get balance');
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching wallet balance', stackTrace: stackTrace);
      return null;
    }
  }

  Future<Map<String, dynamic>> createOrder(double amount) async {
    final url = Uri.parse("$_baseUrl/create-razorpay-order");
    final body = jsonEncode({'amount': amount.toInt()});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating order', stackTrace: stackTrace);
      throw Exception('Error creating order: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
      String orderId, String paymentId, String signature) async {
    final url = Uri.parse("$_baseUrl/verify-payment");
    final body = jsonEncode({
      'razorpay_order_id': orderId,
      'razorpay_payment_id': paymentId,
      'razorpay_signature': signature,
    });
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify payment');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying payment', stackTrace: stackTrace);
      throw Exception('Error verifying payment: $e');
    }
  }

  Future<List<Transaction>> fetchTransactionHistory() async {
    final url = Uri.parse('$_baseUrl/transaction-history');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

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
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching transaction history',
          stackTrace: stackTrace);
      throw Exception('Error fetching transaction history: $e');
    }
  }

  Future<Map<String, dynamic>> createBooking(
      Map<String, dynamic> bookingData) async {
    final url = Uri.parse('$_baseUrl/create-booking');
    final body = jsonEncode(bookingData);
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error creating booking', stackTrace: stackTrace);
      throw Exception('Error creating booking: $e');
    }
  }

  Future<Map<String, dynamic>> getUserAvailability(String userId) async {
    final url = '$_baseUrl/user-availability/$userId';
    AppLogger.request('GET', url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user availability');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user availability',
          stackTrace: stackTrace);
      throw Exception('Error fetching user availability: $e');
    }
  }

  Future<List<dynamic>> fetchClientBookings() async {
    final url = '$_baseUrl/bookings-as-client';
    AppLogger.request('GET', url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data'] as List<dynamic>;
      } else {
        throw Exception('Failed to load client bookings');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching client bookings', stackTrace: stackTrace);
      throw Exception('Error fetching client bookings: $e');
    }
  }

  Future<List<dynamic>> fetchExpertBookings() async {
    final url = '$_baseUrl/bookings-as-expert';
    AppLogger.request('GET', url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data'] as List<dynamic>;
      } else {
        throw Exception('Failed to load expert bookings');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching expert bookings', stackTrace: stackTrace);
      throw Exception('Error fetching expert bookings: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final url = Uri.parse('$_baseUrl/update-booking-status');
    final body = json.encode({'bookingId': bookingId, 'status': status});
    AppLogger.request('PATCH', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.patch(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'PATCH', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to update booking status');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error updating booking status', stackTrace: stackTrace);
      throw Exception('Error updating booking status: $e');
    }
  }

  Future<ShareProfileResponse> getShareProfile() async {
    final url = Uri.parse('$_baseUrl/share-profile');
    AppLogger.request('POST', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ShareProfileResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching profile data', stackTrace: stackTrace);
      throw Exception('Error fetching profile data: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPAN(String panNumber) async {
    final url = Uri.parse('$_baseUrl/kyc/verify-pan');
    final body = json.encode({"panNumber": panNumber});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to verify PAN');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying PAN', stackTrace: stackTrace);
      throw Exception('Error verifying PAN: $e');
    }
  }

  Future<Map<String, dynamic>> verifyBank(
      {required String accountNumber, required String ifsc}) async {
    final url = Uri.parse('$_baseUrl/kyc/verify-bank');
    final body = json.encode({'accountNumber': accountNumber, 'ifsc': ifsc});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to verify bank details');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying bank details', stackTrace: stackTrace);
      throw Exception('Error verifying bank details: $e');
    }
  }

  Future<Map<String, dynamic>> getPaymentMethodsStatus() async {
    final url = Uri.parse('$_baseUrl/kyc/payment-methods-status');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load payment methods status');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching payment methods status',
          stackTrace: stackTrace);
      throw Exception('Error fetching payment methods status: $e');
    }
  }

  Future<Map<String, dynamic>> getBankingDetails() async {
    final url = Uri.parse('$_baseUrl/kyc/banking-details');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['bankDetails'];
      } else {
        throw Exception('Failed to load banking details');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching banking details', stackTrace: stackTrace);
      throw Exception('Error fetching banking details: $e');
    }
  }

  Future<Map<String, dynamic>> getUpiDetails() async {
    final url = Uri.parse('$_baseUrl/kyc/banking-details');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['upiDetails'];
      } else {
        throw Exception('Failed to load UPI details');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching UPI details', stackTrace: stackTrace);
      throw Exception('Error fetching UPI details: $e');
    }
  }

  Future<Map<String, dynamic>> saveUpiId(String upiId) async {
    final url = Uri.parse('$_baseUrl/kyc/save-upi');
    final body = jsonEncode({'upiId': upiId});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save UPI ID');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving UPI ID', stackTrace: stackTrace);
      throw Exception('Error saving UPI ID: $e');
    }
  }

  Future<Map<String, dynamic>> verifyFaceLiveness(bool livenessStatus) async {
    final url = Uri.parse('$_baseUrl/kyc/face-liveness-client');
    final body = jsonEncode({'livenessStatus': livenessStatus});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['data']['faceLiveness'];
        } else {
          throw Exception('Failed to verify face liveness');
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying face liveness', stackTrace: stackTrace);
      throw Exception('Error verifying face liveness: $e');
    }
  }

  Future<KYCResponse?> getKYCStatus() async {
    final url = Uri.parse('$_baseUrl/kyc/status');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return KYCResponse.fromJson(jsonResponse['data']);
        }
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching KYC status', stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> registerDevice(
      {required String fcmToken, required String deviceInfo}) async {
    final url = Uri.parse("$_baseUrl/register-device");
    final body = jsonEncode({"fcmToken": fcmToken, "deviceInfo": deviceInfo});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to register device');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error registering device', stackTrace: stackTrace);
      throw Exception('Error registering device: $e');
    }
  }

  Future<Map<String, dynamic>> fetchNotifications(
      {int page = 1, int limit = 20}) async {
    final url = Uri.parse('$_baseUrl/notifications?page=$page&limit=$limit');
    AppLogger.request('GET', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching notifications', stackTrace: stackTrace);
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse('$_baseUrl/notifications/$notificationId/read');
    AppLogger.request('PATCH', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.patch(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'PATCH', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error marking notification as read',
          stackTrace: stackTrace);
      throw Exception('Error marking notification as read: $e');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final url = Uri.parse('$_baseUrl/notifications/read-all');
    AppLogger.request('PATCH', url.toString(), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final response = await http.patch(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      AppLogger.response(
          'PATCH', url.toString(), response.statusCode, response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error marking all notifications as read',
          stackTrace: stackTrace);
      throw Exception('Error marking all notifications as read: $e');
    }
  }

  Future<Map<String, dynamic>> saveGstNumber(String gstNumber) async {
    final url = Uri.parse('$_baseUrl/kyc/save-gst');
    final body = jsonEncode({'gstNumber': gstNumber});
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save GST number');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving GST number', stackTrace: stackTrace);
      throw Exception('Error saving GST number: $e');
    }
  }

  Future<dynamic> withdrawMoney({
    required double amount,
    required String method,
    required Map<String, dynamic> paymentDetails,
  }) async {
    final url = Uri.parse('$_baseUrl/withdraw');
    final body = jsonEncode({
      'amount': amount,
      'paymentDetails': paymentDetails,
    });
    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);
      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to process withdrawal: ${response.body}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving GST number', stackTrace: stackTrace);
      throw Exception('Error processing withdrawal: $e');
    }
  }

  Future<dynamic> uploadFile(
    File file,
    void Function(double progress)? onProgress,
  ) async {
    final url = Uri.parse('$_baseUrl/upload');

    AppLogger.request('POST', url.toString(),
        body: 'File upload: ${file.path}',
        headers: {
          'Content-Type': 'multipart/form-data',
          if (token != null) 'Authorization': 'Bearer $token',
        });

    try {
      var request = http.MultipartRequest('POST', url);

      // Add headers if needed
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file to request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload file: ${response.body}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading file', stackTrace: stackTrace);
      throw Exception('Error uploading file: $e');
    }
  }

  Future<Map<String, dynamic>> raiseTicket({
    required String subject,
    required String description,
    required String fileUrl,
  }) async {
    final url = Uri.parse('$_baseUrl/raise-ticket');
    final body = jsonEncode({
      'subject': subject,
      'description': description,
      'fileUrl': fileUrl,
    });

    AppLogger.request('POST', url.toString(), body: body, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      AppLogger.response(
          'POST', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to raise ticket: ${response.body}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error raising ticket', stackTrace: stackTrace);
      throw Exception('Error raising ticket: $e');
    }
  }

  Future<Map<String, dynamic>> checkToken(String token) async {
    final url = Uri.parse('$_baseUrl/check-token');

    AppLogger.request('GET', url.toString(), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      AppLogger.response(
          'GET', url.toString(), response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to validate token: ${response.body}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error validating token', stackTrace: stackTrace);
      throw Exception('Error validating token: $e');
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
