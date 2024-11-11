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
  List<String> languages;
  List<String> expertises;

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
    required this.languages,
    required this.expertises,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'],
      online: json['online'],
      isVerified: json['isVerified'],
      noOfBooking: json['noOfBooking'],
      rating: json['rating'],
      profilePic: json['profilePic'] ?? '',
      displayName: json['displayName'] ?? '',
      lastName: json['lastName'] ?? '',
      firstName: json['firstName'] ?? '',
      industry: json['industry'] ?? '',
      occupation: json['occupation'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      expertises: List<String>.from(json['expertises'] ?? []),
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
      'languages': languages,
      'expertises': expertises,
    };
  }

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['_id'],
      online: map['online'],
      isVerified: map['isVerified'],
      noOfBooking: map['noOfBooking'],
      rating: map['rating'],
      profilePic: map['profilePic'] ?? '',
      displayName: map['displayName'] ?? '',
      lastName: map['lastName'] ?? '',
      firstName: map['firstName'] ?? '',
      industry: map['industry'] ?? '',
      occupation: map['occupation'] ?? '',
      languages: List<String>.from(map['languages'] ?? []),
      expertises: List<String>.from(map['expertises'] ?? []),
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
