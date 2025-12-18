import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 4)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  final ThemeMode themeMode;

  @HiveField(1)
  final String currency;

  @HiveField(2)
  final bool biometricEnabled;

  @HiveField(3)
  final bool notificationsEnabled;

  @HiveField(4)
  final bool budgetAlertsEnabled;

  @HiveField(5)
  final String userName;

  UserSettingsModel({
    this.themeMode = ThemeMode.system,
    this.currency = 'IDR',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
    this.budgetAlertsEnabled = true,
    this.userName = 'User',
  });

  UserSettingsModel copyWith({
    ThemeMode? themeMode,
    String? currency,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    bool? budgetAlertsEnabled,
    String? userName,
  }) {
    return UserSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      userName: userName ?? this.userName,
    );
  }
}

// Hive Adapter for ThemeMode
class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 5;

  @override
  ThemeMode read(BinaryReader reader) {
    return ThemeMode.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeByte(obj.index);
  }
}
