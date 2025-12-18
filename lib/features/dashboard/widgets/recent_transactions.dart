import 'package:flutter/material.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/constants/app_colors.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecentTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada transaksi',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final category = AppCategories.getCategoryById(transaction.category);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (category?.color ?? AppColors.textSecondary).withOpacity(
                  0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                category?.icon ?? Icons.help_outline,
                color: category?.color ?? AppColors.textSecondary,
              ),
            ),
            title: Text(category?.name ?? transaction.category),
            subtitle: Text(DateHelper.formatDate(transaction.date)),
            trailing: Text(
              '${transaction.type == TransactionType.income ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
              style: TextStyle(
                color: transaction.type == TransactionType.income
                    ? AppColors.income
                    : AppColors.expense,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
