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
  List<Language>? language;
  List<Expertise>? expertise;
  Pricing? pricing;

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
     this.language,
     this.expertise,
     this.pricing,
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
      language: (json['language'] as List<dynamic>)
          .map((e) => Language.fromJson(e))
          .toList(),
      expertise: (json['expertise'] as List<dynamic>)
          .map((e) => Expertise.fromJson(e))
          .toList(),
      pricing: Pricing.fromJson(json['pricing']),
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
      'language': language!.map((e) => e.toMap()).toList(),
      'expertise': expertise!.map((e) => e.toMap()).toList(),
      'pricing': pricing!.toMap(),
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
      language: (map['language'] as List<dynamic>)
          .map((e) => Language.fromJson(e))
          .toList(),
      expertise: (map['expertise'] as List<dynamic>)
          .map((e) => Expertise.fromJson(e))
          .toList(),
      pricing: Pricing.fromJson(map['pricing']),
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

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
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

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
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

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      '__v': v,
      'audioCallPrice': audioCallPrice,
      'messagePrice': messagePrice,
      'videoCallPrice': videoCallPrice,
    };
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
