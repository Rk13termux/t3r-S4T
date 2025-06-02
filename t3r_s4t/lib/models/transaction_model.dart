class TransactionModel {
  final String id;
  final String userId;
  final String scriptId;
  final double amount;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.scriptId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      scriptId: json['scriptId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
