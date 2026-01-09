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

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.avatar,
    required this.interests,
    required this. createdAt,
    this. parentId,
  });

  /// إنشاء من JSON
  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age:  json['age'] ?? 5,
      gender: json['gender'] ?? 'ذكر',
      avatar:  json['avatar'] ?? '👦',
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      parentId: json['parentId'],
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'avatar': avatar,
      'interests':  interests,
      'createdAt': createdAt.toIso8601String(),
      'parentId': parentId,
    };
  }

  /// نسخة معدلة
  Child copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? avatar,
    List<String>?  interests,
    DateTime? createdAt,
    String? parentId,
  }) {
    return Child(
      id: id ??  this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this. gender,
      avatar: avatar ??  this.avatar,
      interests: interests ?? this.interests,
      createdAt: createdAt ??  this.createdAt,
      parentId: parentId ?? this. parentId,
    );
  }
}