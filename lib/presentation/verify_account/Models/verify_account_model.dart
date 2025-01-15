class VerifyAccountModel {}

class KYCResponse {
  final UserData userData;
  final String id;
  final String userId;
  final PanVerification panVerification;
  final FaceLiveness faceLiveness;
  final FaceMatch faceMatch;
  final BankVerification bankVerification;
  final UpiDetails upiDetails;
  final GstDetails gstDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final KYCStatus kycStatus;

  KYCResponse({
    required this.userData,
    required this.id,
    required this.userId,
    required this.panVerification,
    required this.faceLiveness,
    required this.faceMatch,
    required this.bankVerification,
    required this.upiDetails,
    required this.gstDetails,
    required this.createdAt,
    required this.updatedAt,
    required this.kycStatus,
  });

  factory KYCResponse.fromJson(Map<String, dynamic> json) {
    try {
      return KYCResponse(
        userData: UserData.fromJson(json['userData'] ?? {}),
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        panVerification:
            PanVerification.fromJson(json['panVerification'] ?? {}),
        faceLiveness: FaceLiveness.fromJson(json['faceLiveness'] ?? {}),
        faceMatch: FaceMatch.fromJson(json['faceMatch'] ?? {}),
        bankVerification:
            BankVerification.fromJson(json['bankVerification'] ?? {}),
        upiDetails: UpiDetails.fromJson(json['upiDetails'] ?? {}),
        gstDetails: GstDetails.fromJson(json['gstDetails'] ?? {}),
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
        kycStatus: KYCStatus.fromJson(json['kycStatus'] ?? {}),
      );
    } catch (e) {
      print('Error parsing KYCResponse: $e');
      rethrow;
    }
  }
}

class UserData {
  final String id;
  final String? email;
  final String phoneNo;

  UserData({
    required this.id,
    this.email,
    required this.phoneNo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      email: json['email'], // No default value
      phoneNo: json['phoneNo'] ?? '',
    );
  }
}

class PanVerification {
  final PanDetails panDetails;
  final String panNumber;
  final DateTime updatedAt;
  final bool verificationStatus;

  PanVerification({
    required this.panDetails,
    required this.panNumber,
    required this.updatedAt,
    required this.verificationStatus,
  });

  factory PanVerification.fromJson(Map<String, dynamic> json) {
    return PanVerification(
      panDetails: PanDetails.fromJson(json['panDetails'] ?? {}),
      panNumber: json['panNumber'] ?? '',
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      verificationStatus: json['verificationStatus'] ?? false,
    );
  }
}

class PanDetails {
  final String clientId;
  final String panNumber;
  final String fullName;
  final String category;

  PanDetails({
    required this.clientId,
    required this.panNumber,
    required this.fullName,
    required this.category,
  });

  factory PanDetails.fromJson(Map<String, dynamic> json) {
    return PanDetails(
      clientId: json['client_id'] ?? '',
      panNumber: json['pan_number'] ?? '',
      fullName: json['full_name'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class FaceLiveness {
  final bool status;
  final int confidence;
  final String imageUrl;
  final DateTime updatedAt;

  FaceLiveness({
    required this.status,
    required this.confidence,
    required this.imageUrl,
    required this.updatedAt,
  });

  factory FaceLiveness.fromJson(Map<String, dynamic> json) {
    return FaceLiveness(
      status: json['status'] ?? false,
      confidence: json['confidence'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }
}

class FaceMatch {
  final bool status;
  final double confidence;
  final String selfieUrl;
  final String idCardUrl;
  final DateTime updatedAt;

  FaceMatch({
    required this.status,
    required this.confidence,
    required this.selfieUrl,
    required this.idCardUrl,
    required this.updatedAt,
  });

  factory FaceMatch.fromJson(Map<String, dynamic> json) {
    return FaceMatch(
      status: json['status'] ?? false,
      confidence: (json['confidence'] ?? 0).toDouble(),
      selfieUrl: json['selfieUrl'] ?? '',
      idCardUrl: json['idCardUrl'] ?? '',
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }
}

class BankVerification {
  final String accountNumber;
  final BankDetails bankDetails;
  final String ifsc;
  final DateTime updatedAt;
  final bool verificationStatus;

  BankVerification({
    required this.accountNumber,
    required this.bankDetails,
    required this.ifsc,
    required this.updatedAt,
    required this.verificationStatus,
  });

  factory BankVerification.fromJson(Map<String, dynamic> json) {
    return BankVerification(
      accountNumber: json['accountNumber'] ?? '',
      bankDetails: BankDetails.fromJson(json['bankDetails'] ?? {}),
      ifsc: json['ifsc'] ?? '',
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      verificationStatus: json['verificationStatus'] ?? false,
    );
  }
}

class BankDetails {
  final String clientId;
  final bool accountExists;
  final String fullName;
  final IfscDetails ifscDetails;

  BankDetails({
    required this.clientId,
    required this.accountExists,
    required this.fullName,
    required this.ifscDetails,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      clientId: json['client_id'] ?? '',
      accountExists: json['account_exists'] ?? false,
      fullName: json['full_name'] ?? '',
      ifscDetails: IfscDetails.fromJson({}),
    );
  }
}

class IfscDetails {
  final String bankName;
  final String branch;
  final String address;

  IfscDetails({
    required this.bankName,
    required this.branch,
    required this.address,
  });

  factory IfscDetails.fromJson(Map<String, dynamic> json) {
    return IfscDetails(
      bankName: json['bank_name'] ?? '',
      branch: json['branch'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class UpiDetails {
  final String upiId;
  final DateTime updatedAt;

  UpiDetails({
    required this.upiId,
    required this.updatedAt,
  });

  factory UpiDetails.fromJson(Map<String, dynamic> json) {
    return UpiDetails(
      upiId: json['upiId'] ?? '',
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }
}

class GstDetails {
  final String gstNumber;
  final DateTime updatedAt;
  GstDetails({
    required this.gstNumber,
    required this.updatedAt,
  });
  factory GstDetails.fromJson(Map<String, dynamic> json) {
    return GstDetails(
      gstNumber: json['gstNumber'],
      updatedAt:
          json['updatedAt'] != null && json['updatedAt'].toString().isNotEmpty
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }
}

class KYCStatus {
  final bool isComplete;
  final KYCSteps steps;

  KYCStatus({
    required this.isComplete,
    required this.steps,
  });

  factory KYCStatus.fromJson(Map<String, dynamic> json) {
    return KYCStatus(
      isComplete: json['isComplete'] ?? false,
      steps: KYCSteps.fromJson(json['steps'] ?? {}),
    );
  }
}

class KYCSteps {
  final bool bankVerification;
  final bool faceLiveness;
  final bool faceMatch;
  final bool panVerification;

  KYCSteps({
    required this.bankVerification,
    required this.faceLiveness,
    required this.faceMatch,
    required this.panVerification,
  });

  factory KYCSteps.fromJson(Map<String, dynamic> json) {
    return KYCSteps(
      bankVerification: json['bankVerification'] ?? false,
      faceLiveness: json['faceLiveness'] ?? false,
      faceMatch: json['faceMatch'] ?? false,
      panVerification: json['panVerification'] ?? false,
    );
  }
}
