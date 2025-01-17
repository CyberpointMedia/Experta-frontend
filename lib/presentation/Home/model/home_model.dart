// industry_model.dart

class Industry {
  final String? id; 
  final String? name;
  final String? parent;
  final int? level;
  final String? icon;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;

  Industry({
    this.id,
    this.name,
    this.parent,
    this.level,
    this.icon,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['_id'],
      name: json['name'],
      parent: json['parent'],
      level: json['level'],
      icon: json['icon'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'parent': parent,
      'level': level,
      'icon': icon,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
  List<Language>? language;
  List<Expertise>? expertise;
  Pricing pricing;

  User({
    required this.id,
    required this.online,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.industry,
    required this.occupation,
    this.language,
    this.expertise,
    required this.pricing,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      online: json['online'],
      rating: json['rating'],
      profilePic: json['profilePic'] ?? 'default_image_path',
      displayName: json['displayName'] ?? 'Not Found',
      industry: json['industry'] ?? 'N/A',
      occupation: json['occupation'] ?? 'N/A',
      language: json['language'] != null
          ? List<Language>.from(
              json['language'].map((x) => Language.fromJson(x)))
          : null,
      expertise: json['expertise'] != null
          ? List<Expertise>.from(
              json['expertise'].map((x) => Expertise.fromJson(x)))
          : null,
      pricing: Pricing.fromJson(json['pricing']),
    );
  }
}

class Language {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Language({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

class Expertise {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Expertise({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(
      id: json['_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

class Pricing {
  String id;
  int v;
  int audioCallPrice;
  int messagePrice;
  int videoCallPrice;

  Pricing({
    required this.id,
    required this.v,
    required this.audioCallPrice,
    required this.messagePrice,
    required this.videoCallPrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['_id'] ?? '',
      v: json['__v'] ?? 0,
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

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'online': online,
      'isVerified': isVerified,
      'noOfBooking': noOfBooking,
      'rating': rating,
      'profilePic': profilePic,
      'displayName': displayName,
      'lastName': lastName,
      'firstName': firstName,
      'industry': industry,
      'occupation': occupation,
    };
  }

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['_id'],
      online: map['online'],
      isVerified: map['isVerified'],
      noOfBooking: map['noOfBooking'],
      rating: map['rating'],
      profilePic: map['profilePic'],
      displayName: map['displayName'],
      lastName: map['lastName'],
      firstName: map['firstName'],
      industry: map['industry'],
      occupation: map['occupation'],
    );
  }
}

// profile_completion_model.dart
class ProfileCompletion {
  final int totalCompletionPercentage;
  final SectionCompletions sectionCompletions;

  ProfileCompletion(
      {required this.totalCompletionPercentage,
      required this.sectionCompletions});

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) {
    return ProfileCompletion(
      totalCompletionPercentage: json['totalCompletionPercentage'],
      sectionCompletions:
          SectionCompletions.fromJson(json['sectionCompletions']),
    );
  }
}

class SectionCompletions {
  final int basicInfo;
  final int education;
  final int industryOccupation;
  final int workExperience;
  final int interest;
  final int language;
  final int expertise;
  final int pricing;
  final int availability;

  SectionCompletions({
    required this.basicInfo,
    required this.education,
    required this.industryOccupation,
    required this.workExperience,
    required this.interest,
    required this.language,
    required this.expertise,
    required this.pricing,
    required this.availability,
  });

  factory SectionCompletions.fromJson(Map<String, dynamic> json) {
    return SectionCompletions(
      basicInfo: json['basicInfo'],
      education: json['education'],
      industryOccupation: json['industryOccupation'],
      workExperience: json['workExperience'],
      interest: json['interest'],
      language: json['language'],
      expertise: json['expertise'],
      pricing: json['pricing'],
      availability: json['availability'],
    );
  }
}
