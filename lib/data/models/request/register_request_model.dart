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
