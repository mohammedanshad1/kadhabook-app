class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final DateTime date;
  final String description;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? '',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
    );
  }
}
