// industry_model.dart
import 'package:experta/core/app_export.dart';

class Industry {
  final String id;
  final String name;
  final String? icon;

  Industry({required this.id, required this.name, this.icon});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
    };
  }
}

// user_model.dart
class User {
  String id;
  bool online;
  int rating;
  String profilePic;
  String displayName;
  String industry;
  String occupation;
  Pricing pricing;

  User({
    required this.id,
    required this.online,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.industry,
    required this.occupation,
    required this.pricing,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      online: json['online'],
      rating: json['rating'],
      profilePic: json['profilePic'] ?? ImageConstant.female,
      displayName: json['displayName'] ?? 'Not Found',
      industry: json['industry'] ?? 'N/A',
      occupation: json['occupation'] ?? 'N/A',
      pricing: Pricing.fromJson(json['pricing']),
    );
  }
}

class Pricing {
  String id;
  int audioCallPrice;
  int messagePrice;
  int videoCallPrice;

  Pricing({
    required this.id,
    required this.audioCallPrice,
    required this.messagePrice,
    required this.videoCallPrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['_id'] ?? '',
      audioCallPrice: json['audioCallPrice'] ?? 0,
      messagePrice: json['messagePrice'] ?? 0,
      videoCallPrice: json['videoCallPrice'] ?? 0,
    );
  }
}

// search_result_model.dart
class SearchResult {
  String id;
  bool online;
  bool isVerified;
  int noOfBooking;
  int rating;
  String profilePic;
  String displayName;
  String lastName;
  String firstName;
  String industry;
  String occupation;

  SearchResult({
    required this.id,
    required this.online,
    required this.isVerified,
    required this.noOfBooking,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.lastName,
    required this.firstName,
    required this.industry,
    required this.occupation,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'],
      online: json['online'],
      isVerified: json['isVerified'],
      noOfBooking: json['noOfBooking'],
      rating: json['rating'],
      profilePic: json['profilePic'],
      displayName: json['displayName'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      industry: json['industry'],
      occupation: json['occupation'],
    );
  }
}
