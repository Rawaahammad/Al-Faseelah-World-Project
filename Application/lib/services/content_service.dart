import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_pack_model.dart';

class ContentService {
  static final ContentService _instance = ContentService._internal();
  factory ContentService() => _instance;
  ContentService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<ContentPack>> getContentPacks({String? category}) async {
    try {
      var query = _client.from('content_packs').select();

      if (category != null && category != 'الكل') {
        query = query.eq('category', category);
      }

      final rows = await query.order('created_at', ascending: false);
      return (rows as List<dynamic>)
          .map((row) => ContentPack.fromSupabase(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('[ContentService] getContentPacks error: $e');
      return [];
    }
  }

  Stream<List<ContentPack>> getContentPacksStream({String? category}) {
    return Stream.value([]);
  }

  /// Seeds demo rows if the table is empty (Supabase `content_packs`).
  Future<void> seedInitialContent() async {
    try {
      final existing = await _client
          .from('content_packs')
          .select('id')
          .limit(1);
      if ((existing as List).isNotEmpty) return;

      final now = DateTime.now().toIso8601String();
      final initialPacks = <Map<String, dynamic>>[
        {
          'title': 'قصة الأرنب الصغير',
          'description':
              'قصة ممتعة عن أرنب صغير يتعلم قيمة الصداقة والمشاركة',
          'category': 'قصص',
          'age_range': '3-5 سنوات',
          'duration_minutes': 10,
          'rating': 4.8,
          'reviews_count': 156,
          'version': '1.0',
          'zone': 'منطقة القصص',
          'topics': ['الصداقة', 'المشاركة'],
          'skills': ['القراءة', 'الاستماع', 'القيم'],
          'is_offline_available': true,
          'is_new': false,
          'created_at': now,
        },
        {
          'title': 'تعلم الأرقام',
          'description':
              'نشاط تفاعلي لتعلم الأرقام من 1 إلى 10 بطريقة ممتعة',
          'category': 'تعليمي',
          'age_range': '4-6 سنوات',
          'duration_minutes': 15,
          'rating': 4.5,
          'reviews_count': 203,
          'version': '1.2',
          'zone': 'منطقة الأرقام',
          'topics': ['الأرقام', 'العد'],
          'skills': ['الحساب', 'التركيز'],
          'is_offline_available': true,
          'is_new': false,
          'created_at': now,
        },
        {
          'title': 'لعبة المزارع',
          'description':
              'ساعد المزارع في زراعة الخضروات والعناية بالحيوانات',
          'category': 'ألعاب',
          'age_range': '5-7 سنوات',
          'duration_minutes': 20,
          'rating': 4.9,
          'reviews_count': 89,
          'version': '1.0',
          'zone': 'منطقة المزرعة',
          'topics': ['الزراعة', 'الحيوانات'],
          'skills': ['التفكير المنطقي', 'المسؤولية'],
          'is_offline_available': false,
          'is_new': true,
          'created_at': now,
        },
        {
          'title': 'مساعدة الآخرين',
          'description':
              'تعلم قيمة مساعدة الآخرين من خلال مواقف يومية',
          'category': 'تربوي',
          'age_range': '3-6 سنوات',
          'duration_minutes': 12,
          'rating': 4.7,
          'reviews_count': 134,
          'version': '1.1',
          'zone': 'منطقة القيم',
          'topics': ['المساعدة', 'التعاون'],
          'skills': ['المهارات الاجتماعية', 'القيم'],
          'is_offline_available': true,
          'is_new': false,
          'created_at': now,
        },
        {
          'title': 'أشكال الحيوانات',
          'description': 'تعرف على الحيوانات وأصواتها بطريقة تفاعلية',
          'category': 'أنشطة',
          'age_range': '3-5 سنوات',
          'duration_minutes': 8,
          'rating': 4.6,
          'reviews_count': 178,
          'version': '1.0',
          'zone': 'منطقة الحيوانات',
          'topics': ['الحيوانات', 'الأصوات'],
          'skills': ['المعرفة', 'الاستماع'],
          'is_offline_available': false,
          'is_new': false,
          'created_at': now,
        },
        {
          'title': 'سورة الفاتحة',
          'description':
              'تعلم سورة الفاتحة مع التجويد بطريقة سهلة وممتعة',
          'category': 'ديني',
          'age_range': '4-7 سنوات',
          'duration_minutes': 10,
          'rating': 4.9,
          'reviews_count': 312,
          'version': '2.0',
          'zone': 'المنطقة الدينية',
          'topics': ['القرآن', 'التجويد'],
          'skills': ['الحفظ', 'التلاوة'],
          'is_offline_available': true,
          'is_new': false,
          'created_at': now,
        },
        {
          'title': 'الألوان السحرية',
          'description': 'اكتشف عالم الألوان وتعلم مزجها',
          'category': 'أنشطة',
          'age_range': '3-5 سنوات',
          'duration_minutes': 15,
          'rating': 4.4,
          'reviews_count': 98,
          'version': '1.0',
          'zone': 'منطقة الإبداع',
          'topics': ['الألوان', 'المزج'],
          'skills': ['الإبداع', 'التركيز'],
          'is_offline_available': false,
          'is_new': true,
          'created_at': now,
        },
        {
          'title': 'آداب الطعام',
          'description': 'تعلم آداب الطعام الإسلامية بأسلوب شيق',
          'category': 'تربوي',
          'age_range': '3-6 سنوات',
          'duration_minutes': 8,
          'rating': 4.6,
          'reviews_count': 145,
          'version': '1.0',
          'zone': 'منطقة القيم',
          'topics': ['الآداب', 'الطعام'],
          'skills': ['السلوك', 'القيم الإسلامية'],
          'is_offline_available': true,
          'is_new': false,
          'created_at': now,
        },
      ];

      await _client.from('content_packs').insert(initialPacks);
    } catch (e) {
      print('[ContentService] seedInitialContent error: $e');
    }
  }
}
