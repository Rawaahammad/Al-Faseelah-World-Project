import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory ContentPack.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContentPack(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      ageRange: data['ageRange'] ?? '3-7',
      durationMinutes: data['durationMinutes'] ?? 10,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      version: data['version'] ?? '1.0',
      zone: data['zone'] ?? '',
      topics: List<String>.from(data['topics'] ?? []),
      skills: List<String>.from(data['skills'] ?? []),
      isOfflineAvailable: data['isOfflineAvailable'] ?? false,
      isNew: data['isNew'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
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
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
