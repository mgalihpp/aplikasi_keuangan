import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isCustom;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconCode': icon.codePoint,
    'colorValue': color.value,
    'isCustom': isCustom,
  };

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
      isCustom: json['isCustom'] ?? false,
    );
  }
}

// Predefined Categories
class AppCategories {
  static const List<CategoryModel> expenseCategories = [
    CategoryModel(
      id: 'food',
      name: 'Makanan & Minuman',
      icon: Icons.restaurant,
      color: Color(0xFFFF6B6B),
    ),
    CategoryModel(
      id: 'transport',
      name: 'Transportasi',
      icon: Icons.directions_car,
      color: Color(0xFF4ECDC4),
    ),
    CategoryModel(
      id: 'shopping',
      name: 'Belanja',
      icon: Icons.shopping_bag,
      color: Color(0xFFFFBE0B),
    ),
    CategoryModel(
      id: 'entertainment',
      name: 'Hiburan',
      icon: Icons.movie,
      color: Color(0xFFFF006E),
    ),
    CategoryModel(
      id: 'health',
      name: 'Kesehatan',
      icon: Icons.local_hospital,
      color: Color(0xFF06FFA5),
    ),
    CategoryModel(
      id: 'education',
      name: 'Pendidikan',
      icon: Icons.school,
      color: Color(0xFF8338EC),
    ),
    CategoryModel(
      id: 'bills',
      name: 'Tagihan',
      icon: Icons.receipt_long,
      color: Color(0xFFFF9F1C),
    ),
    CategoryModel(
      id: 'other',
      name: 'Lainnya',
      icon: Icons.more_horiz,
      color: Color(0xFF95A5A6),
    ),
  ];

  static const List<CategoryModel> incomeCategories = [
    CategoryModel(
      id: 'salary',
      name: 'Gaji',
      icon: Icons.account_balance_wallet,
      color: Color(0xFF06D6A0),
    ),
    CategoryModel(
      id: 'business',
      name: 'Bisnis',
      icon: Icons.business_center,
      color: Color(0xFF118AB2),
    ),
    CategoryModel(
      id: 'investment',
      name: 'Investasi',
      icon: Icons.trending_up,
      color: Color(0xFF073B4C),
    ),
    CategoryModel(
      id: 'gift',
      name: 'Hadiah',
      icon: Icons.card_giftcard,
      color: Color(0xFFEF476F),
    ),
    CategoryModel(
      id: 'other_income',
      name: 'Lainnya',
      icon: Icons.attach_money,
      color: Color(0xFF06FFA5),
    ),
  ];

  static CategoryModel? getCategoryById(String id) {
    try {
      return [
        ...expenseCategories,
        ...incomeCategories,
      ].firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}
