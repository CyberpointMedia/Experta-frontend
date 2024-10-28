class Transaction {
  final String id;
  final String user;
  final String type;
  final int amount;
  final String status;
  final String paymentMethod;
  final String? relatedBooking;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.user,
    required this.type,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.relatedBooking,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'] as String,
      user: json['user'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      relatedBooking: json['relatedBooking'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, user: $user, type: $type, amount: $amount, status: $status, paymentMethod: $paymentMethod, relatedBooking: $relatedBooking, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
