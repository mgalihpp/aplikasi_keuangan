import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/biometric_service.dart';
import '../../core/services/currency_service.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _biometricService = BiometricService();
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final available = await _biometricService.isBiometricEnrolled();
    setState(() {
      _biometricAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.userName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Edit Profil',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Appearance Section
          Text('Tampilan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text('Tema'),
                  subtitle: Text(_getThemeModeText(settings.themeMode)),
                  onTap: () => _showThemeDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Mata Uang'),
                  subtitle: Text(settings.currency),
                  onTap: () => _showCurrencyDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Security Section
          Text('Keamanan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Autentikasi Biometrik'),
              subtitle: Text(
                _biometricAvailable
                    ? 'Gunakan fingerprint/face ID'
                    : 'Tidak tersedia di perangkat ini',
              ),
              value: settings.biometricEnabled && _biometricAvailable,
              onChanged: _biometricAvailable
                  ? (value) async {
                      if (value) {
                        final authenticated = await _biometricService
                            .authenticate(
                              reason: 'Aktifkan autentikasi biometrik',
                            );
                        if (authenticated) {
                          ref
                              .read(settingsProvider.notifier)
                              .updateBiometric(true);
                        }
                      } else {
                        ref
                            .read(settingsProvider.notifier)
                            .updateBiometric(false);
                      }
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Notifications Section
          Text('Notifikasi', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Notifikasi'),
                  subtitle: const Text('Aktifkan notifikasi aplikasi'),
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .updateNotifications(value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.warning),
                  title: const Text('Peringatan Budget'),
                  subtitle: const Text(
                    'Notifikasi saat mendekati batas budget',
                  ),
                  value: settings.budgetAlertsEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .updateBudgetAlerts(value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          Text('Tentang', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Versi Aplikasi'),
                  subtitle: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Kebijakan Privasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Syarat & Ketentuan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Sistem';
    }
  }

  Future<void> _showThemeDialog() async {
    final settings = ref.read(settingsProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Terang'),
              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Gelap'),
              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sistem'),
              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCurrencyDialog() async {
    final settings = ref.read(settingsProvider);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Mata Uang'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: CurrencyService.supportedCurrencies.length,
            itemBuilder: (context, index) {
              final currency = CurrencyService.supportedCurrencies[index];
              final name = CurrencyService.currencyNames[currency] ?? currency;

              return RadioListTile<String>(
                title: Text('$currency - $name'),
                value: currency,
                groupValue: settings.currency,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).updateCurrency(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
