import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content_pack_model.dart';

class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final ContentService _instance = ContentService._internal();
  factory ContentService() => _instance;
  ContentService._internal();

  CollectionReference<Map<String, dynamic>> get _contentRef =>
      _firestore.collection('content_packs');

  Future<List<ContentPack>> getContentPacks({String? category}) async {
    try {
      Query<Map<String, dynamic>> query = _contentRef;

      if (category != null && category != 'الكل') {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => ContentPack.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting content packs: $e');
      return [];
    }
  }

  Stream<List<ContentPack>> getContentPacksStream({String? category}) {
    Query<Map<String, dynamic>> query = _contentRef;

    if (category != null && category != 'الكل') {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => ContentPack.fromFirestore(doc)).toList());
  }

  Future<void> seedInitialContent() async {
    final existing = await _contentRef.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final initialPacks = [
      {
        'title': 'قصة الأرنب الصغير',
        'description': 'قصة ممتعة عن أرنب صغير يتعلم قيمة الصداقة والمشاركة',
        'category': 'قصص',
        'ageRange': '3-5 سنوات',
        'durationMinutes': 10,
        'rating': 4.8,
        'reviewsCount': 156,
        'version': '1.0',
        'zone': 'منطقة القصص',
        'topics': ['الصداقة', 'المشاركة'],
        'skills': ['القراءة', 'الاستماع', 'القيم'],
        'isOfflineAvailable': true,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'تعلم الأرقام',
        'description': 'نشاط تفاعلي لتعلم الأرقام من 1 إلى 10 بطريقة ممتعة',
        'category': 'تعليمي',
        'ageRange': '4-6 سنوات',
        'durationMinutes': 15,
        'rating': 4.5,
        'reviewsCount': 203,
        'version': '1.2',
        'zone': 'منطقة الأرقام',
        'topics': ['الأرقام', 'العد'],
        'skills': ['الحساب', 'التركيز'],
        'isOfflineAvailable': true,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'لعبة المزارع',
        'description': 'ساعد المزارع في زراعة الخضروات والعناية بالحيوانات',
        'category': 'ألعاب',
        'ageRange': '5-7 سنوات',
        'durationMinutes': 20,
        'rating': 4.9,
        'reviewsCount': 89,
        'version': '1.0',
        'zone': 'منطقة المزرعة',
        'topics': ['الزراعة', 'الحيوانات'],
        'skills': ['التفكير المنطقي', 'المسؤولية'],
        'isOfflineAvailable': false,
        'isNew': true,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'مساعدة الآخرين',
        'description': 'تعلم قيمة مساعدة الآخرين من خلال مواقف يومية',
        'category': 'تربوي',
        'ageRange': '3-6 سنوات',
        'durationMinutes': 12,
        'rating': 4.7,
        'reviewsCount': 134,
        'version': '1.1',
        'zone': 'منطقة القيم',
        'topics': ['المساعدة', 'التعاون'],
        'skills': ['المهارات الاجتماعية', 'القيم'],
        'isOfflineAvailable': true,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'أشكال الحيوانات',
        'description': 'تعرف على الحيوانات وأصواتها بطريقة تفاعلية',
        'category': 'أنشطة',
        'ageRange': '3-5 سنوات',
        'durationMinutes': 8,
        'rating': 4.6,
        'reviewsCount': 178,
        'version': '1.0',
        'zone': 'منطقة الحيوانات',
        'topics': ['الحيوانات', 'الأصوات'],
        'skills': ['المعرفة', 'الاستماع'],
        'isOfflineAvailable': false,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'سورة الفاتحة',
        'description': 'تعلم سورة الفاتحة مع التجويد بطريقة سهلة وممتعة',
        'category': 'ديني',
        'ageRange': '4-7 سنوات',
        'durationMinutes': 10,
        'rating': 4.9,
        'reviewsCount': 312,
        'version': '2.0',
        'zone': 'المنطقة الدينية',
        'topics': ['القرآن', 'التجويد'],
        'skills': ['الحفظ', 'التلاوة'],
        'isOfflineAvailable': true,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'الألوان السحرية',
        'description': 'اكتشف عالم الألوان وتعلم مزجها',
        'category': 'أنشطة',
        'ageRange': '3-5 سنوات',
        'durationMinutes': 15,
        'rating': 4.4,
        'reviewsCount': 98,
        'version': '1.0',
        'zone': 'منطقة الإبداع',
        'topics': ['الألوان', 'المزج'],
        'skills': ['الإبداع', 'التركيز'],
        'isOfflineAvailable': false,
        'isNew': true,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'آداب الطعام',
        'description': 'تعلم آداب الطعام الإسلامية بأسلوب شيق',
        'category': 'تربوي',
        'ageRange': '3-6 سنوات',
        'durationMinutes': 8,
        'rating': 4.6,
        'reviewsCount': 145,
        'version': '1.0',
        'zone': 'منطقة القيم',
        'topics': ['الآداب', 'الطعام'],
        'skills': ['السلوك', 'القيم الإسلامية'],
        'isOfflineAvailable': true,
        'isNew': false,
        'createdAt': Timestamp.now(),
      },
    ];

    final batch = _firestore.batch();
    for (final pack in initialPacks) {
      batch.set(_contentRef.doc(), pack);
    }
    await batch.commit();
  }
}
