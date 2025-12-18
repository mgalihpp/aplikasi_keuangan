import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/transaction_provider.dart';
import '../../../data/models/category_model.dart';

class SpendingChart extends ConsumerWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final monthStart = DateHelper.getMonthStart(now);
    final monthEnd = DateHelper.getMonthEnd(now);

    final transactionNotifier = ref.read(transactionProvider.notifier);
    final categorySpending = transactionNotifier.getSpendingByCategory(
      start: monthStart,
      end: monthEnd,
    );

    if (categorySpending.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada data pengeluaran',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengeluaran Bulan Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _buildPieChartSections(categorySpending),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context, categorySpending),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<String, double> categorySpending,
  ) {
    final total = categorySpending.values.fold(0.0, (sum, val) => sum + val);

    return categorySpending.entries.map((entry) {
      final category = AppCategories.getCategoryById(entry.key);
      final percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        color: category?.color ?? AppColors.textSecondary,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(
    BuildContext context,
    Map<String, double> categorySpending,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categorySpending.entries.map((entry) {
        final category = AppCategories.getCategoryById(entry.key);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (category?.color ?? AppColors.textSecondary).withOpacity(
              0.1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category?.color ?? AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category?.name ?? entry.key,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
