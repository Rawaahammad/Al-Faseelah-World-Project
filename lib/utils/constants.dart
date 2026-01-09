import 'package:flutter/material.dart';

/// ألوان التطبيق الرئيسية
class AppColors {
  // الألوان الأساسية
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color lightGreen = Color(0xFF90EE90);
  static const Color mintGreen = Color(0xFF98D8AA);
  static const Color white = Colors.white;

  // ألوان إضافية
  static const Color orange = Color(0xFFFFB74D);
  static const Color purple = Color(0xFFBA68C8);
  static const Color cyan = Color(0xFF4DD0E1);
  static const Color darkText = Color(0xFF2D3436);
  static const Color lightText = Color(0xFF636E72);
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2E7D32);

  // التدرجات اللونية
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [skyBlue, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment. bottomRight,
  );
}

/// نصوص التطبيق
class AppStrings {
  static const String appName = 'عالم الفسيلة';
  static const String appSlogan = 'تعلم • العب • انمُ';
  static const String parentApp = 'تطبيق الأهل';

  // المناطق الأربع في اللعبة
  static const List<String> zones = [
    'المنزل',
    'المدرسة',
    'المسجد',
    'المنطقة المتغيرة',
  ];

  // أيام الأسبوع
  static const List<String> weekDays = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  // أنواع المحتوى
  static const List<String> contentTypes = [
    'قصص',
    'ألعاب تعليمية',
    'أنشطة',
    'محتوى ديني',
    'محتوى تربوي',
    'أناشيد',
  ];
}

/// أيقونات المناطق
class ZoneIcons {
  static const IconData home = Icons.home;
  static const IconData school = Icons.school;
  static const IconData mosque = Icons.mosque;
  static const IconData dynamic = Icons.park;
}