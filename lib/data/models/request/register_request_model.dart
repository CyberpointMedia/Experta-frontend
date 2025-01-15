class RegisterRequestModel {
  String? email;
  String? phoneNo;
  String? firstName;
  String? lastName;

  RegisterRequestModel(
      {this.email, this.phoneNo, this.firstName, this.lastName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}

class RegisterResponseSuccess {
  String status;
  Data data;

  RegisterResponseSuccess({required this.status, required this.data});

  factory RegisterResponseSuccess.fromJson(Map<String, dynamic> json) {
    return RegisterResponseSuccess(
      status: json['status'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String lastName;
  String firstName;
  String email;
  String phoneNo;
  int resendCount;
  String otp;
  String otpExpiry;
  bool block;
  bool isVerified;
  String id;

  Data({
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.phoneNo,
    required this.resendCount,
    required this.otp,
    required this.otpExpiry,
    required this.block,
    required this.isVerified,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      resendCount: json['resendCount'],
      otp: json['otp'],
      otpExpiry: json['otpExpiry'],
      block: json['block'],
      isVerified: json['isVerified'],
      id: json['id'],
    );
  }
  @override
  String toString() {
    return 'Data{lastName: $lastName, firstName: $firstName, email: $email, phoneNo: $phoneNo, resendCount: $resendCount, otp: $otp, otpExpiry: $otpExpiry, block: $block, isVerified: $isVerified, id: $id}';
  }
}

class RegisterResponseError {
  String status;
  Error error;

  RegisterResponseError({required this.status, required this.error});

  factory RegisterResponseError.fromJson(Map<String, dynamic> json) {
    return RegisterResponseError(
      status: json['status'],
      error: Error.fromJson(json['error']),
    );
  }
}

class Error {
  String errorCode;
  String errorMessage;

  Error({required this.errorCode, required this.errorMessage});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
    );
  }
}
