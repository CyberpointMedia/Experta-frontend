import 'package:experta/presentation/additional_info/model/interest_model.dart';

class Data {
  List<Language> languages;

  Data({required this.languages});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      languages: List<Language>.from(
          json['language'].map((x) => Language.fromJson(x))));
}

class LanguageResponseModel {
  String status;
  Data? data;

  LanguageResponseModel({required this.status, this.data});

  factory LanguageResponseModel.fromJson(Map<String, dynamic> json) {
    return LanguageResponseModel(
      status: json['status'],
      data: json['data'] is Map<String, dynamic>
          ? Data.fromJson(json['data'])
          : null,
    );
  }
}

class InterestResponseModel {
  final String status;
  final List<Interest> interests;

  InterestResponseModel({required this.status, required this.interests});

  factory InterestResponseModel.fromJson(Map<String, dynamic> json) {
    return InterestResponseModel(
      status: json['status'],
      interests: json['data'] is Map<String, dynamic> &&
              json['data']['intereset'] is List // Note the typo here
          ? List<Interest>.from(
              json['data']['intereset'].map((x) => Interest.fromJson(x)))
          : [],
    );
  }
}
