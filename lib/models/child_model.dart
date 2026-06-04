/// نموذج بيانات الطفل
class Child {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String avatar;
  final List<String> interests;
  final DateTime createdAt;
  final String? parentId;
  /// Parent-written focus areas / suggestions; persisted in Supabase `parent_notes`.
  final String? parentNotes;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.avatar,
    required this.interests,
    required this.createdAt,
    this.parentId,
    this.parentNotes,
  });

  static DateTime _parseCreatedAt(dynamic raw) {
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// إنشاء من JSON
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 5,
      gender: json['gender'] ?? 'ذكر',
      avatar: json['avatar'] ?? '👦',
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: _parseCreatedAt(json['createdAt']),
      parentId: json['parentId'] as String?,
      parentNotes: json['parentNotes'] as String?,
    );
  }

  /// تحويل إلى JSON (عميل / تخزين مؤقت)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'avatar': avatar,
      'interests': interests,
      'createdAt': createdAt.toIso8601String(),
      'parentId': parentId,
      'parentNotes': parentNotes,
    };
  }

  /// نسخة معدلة
  Child copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? avatar,
    List<String>? interests,
    DateTime? createdAt,
    String? parentId,
    String? parentNotes,
    bool clearParentNotes = false,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
      parentNotes:
          clearParentNotes ? null : (parentNotes ?? this.parentNotes),
    );
  }
}
