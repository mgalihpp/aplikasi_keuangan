import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double limit;

  @HiveField(3)
  final double spent;

  @HiveField(4)
  final BudgetPeriod period;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime endDate;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limit,
    this.spent = 0.0,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

  double get remaining => limit - spent;

  bool get isOverBudget => spent > limit;

  bool get isNearLimit => progress >= 0.8 && !isOverBudget;

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    double? limit,
    double? spent,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

@HiveType(typeId: 3)
enum BudgetPeriod {
  @HiveField(0)
  monthly,
  @HiveField(1)
  yearly,
}
