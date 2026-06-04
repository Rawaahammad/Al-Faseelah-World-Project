class ContentPack {
  final String id;
  final String title;
  final String description;
  final String category;
  final String ageRange;
  final int durationMinutes;
  final double rating;
  final int reviewsCount;
  final String version;
  final String zone;
  final List<String> topics;
  final List<String> skills;
  final bool isOfflineAvailable;
  final bool isNew;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ContentPack({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ageRange,
    required this.durationMinutes,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.version = '1.0',
    this.zone = '',
    this.topics = const [],
    this.skills = const [],
    this.isOfflineAvailable = false,
    this.isNew = false,
    required this.createdAt,
    this.updatedAt,
  });

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  factory ContentPack.fromSupabase(Map<String, dynamic> row) {
    return ContentPack(
      id: row['id']?.toString() ?? '',
      title: row['title']?.toString() ?? '',
      description: row['description']?.toString() ?? '',
      category: row['category']?.toString() ?? '',
      ageRange: row['age_range']?.toString() ?? '3-7',
      durationMinutes: (row['duration_minutes'] is num)
          ? (row['duration_minutes'] as num).round()
          : int.tryParse('${row['duration_minutes']}') ?? 10,
      rating: (row['rating'] is num) ? (row['rating'] as num).toDouble() : 0.0,
      reviewsCount: (row['reviews_count'] is num)
          ? (row['reviews_count'] as num).round()
          : int.tryParse('${row['reviews_count']}') ?? 0,
      version: row['version']?.toString() ?? '1.0',
      zone: row['zone']?.toString() ?? '',
      topics: List<String>.from(row['topics'] ?? const []),
      skills: List<String>.from(row['skills'] ?? const []),
      isOfflineAvailable: row['is_offline_available'] == true,
      isNew: row['is_new'] == true,
      createdAt: _parseDate(row['created_at']),
      updatedAt: row['updated_at'] != null ? _parseDate(row['updated_at']) : null,
    );
  }

  Map<String, dynamic> toSupabaseInsert() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'age_range': ageRange,
      'duration_minutes': durationMinutes,
      'rating': rating,
      'reviews_count': reviewsCount,
      'version': version,
      'zone': zone,
      'topics': topics,
      'skills': skills,
      'is_offline_available': isOfflineAvailable,
      'is_new': isNew,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'ageRange': ageRange,
      'durationMinutes': durationMinutes,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'version': version,
      'zone': zone,
      'topics': topics,
      'skills': skills,
      'isOfflineAvailable': isOfflineAvailable,
      'isNew': isNew,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
