// models/user_profile_model.dart
class UserProfile {
  String username;
  String email;
  String phoneNumber;
  String gender;
  DateTime birthday;

  UserProfile({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
  });
}
