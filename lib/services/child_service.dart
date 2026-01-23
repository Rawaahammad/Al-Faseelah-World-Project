import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/child_model.dart';
import '../models/session_model.dart';
import '../models/activity_model.dart';

/// خدمة إدارة الأطفال مع Firestore
class ChildService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Singleton pattern
  static final ChildService _instance = ChildService._internal();
  factory ChildService() => _instance;
  ChildService._internal();

  // مرجع مجموعة الأطفال
  CollectionReference<Map<String, dynamic>> get _childrenRef =>
      _firestore.collection('children');

  /// الحصول على معرف المستخدم الحالي
  String? get _currentUserId => _auth.currentUser?.uid;

  /// الحصول على قائمة الأطفال للمستخدم الحالي
  Future<List<Child>> getChildren() async {
    try {
      if (_currentUserId == null) return [];

      // للاختبار: جلب جميع الأطفال بدون فلتر
      final querySnapshot = await _childrenRef
          .orderBy('createdAt', descending: true)
          .get();

      print('Found ${querySnapshot.docs.length} children'); // للتتبع
      print('Current user ID: $_currentUserId'); // للتتبع

      return querySnapshot.docs
          .map((doc) => Child.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting children: $e');
      return [];
    }
  }

  /// Stream للاستماع لتغييرات قائمة الأطفال
  Stream<List<Child>> getChildrenStream() {
    if (_currentUserId == null) return Stream.value([]);

    return _childrenRef
        .where('parentId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Child.fromFirestore(doc))
            .toList());
  }

  /// الحصول على طفل بالـ ID
  Future<Child?> getChildById(String id) async {
    try {
      final doc = await _childrenRef.doc(id).get();
      if (doc.exists) {
        return Child.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting child: $e');
      return null;
    }
  }

  /// إضافة طفل جديد
  Future<ServiceResult> addChild(Child child) async {
    try {
      if (_currentUserId == null) {
        return ServiceResult(
          success: false,
          message: 'يجب تسجيل الدخول أولاً',
        );
      }

      // إنشاء الطفل مع معرف الوالد
      final newChildData = child.copyWith(
        parentId: _currentUserId,
        createdAt: DateTime.now(),
      ).toJson();

      final docRef = await _childrenRef.add(newChildData);
      
      // جلب الطفل المضاف مع ID
      final addedChild = child.copyWith(
        id: docRef.id,
        parentId: _currentUserId,
        createdAt: DateTime.now(),
      );

      return ServiceResult(
        success: true,
        message: 'تم إضافة ${child.name} بنجاح',
        data: addedChild,
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// تحديث بيانات طفل
  Future<ServiceResult> updateChild(Child child) async {
    try {
      await _childrenRef.doc(child.id).update(child.toJson());
      
      return ServiceResult(
        success: true,
        message: 'تم تحديث البيانات بنجاح',
        data: child,
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  /// حذف طفل
  Future<ServiceResult> deleteChild(String id) async {
    try {
      await _childrenRef.doc(id).delete();
      
      // حذف الجلسات والنشاطات المرتبطة
      final sessionsQuery = await _firestore
          .collection('sessions')
          .where('childId', isEqualTo: id)
          .get();
      
      for (var doc in sessionsQuery.docs) {
        await doc.reference.delete();
      }

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
    try {
      final querySnapshot = await _firestore
          .collection('sessions')
          .where('childId', isEqualTo: childId)
          .orderBy('startTime', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Session(
          id: doc.id,
          childId: data['childId'] ?? '',
          startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
          endTime: (data['endTime'] as Timestamp?)?.toDate(),
          totalMinutes: data['totalMinutes'] ?? 0,
          activities: (data['activities'] as List<dynamic>?)
              ?.map((a) => Activity(
                    id: a['id'] ?? '',
                    title: a['title'] ?? '',
                    type: a['type'] ?? '',
                    zone: a['zone'] ?? '',
                    duration: a['duration'] ?? 0,
                    result: a['result'] ?? '',
                    starsEarned: a['starsEarned'] ?? 0,
                    completedAt: (a['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  ))
              .toList() ?? [],
          zonesVisited: Map<String, int>.from(data['zonesVisited'] ?? {}),
          mood: data['mood'] ?? '',
          focusLevel: data['focusLevel'] ?? '',
          starsEarned: data['starsEarned'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Error getting sessions: $e');
      return [];
    }
  }

  /// الحصول على إحصائيات طفل
  Future<ChildStats> getChildStats(String childId) async {
    try {
      // جلب الجلسات لحساب الإحصائيات
      final sessionsQuery = await _firestore
          .collection('sessions')
          .where('childId', isEqualTo: childId)
          .get();

      int totalMinutes = 0;
      int totalActivities = 0;
      int totalStars = 0;
      Map<String, int> zonesCounts = {};

      for (var doc in sessionsQuery.docs) {
        final data = doc.data();
        totalMinutes += (data['totalMinutes'] ?? 0) as int;
        totalStars += (data['starsEarned'] ?? 0) as int;
        
        final activities = data['activities'] as List<dynamic>? ?? [];
        totalActivities += activities.length;

        final zones = Map<String, int>.from(data['zonesVisited'] ?? {});
        zones.forEach((zone, count) {
          zonesCounts[zone] = (zonesCounts[zone] ?? 0) + count;
        });
      }

      // حساب المعدل اليومي (آخر 7 أيام)
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final recentSessionsQuery = await _firestore
          .collection('sessions')
          .where('childId', isEqualTo: childId)
          .where('startTime', isGreaterThan: Timestamp.fromDate(weekAgo))
          .get();

      int weeklyMinutes = 0;
      for (var doc in recentSessionsQuery.docs) {
        weeklyMinutes += (doc.data()['totalMinutes'] ?? 0) as int;
      }
      int averageDailyMinutes = (weeklyMinutes / 7).round();

      // المنطقة المفضلة
      String favoriteZone = 'غير محدد';
      if (zonesCounts.isNotEmpty) {
        favoriteZone = zonesCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
      }

      return ChildStats(
        totalMinutes: totalMinutes,
        totalActivities: totalActivities,
        totalStars: totalStars,
        averageDailyMinutes: averageDailyMinutes,
        favoriteZone: favoriteZone,
        topSkill: 'التعلم',
      );
    } catch (e) {
      print('Error getting stats: $e');
      return ChildStats(
        totalMinutes: 0,
        totalActivities: 0,
        totalStars: 0,
        averageDailyMinutes: 0,
        favoriteZone: 'غير محدد',
        topSkill: 'التعلم',
      );
    }
  }

  /// حفظ جلسة جديدة
  Future<ServiceResult> saveSession(Session session) async {
    try {
      await _firestore.collection('sessions').add({
        'childId': session.childId,
        'startTime': Timestamp.fromDate(session.startTime),
        'endTime': session.endTime != null ? Timestamp.fromDate(session.endTime!) : null,
        'totalMinutes': session.totalMinutes,
        'activities': session.activities.map((a) => {
          'id': a.id,
          'title': a.title,
          'type': a.type,
          'zone': a.zone,
          'duration': a.duration,
          'result': a.result,
          'starsEarned': a.starsEarned,
          'completedAt': Timestamp.fromDate(a.completedAt),
        }).toList(),
        'zonesVisited': session.zonesVisited,
        'mood': session.mood,
        'focusLevel': session.focusLevel,
        'starsEarned': session.starsEarned,
      });

      return ServiceResult(
        success: true,
        message: 'تم حفظ الجلسة بنجاح',
      );
    } catch (e) {
      return ServiceResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
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
