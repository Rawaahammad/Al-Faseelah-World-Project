import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviorGoal {
  final String id;
  final String childId;
  final String parentId;
  final String title;
  final String description;
  final String zone;
  final String targetBehavior;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  BehaviorGoal({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.title,
    required this.description,
    this.zone = '',
    required this.targetBehavior,
    this.targetCount = 1,
    this.currentCount = 0,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  double get progressPercent {
    if (targetCount <= 0) return 0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }

  factory BehaviorGoal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BehaviorGoal(
      id: doc.id,
      childId: data['childId'] ?? '',
      parentId: data['parentId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      zone: data['zone'] ?? '',
      targetBehavior: data['targetBehavior'] ?? '',
      targetCount: data['targetCount'] ?? 1,
      currentCount: data['currentCount'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'parentId': parentId,
      'title': title,
      'description': description,
      'zone': zone,
      'targetBehavior': targetBehavior,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  BehaviorGoal copyWith({
    String? id,
    String? childId,
    String? parentId,
    String? title,
    String? description,
    String? zone,
    String? targetBehavior,
    int? targetCount,
    int? currentCount,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return BehaviorGoal(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      zone: zone ?? this.zone,
      targetBehavior: targetBehavior ?? this.targetBehavior,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
