class VerifyAccountModel {}
class KYCResponse {
  final UserData? userData;
  final String? id;
  final String? userId;
  final PanVerification? panVerification;
  final FaceLiveness? faceLiveness;
  final FaceMatch? faceMatch;
  final BankVerification? bankVerification;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KYCResponse({
    this.userData,
    this.id,
    this.userId,
    this.panVerification,
    this.faceLiveness,
    this.faceMatch,
    this.bankVerification,
    this.createdAt,
    this.updatedAt,
  });

  factory KYCResponse.fromJson(Map<String, dynamic> json) {
    return KYCResponse(
      userData: json['userData'] != null ? UserData.fromJson(json['userData']) : null,
      id: json['_id'],
      userId: json['userId'],
      panVerification: json['panVerification'] != null
          ? PanVerification.fromJson(json['panVerification'])
          : null,
      faceLiveness: json['faceLiveness'] != null
          ? FaceLiveness.fromJson(json['faceLiveness'])
          : null,
      faceMatch: json['faceMatch'] != null
          ? FaceMatch.fromJson(json['faceMatch'])
          : null,
      bankVerification: json['bankVerification'] != null
          ? BankVerification.fromJson(json['bankVerification'])
          : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class UserData {
  final String? id;
  final String? email;
  final String? phoneNo;

  UserData({
    this.id,
    this.email,
    this.phoneNo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      email: json['email'],
      phoneNo: json['phoneNo'],
    );
  }
}

class PanVerification {
  final Map<String, dynamic>? panDetails;
  final String? panNumber;
  final DateTime? updatedAt;
  final bool? verificationStatus;

  PanVerification({
    this.panDetails,
    this.panNumber,
    this.updatedAt,
    this.verificationStatus,
  });

  factory PanVerification.fromJson(Map<String, dynamic> json) {
    return PanVerification(
      panDetails: json['panDetails'],
      panNumber: json['panNumber'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      verificationStatus: json['verificationStatus'],
    );
  }
}

class FaceLiveness {
  final bool? status;
  final int? confidence;
  final String? imageUrl;
  final DateTime? updatedAt;
  final String? id;

  FaceLiveness({
    this.status,
    this.confidence,
    this.imageUrl,
    this.updatedAt,
    this.id,
  });

  factory FaceLiveness.fromJson(Map<String, dynamic> json) {
    return FaceLiveness(
      status: json['status'],
      confidence: json['confidence'],
      imageUrl: json['imageUrl'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      id: json['_id'],
    );
  }
}

class FaceMatch {
  final bool? status;
  final double? confidence;
  final String? selfieUrl;
  final String? idCardUrl;
  final DateTime? updatedAt;
  final String? id;

  FaceMatch({
    this.status,
    this.confidence,
    this.selfieUrl,
    this.idCardUrl,
    this.updatedAt,
    this.id,
  });

  factory FaceMatch.fromJson(Map<String, dynamic> json) {
    return FaceMatch(
      status: json['status'],
      confidence: json['confidence'],
      selfieUrl: json['selfieUrl'],
      idCardUrl: json['idCardUrl'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      id: json['_id'],
    );
  }
}

class BankVerification {
  final String? accountNumber;
  final Map<String, dynamic>? bankDetails;
  final String? ifsc;
  final DateTime? updatedAt;
  final bool? verificationStatus;

  BankVerification({
    this.accountNumber,
    this.bankDetails,
    this.ifsc,
    this.updatedAt,
    this.verificationStatus,
  });

  factory BankVerification.fromJson(Map<String, dynamic> json) {
    return BankVerification(
      accountNumber: json['accountNumber'],
      bankDetails: json['bankDetails'],
      ifsc: json['ifsc'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      verificationStatus: json['verificationStatus'],
    );
  }
}
