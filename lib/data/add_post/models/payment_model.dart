class PaymentModel {
  final String id;
  final String userId;
  final String adId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String paymentStatus;
  final String? transactionId;
  final String? receipt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.adId,
    required this.amount,
    required this.paymentDate,
    this.paymentMethod = 'Razorpay',
    this.paymentStatus = 'Pending',
    this.transactionId,
    this.receipt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentModel(
      id: id,
      userId: map['userId'] as String,
      adId: map['adId'] as String,
      amount: (map['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(map['paymentDate'] as String),
      paymentMethod: map['paymentMethod'] as String? ?? 'Razorpay',
      paymentStatus: map['paymentStatus'] as String? ?? 'Pending',
      transactionId: map['transactionId'] as String?,
      receipt: map['receipt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'adId': adId,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'receipt': receipt,
    };
  }
}