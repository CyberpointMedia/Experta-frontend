// api_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CallApiService {
  final String baseUrl = 'https://video.experta.io/meetings';

  Future<http.Response> getMeeting(String meetingId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'meetingId': meetingId}),
    );
    log("hey the response is meeting started ${response.body}");
    return response;
  }

  Future<http.Response> scheduleMeeting(
      Map<String, dynamic> meetingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedule-meeting'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(meetingData),
    );
    log("hey the response is ${response.body}");
    return response;
  }

  Future<http.Response> getAllMeetings(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-all'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user-id': userId}),
    );
    log("hey the response is ${response.body}");
    return response;
  }
}
