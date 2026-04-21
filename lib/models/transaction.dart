class Transaction {
  final String id;
  final double amount;
  final String type; // 'charge' or 'payment'
  final String method; // 'card', 'bank', 'qr'
  final DateTime date;
  final String status; // 'pending', 'success', 'failed'
  final String? description;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.method,
    required this.date,
    required this.status,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'type': type,
    'method': method,
    'date': date.toIso8601String(),
    'status': status,
    'description': description,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    amount: json['amount'],
    type: json['type'],
    method: json['method'],
    date: DateTime.parse(json['date']),
    status: json['status'],
    description: json['description'],
  );
}
