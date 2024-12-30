class EditProfessionalInfoModel {}

// Work Experience Model

class WorkExperienceResponse {
  String status;
  Data data;

  WorkExperienceResponse({
    required this.status,
    required this.data,
  });

  factory WorkExperienceResponse.fromJson(Map<String, dynamic> json) =>
      WorkExperienceResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  int v;
  DateTime createdAt;
  DateTime updatedAt;
  List<WorkExperience> workExperience;

  Data({
    required this.id,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.workExperience,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        workExperience: List<WorkExperience>.from(
            json["workExperience"].map((x) => WorkExperience.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "workExperience":
            List<dynamic>.from(workExperience.map((x) => x.toJson())),
      };
}

class WorkExperience {
  String jobTitle;
  String companyName;
  bool isCurrentlyWorking;
  DateTime startDate;
  DateTime? endDate; // Make endDate nullable
  String id;

  WorkExperience({
    required this.jobTitle,
    required this.companyName,
    required this.isCurrentlyWorking,
    required this.startDate,
    this.endDate, // Make endDate nullable
    required this.id,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
        jobTitle: json["jobTitle"],
        companyName: json["companyName"],
        isCurrentlyWorking: json["isCurrentlyWorking"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: json["endDate"] != null
            ? DateTime.parse(json["endDate"])
            : null, // Handle null endDate
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "jobTitle": jobTitle,
        "companyName": companyName,
        "isCurrentlyWorking": isCurrentlyWorking,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate?.toIso8601String() ?? "", // Handle null endDate
        "_id": id,
      };

  int get yearsWorked {
    final end =
        endDate ?? DateTime.now(); // Use current date if endDate is null
    return end.year -
        startDate.year -
        ((end.month < startDate.month ||
                (end.month == startDate.month && end.day < startDate.day))
            ? 1
            : 0);
  }
}

// Expertise Model

class Expertise {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expertise({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(
      id: json['_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// Education

class Education {
  final String id;
  final String degree;
  final String schoolCollege;
  final DateTime startDate;
  final DateTime endDate;

  Education({
    required this.id,
    required this.degree,
    required this.schoolCollege,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'],
      degree: json['degree'],
      schoolCollege: json['schoolCollege'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

// Expertise Items

class ExpertiseItem {
  final String id;
  final String name;

  ExpertiseItem({required this.id, required this.name});

  factory ExpertiseItem.fromJson(Map<String, dynamic> json) {
    return ExpertiseItem(
      id: json['_id'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'ExpertiseItem{id: $id, name: $name}';
  }
}

// Dropdowns

class Industry {
  final String id;
  final String name;

  Industry({required this.id, required this.name});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Occupation {
  final String id;
  final String name;
  final String industryId;

  Occupation({required this.id, required this.name, required this.industryId});

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      id: json['_id'],
      name: json['name'],
      industryId: json['industry'],
    );
  }
}
