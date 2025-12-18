import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_model.dart';
import '../core/services/storage_service.dart';
import 'package:uuid/uuid.dart';

// Transaction Repository
class TransactionRepository {
  final _uuid = const Uuid();

  List<TransactionModel> getAllTransactions() {
    return StorageService.transactions.values.cast<TransactionModel>().toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await StorageService.transactions.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await StorageService.transactions.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await StorageService.transactions.delete(id);
  }

  TransactionModel? getTransactionById(String id) {
    return StorageService.transactions.get(id);
  }

  List<TransactionModel> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return getAllTransactions()
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return getAllTransactions().where((t) => t.type == type).toList();
  }

  List<TransactionModel> getTransactionsByCategory(String category) {
    return getAllTransactions().where((t) => t.category == category).toList();
  }

  String generateId() => _uuid.v4();
}

// Transaction State Notifier
class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepository repository;

  TransactionNotifier(this.repository) : super([]) {
    loadTransactions();
  }

  void loadTransactions() {
    state = repository.getAllTransactions();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await repository.addTransaction(transaction);
    loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await repository.updateTransaction(transaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await repository.deleteTransaction(id);
    loadTransactions();
  }

  List<TransactionModel> getByDateRange(DateTime start, DateTime end) {
    return state
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  List<TransactionModel> getByType(TransactionType type) {
    return state.where((t) => t.type == type).toList();
  }

  List<TransactionModel> getByCategory(String category) {
    return state.where((t) => t.category == category).toList();
  }

  double getTotalByType(
    TransactionType type, {
    DateTime? start,
    DateTime? end,
  }) {
    var transactions = getByType(type);

    if (start != null && end != null) {
      transactions = transactions
          .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
          .toList();
    }

    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getSpendingByCategory({DateTime? start, DateTime? end}) {
    var expenses = getByType(TransactionType.expense);

    if (start != null && end != null) {
      expenses = expenses
          .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
          .toList();
    }

    final Map<String, double> categoryTotals = {};
    for (var transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }
}

// Providers
final transactionRepositoryProvider = Provider(
  (ref) => TransactionRepository(),
);

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
      return TransactionNotifier(ref.watch(transactionRepositoryProvider));
    });

// Computed providers
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final balanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);
  return income - expense;
});
