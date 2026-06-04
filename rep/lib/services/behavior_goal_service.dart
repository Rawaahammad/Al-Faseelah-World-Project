import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/behavior_goal_model.dart';
import 'child_service.dart';

class BehaviorGoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final BehaviorGoalService _instance = BehaviorGoalService._internal();
  factory BehaviorGoalService() => _instance;
  BehaviorGoalService._internal();

  CollectionReference<Map<String, dynamic>> get _goalsRef =>
      _firestore.collection('behavior_goals');

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<List<BehaviorGoal>> getGoalsForChild(String childId) async {
    try {
      if (_currentUserId == null) return [];

      final snapshot = await _goalsRef
          .where('childId', isEqualTo: childId)
          .where('parentId', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BehaviorGoal.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting behavior goals: $e');
      return [];
    }
  }

  Stream<List<BehaviorGoal>> getGoalsStream(String childId) {
    if (_currentUserId == null) return Stream.value([]);

    return _goalsRef
        .where('childId', isEqualTo: childId)
        .where('parentId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BehaviorGoal.fromFirestore(doc)).toList());
  }

  Future<ServiceResult> addGoal(BehaviorGoal goal) async {
    try {
      if (_currentUserId == null) {
        return ServiceResult(success: false, message: 'يجب تسجيل الدخول أولاً');
      }

      final goalData = goal.copyWith(parentId: _currentUserId).toJson();
      await _goalsRef.add(goalData);

      return ServiceResult(success: true, message: 'تم إضافة الهدف بنجاح');
    } catch (e) {
      return ServiceResult(success: false, message: 'حدث خطأ: $e');
    }
  }

  Future<ServiceResult> updateGoalProgress(String goalId, int newCount) async {
    try {
      final doc = await _goalsRef.doc(goalId).get();
      if (!doc.exists) {
        return ServiceResult(success: false, message: 'الهدف غير موجود');
      }

      final data = doc.data()!;
      final targetCount = data['targetCount'] ?? 1;
      final isCompleted = newCount >= targetCount;

      await _goalsRef.doc(goalId).update({
        'currentCount': newCount,
        'isCompleted': isCompleted,
        if (isCompleted) 'completedAt': Timestamp.now(),
      });

      return ServiceResult(
        success: true,
        message: isCompleted ? 'تم إكمال الهدف!' : 'تم تحديث التقدم',
      );
    } catch (e) {
      return ServiceResult(success: false, message: 'حدث خطأ: $e');
    }
  }

  Future<ServiceResult> deleteGoal(String goalId) async {
    try {
      await _goalsRef.doc(goalId).delete();
      return ServiceResult(success: true, message: 'تم حذف الهدف');
    } catch (e) {
      return ServiceResult(success: false, message: 'حدث خطأ: $e');
    }
  }
}
