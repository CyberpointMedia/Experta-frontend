class Interest {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Interest({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Interest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Language model
// language_model.dart
class Language {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final int v;

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
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Submit Interest response

// class InterestResponse {
//   final String status;
//   final InterestData data;

//   InterestResponse({required this.status, required this.data});

//   factory InterestResponse.fromJson(Map<String, dynamic> json) {
//     return InterestResponse(
//       status: json['status'],
//       data: InterestData.fromJson(json['data']),
//     );
//   }
// }

// class InterestData {
//   final String id;
//   final int version;
//   final DateTime createdAt;
//   final List<String> interests;
//   final DateTime updatedAt;

//   InterestData({
//     required this.id,
//     required this.version,
//     required this.createdAt,
//     required this.interests,
//     required this.updatedAt,
//   });

//   factory InterestData.fromJson(Map<String, dynamic> json) {
//     return InterestData(
//       id: json['_id'],
//       version: json['__v'],
//       createdAt: DateTime.parse(json['createdAt']),
//       interests: List<String>.from(json['intereset']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
// }
