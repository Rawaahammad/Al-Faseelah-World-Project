import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استيراد جميع الشاشات
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/child_profile_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/connection_screen.dart';
import 'screens/content_library_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/add_child_screen.dart';
import 'screens/parental_controls_screen.dart';

void main() {
  runApp(const AlFaseelahParentApp());
}

class AlFaseelahParentApp extends StatelessWidget {
  const AlFaseelahParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عالم الفسيلة',
      debugShowCheckedModeBanner: false,

      // دعم اللغة العربية
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // استخدام الثيم الفاتح فقط
      theme: _buildLightTheme(),

      // إلغاء الثيم الداكن - التطبيق سيستخدم الثيم الفاتح دائماً
      darkTheme: _buildLightTheme(),
      themeMode: ThemeMode.light,

      // الشاشة الرئيسية
      home: const SplashScreen(),

      // جميع المسارات
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/child-profile': (context) => const ChildProfileScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/connection': (context) => const ConnectionScreen(),
        '/library': (context) => const ContentLibraryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/add-child': (context) => const AddChildScreen(),
        '/parental-controls': (context) => const ParentalControlsScreen(),
      },
    );
  }

  // الثيم الفاتح - الألوان الأصلية
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الألوان الأساسية
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF87CEEB),
        // أزرق سماوي
        secondary: Color(0xFF90EE90),
        // أخضر فاتح
        tertiary: Color(0xFF98D8AA),
        // أخضر نعناعي
        surface: Colors.white,
        // أبيض
        background: Color(0xFFF5F5F5),
        // رمادي فاتح جداً
        onPrimary: Colors.white,
        onSecondary: Color(0xFF2D3436),
        onSurface: Color(0xFF2D3436),
        onBackground: Color(0xFF2D3436),
        error: Color(0xFFE74C3C),
      ),

      // لون الخلفية
      scaffoldBackgroundColor: Colors.white,

      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF87CEEB),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: const Color(0xFF87CEEB).withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),

      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF87CEEB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF87CEEB),
          side: const BorderSide(color: Color(0xFF87CEEB)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // أزرار النص
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF87CEEB)),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF87CEEB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIconColor: const Color(0xFF87CEEB),
      ),

      // الشرائح
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF90EE90).withOpacity(0.2),
        selectedColor: const Color(0xFF87CEEB),
        labelStyle: const TextStyle(color: Color(0xFF2D3436)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // شريط التنقل السفلي
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF87CEEB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      // مؤشر التحميل
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF87CEEB),
      ),

      // شريط التمرير
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF87CEEB),
        inactiveTrackColor: const Color(0xFF87CEEB).withOpacity(0.2),
        thumbColor: const Color(0xFF87CEEB),
        overlayColor: const Color(0xFF87CEEB).withOpacity(0.1),
      ),

      // مفتاح التبديل
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF87CEEB);
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF87CEEB).withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),

      // صندوق الاختيار
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF87CEEB);
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),

      // زر الراديو
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF87CEEB);
          }
          return Colors.grey;
        }),
      ),

      // شريط الإشعارات
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),

      // الفواصل
      dividerTheme: DividerThemeData(color: Colors.grey[300], thickness: 1),

      // القوائم
      listTileTheme: const ListTileThemeData(iconColor: Color(0xFF87CEEB)),

      // أيقونات التطبيق
      iconTheme: const IconThemeData(color: Color(0xFF87CEEB)),

      // النصوص
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF2D3436),
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF2D3436),
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Color(0xFF2D3436),
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(0xFF2D3436)),
        bodyMedium: TextStyle(color: Color(0xFF2D3436)),
        bodySmall: TextStyle(color: Color(0xFF636E72)),
      ),
    );
  }
}
