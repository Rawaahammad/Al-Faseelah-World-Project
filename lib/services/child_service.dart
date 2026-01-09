import 'dart:async';
import '../models/child_model.dart';
import '../models/session_model.dart';
import '../models/activity_model.dart';
import 'api_service.dart';

/// خدمة إدارة الأطفال
class ChildService {
  final ApiService _apiService = ApiService();

  // Singleton pattern
  static final ChildService _instance = ChildService._internal();
  factory ChildService() => _instance;
  ChildService._internal();

  // قائمة الأطفال (محاكاة)
  final List<Child> _children = [
    Child(
      id:  'child_001',
      name: 'سارة',
      age: 5,
      gender: 'أنثى',
      avatar: '👧',
      interests: ['القصص', 'الألوان', 'الحيوانات'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Child(
      id: 'child_002',
      name: 'أحمد',
      age: 7,
      gender: 'ذكر',
      avatar:  '👦',
      interests:  ['الأرقام', 'الفضاء', 'الرياضة'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  /// الحصول على قائمة الأطفال
  Future<List<Child>> getChildren() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_children);
  }

  /// الحصول على طفل بالـ ID
  Future<Child?> getChildById(String id) async {
    await Future. delayed(const Duration(milliseconds:  200));
    try {
      return _children.firstWhere((child) => child.id == id);
    } catch (e) {
      return null;
    }
  }

  /// إضافة طفل جديد
  Future<ServiceResult> addChild(Child child) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final newChild = child.copyWith(
        id: 'child_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );

      _children. add(newChild);

      return ServiceResult(
        success: true,
        message: 'تم إضافة ${child.name} بنجاح',
        data: newChild,
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message: 'حدث خطأ:  $e',
      );
    }
  }

  /// تحديث بيانات طفل
  Future<ServiceResult> updateChild(Child child) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _children.indexWhere((c) => c.id == child.id);
      if (index != -1) {
        _children[index] = child;
        return ServiceResult(
          success: true,
          message: 'تم تحديث البيانات بنجاح',
          data: child,
        );
      }

      return ServiceResult(
        success: false,
        message: 'لم يتم العثور على الطفل',
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message:  'حدث خطأ: $e',
      );
    }
  }

  /// حذف طفل
  Future<ServiceResult> deleteChild(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _children.removeWhere((child) => child.id == id);

      return ServiceResult(
        success: true,
        message: 'تم الحذف بنجاح',
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// الحصول على جلسات طفل
  Future<List<Session>> getChildSessions(String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // بيانات محاكاة
    return [
      Session(
        id: 'session_001',
        childId: childId,
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1)),
        totalMinutes: 45,
        activities: [
          Activity(
            id: 'act_001',
            title: 'قصة الأرنب الصغير',
            type: 'قصة',
            zone: 'المنزل',
            duration: 15,
            result: 'مكتمل',
            starsEarned: 2,
            completedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
          Activity(
            id:  'act_002',
            title: 'تعلم الألوان',
            type: 'نشاط تعليمي',
            zone: 'المدرسة',
            duration: 20,
            result: 'نجمتان',
            starsEarned: 2,
            completedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
          ),
        ],
        zonesVisited: {'المنزل':  15, 'المدرسة': 20, 'المسجد': 10},
        mood: 'سعيد',
        focusLevel: 'عالي',
        starsEarned: 4,
      ),
    ];
  }

  /// الحصول على إحصائيات طفل
  Future<ChildStats> getChildStats(String childId) async {
    await Future. delayed(const Duration(milliseconds:  300));

    return ChildStats(
      totalMinutes: 345,
      totalActivities: 23,
      totalStars: 45,
      averageDailyMinutes: 49,
      favoriteZone: 'المدرسة',
      topSkill: 'القراءة',
    );
  }
}

/// نتيجة الخدمة
class ServiceResult {
  final bool success;
  final String message;
  final dynamic data;

  ServiceResult({
    required this.success,
    required this.message,
    this.data,
  });
}

/// إحصائيات الطفل
class ChildStats {
  final int totalMinutes;
  final int totalActivities;
  final int totalStars;
  final int averageDailyMinutes;
  final String favoriteZone;
  final String topSkill;

  ChildStats({
    required this.totalMinutes,
    required this.totalActivities,
    required this.totalStars,
    required this.averageDailyMinutes,
    required this.favoriteZone,
    required this.topSkill,
  });
}