import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final TransactionType type;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String note;

  @HiveField(6)
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.note = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'category': category,
    'type': type.name,
    'date': date.toIso8601String(),
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      date: DateTime.parse(json['date']),
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? category,
    TransactionType? type,
    DateTime? date,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
