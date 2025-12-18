import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  TransactionType? _filterType;
  String? _filterCategory;

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);

    var filteredTransactions = transactions;
    if (_filterType != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.type == _filterType)
          .toList();
    }
    if (_filterCategory != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.category == _filterCategory)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Transaksi'),
        actions: [
          PopupMenuButton<TransactionType?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (type) {
              setState(() {
                _filterType = type;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Semua')),
              const PopupMenuItem(
                value: TransactionType.income,
                child: Text('Pemasukan'),
              ),
              const PopupMenuItem(
                value: TransactionType.expense,
                child: Text('Pengeluaran'),
              ),
            ],
          ),
        ],
      ),
      body: filteredTransactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return _buildTransactionCard(transaction);
              },
            ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    final category = AppCategories.getCategoryById(transaction.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(transaction: transaction),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (category?.color ?? AppColors.textSecondary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category?.icon ?? Icons.help_outline,
                  color: category?.color ?? AppColors.textSecondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? transaction.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateHelper.formatDate(transaction.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (transaction.note.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        transaction.note,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${transaction.type == TransactionType.income ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  color: transaction.type == TransactionType.income
                      ? AppColors.income
                      : AppColors.expense,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
