import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _amountController = TextEditingController();
  String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';
  double _result = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    setState(() {
      _result = CurrencyService.convert(
        amount: amount,
        from: _fromCurrency,
        to: _toCurrency,
      );
    });
  }

  void _swap() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rate = CurrencyService.getRate(from: _fromCurrency, to: _toCurrency);

    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Mata Uang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: AppColors.primaryBlue.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kurs: 1 $_fromCurrency = ${rate.toStringAsFixed(4)} $_toCurrency',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // From Currency
          Text('Dari', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      prefixText:
                          '${CurrencyService.getSymbol(_fromCurrency)} ',
                      prefixStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (_) => _convert(),
                  ),
                  const Divider(),
                  DropdownButton<String>(
                    value: _fromCurrency,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: CurrencyService.supportedCurrencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(
                          '$currency - ${CurrencyService.currencyNames[currency]}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _fromCurrency = value;
                          _convert();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Swap Button
          Center(
            child: IconButton.filled(
              onPressed: _swap,
              icon: const Icon(Icons.swap_vert),
              iconSize: 32,
            ),
          ),

          const SizedBox(height: 16),

          // To Currency
          Text('Ke', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            color: AppColors.primaryTeal.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        CurrencyService.getSymbol(_toCurrency),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _result.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  DropdownButton<String>(
                    value: _toCurrency,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: CurrencyService.supportedCurrencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(
                          '$currency - ${CurrencyService.currencyNames[currency]}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _toCurrency = value;
                          _convert();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Amounts
          Text('Jumlah Cepat', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickAmount(100000),
              _buildQuickAmount(500000),
              _buildQuickAmount(1000000),
              _buildQuickAmount(5000000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmount(double amount) {
    return OutlinedButton(
      onPressed: () {
        _amountController.text = amount.toString();
        _convert();
      },
      child: Text(
        '${CurrencyService.getSymbol(_fromCurrency)} ${amount >= 1000000 ? '${(amount / 1000000).toStringAsFixed(0)}Jt' : '${(amount / 1000).toStringAsFixed(0)}Rb'}',
      ),
    );
  }
}
