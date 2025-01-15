class BlockedUser {
  final String id;
  final String displayName;
  final String industry;
  final String profilePic;
  final bool isVerified;
  final bool online;
  final int rating;
  final String occupation;

  BlockedUser({
    required this.id,
    required this.displayName,
    required this.industry,
    required this.profilePic,
    required this.isVerified,
    required this.online,
    required this.rating,
    required this.occupation,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['id'],
      displayName: json['displayName'] ?? '',
      industry: json['industry'] ?? '',
      profilePic: json['profilePic'] ?? '',
      isVerified: json['isVerified'] == true || json['isVerified'] == 'true',
      online: json['online'] == true,
      rating: json['rating'] ?? 0,
      occupation: json['occupation'] ?? '',
    );
  }
}
