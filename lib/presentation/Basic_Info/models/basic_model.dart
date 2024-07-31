class BasicProfileInfoModel {
  final String id;
  final String firstName;
  final String lastName;
  final List<String> posts;
  final int rating;
  final String createdAt;
  final String updatedAt;
  final String bio;
  final String displayName;
  final String facebook;
  final String instagram;
  final String linkedin;
  final String twitter;
  final String profilePic;

  BasicProfileInfoModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.posts,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.bio,
    required this.displayName,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.twitter,
    required this.profilePic,
  });

  factory BasicProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicProfileInfoModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      posts: List<String>.from(json['posts'] ?? []),
      rating: json['rating'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bio: json['bio'] ?? '',
      displayName: json['displayName'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      twitter: json['twitter'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}
