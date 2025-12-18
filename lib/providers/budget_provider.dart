import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/budget_model.dart';
import '../core/services/storage_service.dart';
import 'package:uuid/uuid.dart';

// Budget Repository
class BudgetRepository {
  final _uuid = const Uuid();

  List<BudgetModel> getAllBudgets() {
    return StorageService.budgets.values.cast<BudgetModel>().toList();
  }

  Future<void> addBudget(BudgetModel budget) async {
    await StorageService.budgets.put(budget.id, budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await StorageService.budgets.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await StorageService.budgets.delete(id);
  }

  BudgetModel? getBudgetById(String id) {
    return StorageService.budgets.get(id);
  }

  BudgetModel? getBudgetByCategory(String categoryId) {
    try {
      return getAllBudgets().firstWhere((b) => b.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  String generateId() => _uuid.v4();
}

// Budget State Notifier
class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
  final BudgetRepository repository;

  BudgetNotifier(this.repository) : super([]) {
    loadBudgets();
  }

  void loadBudgets() {
    state = repository.getAllBudgets();
  }

  Future<void> addBudget(BudgetModel budget) async {
    await repository.addBudget(budget);
    loadBudgets();
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await repository.updateBudget(budget);
    loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await repository.deleteBudget(id);
    loadBudgets();
  }

  Future<void> updateSpent(String categoryId, double amount) async {
    final budget = repository.getBudgetByCategory(categoryId);
    if (budget != null) {
      final updated = budget.copyWith(spent: amount);
      await updateBudget(updated);
    }
  }

  BudgetModel? getBudgetByCategory(String categoryId) {
    try {
      return state.firstWhere((b) => b.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  List<BudgetModel> getOverBudgets() {
    return state.where((b) => b.isOverBudget).toList();
  }

  List<BudgetModel> getNearLimitBudgets() {
    return state.where((b) => b.isNearLimit).toList();
  }
}

// Providers
final budgetRepositoryProvider = Provider((ref) => BudgetRepository());

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<BudgetModel>>(
  (ref) {
    return BudgetNotifier(ref.watch(budgetRepositoryProvider));
  },
);

// Alert providers
final overBudgetAlertsProvider = Provider<List<BudgetModel>>((ref) {
  final budgets = ref.watch(budgetProvider);
  return budgets.where((b) => b.isOverBudget).toList();
});

final nearLimitAlertsProvider = Provider<List<BudgetModel>>((ref) {
  final budgets = ref.watch(budgetProvider);
  return budgets.where((b) => b.isNearLimit).toList();
});
