import 'dart:async';
import 'api_service.dart';

/// خدمة المصادقة
class AuthService {
  final ApiService _apiService = ApiService();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // المستخدم الحالي
  UserData? _currentUser;
  UserData? get currentUser => _currentUser;

  // حالة تسجيل الدخول
  bool get isLoggedIn => _currentUser != null;

  /// تسجيل الدخول
  Future<AuthResult> login(String email, String password) async {
    try {
      // محاكاة تسجيل الدخول
      await Future.delayed(const Duration(seconds: 1));

      // التحقق من البيانات (محاكاة)
      if (email.isNotEmpty && password.length >= 6) {
        _currentUser = UserData(
          id: 'user_001',
          email: email,
          name: 'أم سارة',
          createdAt: DateTime.now(),
        );

        _apiService.setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

        return AuthResult(
          success: true,
          message: 'تم تسجيل الدخول بنجاح',
          user: _currentUser,
        );
      } else {
        return AuthResult(
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }
    } catch (e) {
      return AuthResult(
        success:  false,
        message: 'حدث خطأ:  $e',
      );
    }
  }

  /// إنشاء حساب جديد
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // التحقق من البيانات
      if (name.isEmpty) {
        return AuthResult(success: false, message: 'الرجاء إدخال الاسم');
      }
      if (! _isValidEmail(email)) {
        return AuthResult(success: false, message: 'البريد الإلكتروني غير صحيح');
      }
      if (password.length < 6) {
        return AuthResult(success: false, message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      _currentUser = UserData(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      _apiService. setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      return AuthResult(
        success: true,
        message: 'تم إنشاء الحساب بنجاح',
        user: _currentUser,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ:  $e',
      );
    }
  }

  /// استعادة كلمة المرور
  Future<AuthResult> forgotPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (! _isValidEmail(email)) {
        return AuthResult(success:  false, message: 'البريد الإلكتروني غير صحيح');
      }

      return AuthResult(
        success: true,
        message: 'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني',
      );
    } catch (e) {
      return AuthResult(
        success:  false,
        message: 'حدث خطأ:  $e',
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    _currentUser = null;
    _apiService.clearAuthToken();
  }

  /// تحديث بيانات المستخدم
  Future<AuthResult> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: name,
          phone: phone,
        );

        return AuthResult(
          success: true,
          message: 'تم تحديث البيانات بنجاح',
          user: _currentUser,
        );
      }

      return AuthResult(
        success: false,
        message: 'يجب تسجيل الدخول أولاً',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// التحقق من صحة البريد الإلكتروني
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// نتيجة المصادقة
class AuthResult {
  final bool success;
  final String message;
  final UserData? user;

  AuthResult({
    required this.success,
    required this. message,
    this.user,
  });
}

/// بيانات المستخدم
class UserData {
  final String id;
  final String email;
  final String name;
  final String?  phone;
  final String? avatarUrl;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
    required this.createdAt,
  });

  UserData copyWith({
    String? id,
    String? email,
    String? name,
    String?  phone,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserData(
      id:  id ?? this.id,
      email: email ?? this.email,
      name: name ?? this. name,
      phone: phone ??  this.phone,
      avatarUrl: avatarUrl ?? this. avatarUrl,
      createdAt: createdAt ?? this. createdAt,
    );
  }
}