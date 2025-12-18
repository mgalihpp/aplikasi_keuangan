import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_settings_model.dart';
import '../core/services/storage_service.dart';

// Settings Repository
class SettingsRepository {
  static const String settingsKey = 'user_settings';

  UserSettingsModel getSettings() {
    final settings = StorageService.settings.get(settingsKey);
    return settings ?? UserSettingsModel();
  }

  Future<void> saveSettings(UserSettingsModel settings) async {
    await StorageService.settings.put(settingsKey, settings);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final current = getSettings();
    await saveSettings(current.copyWith(themeMode: mode));
  }

  Future<void> updateCurrency(String currency) async {
    final current = getSettings();
    await saveSettings(current.copyWith(currency: currency));
  }

  Future<void> updateBiometric(bool enabled) async {
    final current = getSettings();
    await saveSettings(current.copyWith(biometricEnabled: enabled));
  }

  Future<void> updateNotifications(bool enabled) async {
    final current = getSettings();
    await saveSettings(current.copyWith(notificationsEnabled: enabled));
  }

  Future<void> updateBudgetAlerts(bool enabled) async {
    final current = getSettings();
    await saveSettings(current.copyWith(budgetAlertsEnabled: enabled));
  }

  Future<void> updateUserName(String name) async {
    final current = getSettings();
    await saveSettings(current.copyWith(userName: name));
  }
}

// Settings State Notifier
class SettingsNotifier extends StateNotifier<UserSettingsModel> {
  final SettingsRepository repository;

  SettingsNotifier(this.repository) : super(UserSettingsModel()) {
    loadSettings();
  }

  void loadSettings() {
    state = repository.getSettings();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    await repository.updateThemeMode(mode);
    loadSettings();
  }

  Future<void> updateCurrency(String currency) async {
    await repository.updateCurrency(currency);
    loadSettings();
  }

  Future<void> updateBiometric(bool enabled) async {
    await repository.updateBiometric(enabled);
    loadSettings();
  }

  Future<void> updateNotifications(bool enabled) async {
    await repository.updateNotifications(enabled);
    loadSettings();
  }

  Future<void> updateBudgetAlerts(bool enabled) async {
    await repository.updateBudgetAlerts(enabled);
    loadSettings();
  }

  Future<void> updateUserName(String name) async {
    await repository.updateUserName(name);
    loadSettings();
  }
}

// Providers
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, UserSettingsModel>((ref) {
      return SettingsNotifier(ref.watch(settingsRepositoryProvider));
    });

// Theme mode provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

// Currency provider
final currencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).currency;
});
