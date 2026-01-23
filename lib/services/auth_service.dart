import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// خدمة المصادقة مع Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // الحصول على المستخدم الحالي من Firebase
  User? get currentFirebaseUser => _auth.currentUser;
  
  // حالة تسجيل الدخول
  bool get isLoggedIn => _auth.currentUser != null;

  // Stream للاستماع لتغييرات حالة المصادقة
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// الحصول على بيانات المستخدم من Firestore
  Future<UserData?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserData.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// تسجيل الدخول
  Future<AuthResult> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // جلب بيانات المستخدم من Firestore
        final userData = await getCurrentUserData();
        
        return AuthResult(
          success: true,
          message: 'تم تسجيل الدخول بنجاح',
          user: userData,
        );
      } else {
        return AuthResult(
          success: false,
          message: 'حدث خطأ غير متوقع',
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'لا يوجد حساب بهذا البريد الإلكتروني';
          break;
        case 'wrong-password':
          message = 'كلمة المرور غير صحيحة';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;
        case 'user-disabled':
          message = 'تم تعطيل هذا الحساب';
          break;
        case 'invalid-credential':
          message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
          break;
        default:
          message = 'حدث خطأ: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ في الاتصال: $e',
      );
    }
  }

  /// إنشاء حساب جديد
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      // التحقق من البيانات
      if (name.isEmpty) {
        return AuthResult(success: false, message: 'الرجاء إدخال الاسم');
      }
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'البريد الإلكتروني غير صحيح');
      }
      if (password.length < 6) {
        return AuthResult(success: false, message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      // إنشاء الحساب في Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // حفظ بيانات المستخدم في Firestore
        final userData = UserData(
          id: userCredential.user!.uid,
          email: email.trim(),
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData.toJson());

        // تحديث اسم العرض في Firebase Auth
        await userCredential.user!.updateDisplayName(name);

        return AuthResult(
          success: true,
          message: 'تم إنشاء الحساب بنجاح',
          user: userData,
        );
      } else {
        return AuthResult(
          success: false,
          message: 'حدث خطأ غير متوقع',
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'هذا البريد الإلكتروني مستخدم بالفعل';
          break;
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جداً';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;
        default:
          message = 'حدث خطأ: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// استعادة كلمة المرور
  Future<AuthResult> forgotPassword(String email) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'البريد الإلكتروني غير صحيح');
      }

      await _auth.sendPasswordResetEmail(email: email.trim());

      return AuthResult(
        success: true,
        message: 'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني',
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'لا يوجد حساب بهذا البريد الإلكتروني';
          break;
        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;
        default:
          message = 'حدث خطأ: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// تحديث بيانات المستخدم
  Future<AuthResult> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult(
          success: false,
          message: 'يجب تسجيل الدخول أولاً',
        );
      }

      // تحديث البيانات في Firestore
      final updates = <String, dynamic>{};
      if (name != null && name.isNotEmpty) {
        updates['name'] = name;
        await user.updateDisplayName(name);
      }
      if (phone != null) {
        updates['phone'] = phone;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }

      final updatedUserData = await getCurrentUserData();

      return AuthResult(
        success: true,
        message: 'تم تحديث البيانات بنجاح',
        user: updatedUserData,
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
    required this.message,
    this.user,
  });
}

/// بيانات المستخدم
class UserData {
  final String id;
  final String email;
  final String name;
  final String? phone;
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

  /// إنشاء من Firestore
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      avatarUrl: data['avatarUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserData copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
