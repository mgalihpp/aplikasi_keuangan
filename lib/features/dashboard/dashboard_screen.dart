import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transaction_list_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../converter/currency_converter_screen.dart';
import 'widgets/balance_card.dart';
import 'widgets/summary_card.dart';
import 'widgets/spending_chart.dart';
import 'widgets/recent_transactions.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const TransactionListScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddTransactionScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final income = ref.watch(totalIncomeProvider);
    final expense = ref.watch(totalExpenseProvider);
    final transactions = ref.watch(transactionProvider);
    final overBudgets = ref.watch(overBudgetAlertsProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [AppColors.primaryBlue.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Aplikasi Keuangan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.currency_exchange),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CurrencyConverterScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Show notifications
                    if (overBudgets.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${overBudgets.length} budget melebihi batas!',
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Balance Card
                  BalanceCard(balance: balance)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Income & Expense Summary
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Pemasukan',
                          amount: income,
                          icon: Icons.arrow_downward,
                          color: AppColors.income,
                          isIncome: true,
                        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Pengeluaran',
                          amount: expense,
                          icon: Icons.arrow_upward,
                          color: AppColors.expense,
                          isIncome: false,
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Spending Chart
                  const SpendingChart().animate().fadeIn(
                    duration: 400.ms,
                    delay: 300.ms,
                  ),

                  const SizedBox(height: 24),

                  // Recent Transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaksi Terbaru',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to transactions
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  RecentTransactions(
                    transactions: transactions.take(5).toList(),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
