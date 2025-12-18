import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note;
      _type = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == TransactionType.expense
        ? AppCategories.expenseCategories
        : AppCategories.incomeCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Tambah Transaksi' : 'Edit Transaksi',
        ),
        actions: widget.transaction != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteTransaction,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        'Pengeluaran',
                        TransactionType.expense,
                        Icons.arrow_upward,
                        AppColors.expense,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTypeButton(
                        'Pemasukan',
                        TransactionType.income,
                        Icons.arrow_downward,
                        AppColors.income,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Amount Input
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                prefixText: 'Rp ',
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan jumlah';
                }
                if (double.tryParse(value) == null) {
                  return 'Jumlah tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category Selection
            Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory == category.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category.id;
                      });
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category.color.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? category.color
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, color: category.color, size: 32),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected
                                  ? category.color
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Tanggal'),
              subtitle: Text(DateHelper.formatDate(_selectedDate)),
              onTap: _selectDate,
            ),

            const SizedBox(height: 16),

            // Note Input
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Catatan (Opsional)',
                hintText: 'Tambahkan catatan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(
                  widget.transaction == null ? 'Simpan' : 'Update',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    String label,
    TransactionType type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _type == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _type = type;
          _selectedCategory = null; // Reset category when type changes
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final repository = ref.read(transactionRepositoryProvider);

    final transaction = TransactionModel(
      id: widget.transaction?.id ?? repository.generateId(),
      amount: amount,
      category: _selectedCategory!,
      type: _type,
      date: _selectedDate,
      note: _noteController.text,
      createdAt: widget.transaction?.createdAt,
    );

    if (widget.transaction == null) {
      await ref.read(transactionProvider.notifier).addTransaction(transaction);
    } else {
      await ref
          .read(transactionProvider.notifier)
          .updateTransaction(transaction);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.transaction != null) {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(widget.transaction!.id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
