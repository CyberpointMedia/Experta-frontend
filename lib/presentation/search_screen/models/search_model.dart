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
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'],
      online: json['online'],
      isVerified: json['isVerified'],
      noOfBooking: json['noOfBooking'],
      rating: json['rating'],
      profilePic: json['profilePic'],
      displayName: json['displayName'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      industry: json['industry'],
      occupation: json['occupation'],
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
    };
  }

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['_id'],
      online: map['online'],
      isVerified: map['isVerified'],
      noOfBooking: map['noOfBooking'],
      rating: map['rating'],
      profilePic: map['profilePic'],
      displayName: map['displayName'],
      lastName: map['lastName'],
      firstName: map['firstName'],
      industry: map['industry'],
      occupation: map['occupation'],
    );
  }
}
