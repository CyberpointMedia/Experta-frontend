class UserInfo {
  final String basicInfo;
  final String id;

  UserInfo({
    required this.basicInfo,
    required this.id,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      basicInfo: json['basicInfo'] as String,
      id: json['id'] as String,
    );
  }
}

class RazorpayDetails {
  final String? orderId;

  RazorpayDetails({this.orderId});

  factory RazorpayDetails.fromJson(Map<String, dynamic>? json) {
    return RazorpayDetails(
      orderId: json?['orderId'] as String?,
    );
  }
}

class RelatedBooking {
  final String id;
  final String expert;
  final String client;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String type;
  final String status;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  RelatedBooking({
    required this.id,
    required this.expert,
    required this.client,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.type,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RelatedBooking.fromJson(Map<String, dynamic> json) {
    return RelatedBooking(
      id: json['_id'] as String,
      expert: json['expert'] as String,
      client: json['client'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: json['duration'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class Transaction {
  final String id;
  final RazorpayDetails? razorpayDetails;
  final UserInfo? user;
  final UserInfo? sender;
  final UserInfo? receiver;
  final double amount;
  final String type;
  final String status;
  final String? paymentMethod;
  final RelatedBooking? relatedBooking;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    this.razorpayDetails,
    this.user,
    this.sender,
    this.receiver,
    required this.amount,
    required this.type,
    required this.status,
    this.paymentMethod,
    this.relatedBooking,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] as String,
      razorpayDetails: json['razorpayDetails'] != null
          ? RazorpayDetails.fromJson(
              json['razorpayDetails'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      sender: json['sender'] != null
          ? UserInfo.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      receiver: json['receiver'] != null
          ? UserInfo.fromJson(json['receiver'] as Map<String, dynamic>)
          : null,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      relatedBooking: json['relatedBooking'] != null
          ? RelatedBooking.fromJson(
              json['relatedBooking'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
