import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bulanan'),
            Tab(text: 'Tahunan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [MonthlyReport(), YearlyReport()],
      ),
    );
  }
}

class MonthlyReport extends ConsumerWidget {
  const MonthlyReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final monthStart = DateHelper.getMonthStart(now);
    final monthEnd = DateHelper.getMonthEnd(now);

    final transactionNotifier = ref.read(transactionProvider.notifier);
    final income = transactionNotifier.getTotalByType(
      TransactionType.income,
      start: monthStart,
      end: monthEnd,
    );
    final expense = transactionNotifier.getTotalByType(
      TransactionType.expense,
      start: monthStart,
      end: monthEnd,
    );
    final categorySpending = transactionNotifier.getSpendingByCategory(
      start: monthStart,
      end: monthEnd,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Month Header
        Text(
          DateHelper.formatMonthYear(now),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),

        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Pemasukan',
                income,
                AppColors.income,
                Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Pengeluaran',
                expense,
                AppColors.expense,
                Icons.arrow_upward,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildSummaryCard(
          context,
          'Saldo',
          income - expense,
          income - expense >= 0 ? AppColors.success : AppColors.error,
          Icons.account_balance_wallet,
        ),

        const SizedBox(height: 24),

        // Category Breakdown
        Text(
          'Pengeluaran per Kategori',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        if (categorySpending.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Belum ada data pengeluaran'),
            ),
          )
        else
          ...categorySpending.entries.map((entry) {
            final category = AppCategories.getCategoryById(entry.key);
            final percentage = (entry.value / expense) * 100;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          category?.icon ?? Icons.help_outline,
                          color: category?.color ?? AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category?.name ?? entry.key,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(entry.value),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        category?.color ?? AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YearlyReport extends ConsumerWidget {
  const YearlyReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final yearStart = DateHelper.getYearStart(now);
    final yearEnd = DateHelper.getYearEnd(now);

    final transactionNotifier = ref.read(transactionProvider.notifier);
    final income = transactionNotifier.getTotalByType(
      TransactionType.income,
      start: yearStart,
      end: yearEnd,
    );
    final expense = transactionNotifier.getTotalByType(
      TransactionType.expense,
      start: yearStart,
      end: yearEnd,
    );

    // Get monthly data for chart
    final monthlyData = _getMonthlyData(ref, now.year);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Year Header
        Text(
          now.year.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),

        // Summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildYearlySummaryRow(
                  context,
                  'Total Pemasukan',
                  income,
                  AppColors.income,
                ),
                const Divider(height: 24),
                _buildYearlySummaryRow(
                  context,
                  'Total Pengeluaran',
                  expense,
                  AppColors.expense,
                ),
                const Divider(height: 24),
                _buildYearlySummaryRow(
                  context,
                  'Saldo Bersih',
                  income - expense,
                  income - expense >= 0 ? AppColors.success : AppColors.error,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Monthly Trend Chart
        Text('Tren Bulanan', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            CurrencyFormatter.formatCompact(value),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'Mei',
                            'Jun',
                            'Jul',
                            'Agu',
                            'Sep',
                            'Okt',
                            'Nov',
                            'Des',
                          ];
                          if (value.toInt() >= 0 && value.toInt() < 12) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData['income']!,
                      color: AppColors.income,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: monthlyData['expense']!,
                      color: AppColors.expense,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Pemasukan', AppColors.income),
            const SizedBox(width: 24),
            _buildLegendItem('Pengeluaran', AppColors.expense),
          ],
        ),
      ],
    );
  }

  Widget _buildYearlySummaryRow(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Text(
          CurrencyFormatter.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Map<String, List<FlSpot>> _getMonthlyData(WidgetRef ref, int year) {
    final transactionNotifier = ref.read(transactionProvider.notifier);
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];

    for (int month = 1; month <= 12; month++) {
      final monthStart = DateTime(year, month, 1);
      final monthEnd = DateTime(year, month + 1, 0, 23, 59, 59);

      final income = transactionNotifier.getTotalByType(
        TransactionType.income,
        start: monthStart,
        end: monthEnd,
      );
      final expense = transactionNotifier.getTotalByType(
        TransactionType.expense,
        start: monthStart,
        end: monthEnd,
      );

      incomeSpots.add(FlSpot((month - 1).toDouble(), income));
      expenseSpots.add(FlSpot((month - 1).toDouble(), expense));
    }

    return {'income': incomeSpots, 'expense': expenseSpots};
  }
}
