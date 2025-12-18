// Simple currency converter with hardcoded exchange rates
// Rates can be updated manually or extended with API in the future

class CurrencyService {
  // Base currency: IDR
  // Exchange rates as of typical values (can be updated manually)
  static final Map<String, double> _exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000064, // 1 IDR = 0.000064 USD (approx 15,600 IDR per USD)
    'EUR': 0.000059, // 1 IDR = 0.000059 EUR
    'GBP': 0.000051, // 1 IDR = 0.000051 GBP
    'JPY': 0.0095, // 1 IDR = 0.0095 JPY
    'SGD': 0.000086, // 1 IDR = 0.000086 SGD
    'MYR': 0.00029, // 1 IDR = 0.00029 MYR
    'CNY': 0.00046, // 1 IDR = 0.00046 CNY
    'AUD': 0.000099, // 1 IDR = 0.000099 AUD
    'THB': 0.0022, // 1 IDR = 0.0022 THB
  };

  static final List<String> supportedCurrencies = [
    'IDR',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'SGD',
    'MYR',
    'CNY',
    'AUD',
    'THB',
  ];

  static final Map<String, String> currencyNames = {
    'IDR': 'Indonesian Rupiah',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'SGD': 'Singapore Dollar',
    'MYR': 'Malaysian Ringgit',
    'CNY': 'Chinese Yuan',
    'AUD': 'Australian Dollar',
    'THB': 'Thai Baht',
  };

  // Convert amount from one currency to another
  static double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    if (from == to) return amount;

    // Convert to IDR first (base currency)
    final amountInIDR = amount / _exchangeRates[from]!;

    // Then convert to target currency
    return amountInIDR * _exchangeRates[to]!;
  }

  // Get exchange rate between two currencies
  static double getRate({required String from, required String to}) {
    if (from == to) return 1.0;

    return _exchangeRates[to]! / _exchangeRates[from]!;
  }

  // Get currency symbol
  static String getSymbol(String currency) {
    switch (currency) {
      case 'IDR':
        return 'Rp';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'SGD':
        return 'S\$';
      case 'MYR':
        return 'RM';
      case 'CNY':
        return '¥';
      case 'AUD':
        return 'A\$';
      case 'THB':
        return '฿';
      default:
        return currency;
    }
  }

  // Update exchange rate manually
  static void updateRate(String currency, double rate) {
    if (_exchangeRates.containsKey(currency)) {
      _exchangeRates[currency] = rate;
    }
  }

  // Get all exchange rates
  static Map<String, double> getAllRates() {
    return Map.from(_exchangeRates);
  }
}
