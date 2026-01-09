import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_card.dart';

/// شاشة تفاصيل نشاط الطفل
class ChildActivityDetailScreen extends StatelessWidget {
  final String?  sessionId;

  const ChildActivityDetailScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('تفاصيل الجلسة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري مشاركة التقرير.. .')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSessionHeader(context),
            const SizedBox(height: 24),
            _buildZonesVisited(context),
            const SizedBox(height: 24),
            _buildCompletedActivities(context),
            const SizedBox(height:  24),
            _buildBehaviorAnalysis(context),
            const SizedBox(height: 24),
            _buildAIInsights(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.transparent,
                  child: Text('👧', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width:  16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سارة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'اليوم - 4: 30 مساءً',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  const Text(
                  '45 دقيقة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat('🎯', '5', 'أنشطة'),
              _buildHeaderStat('⭐', '3', 'نجوم'),
              _buildHeaderStat('📍', '3', 'مناطق'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style:  const TextStyle(
            fontSize:  20,
            fontWeight:  FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildZonesVisited(BuildContext context) {
    final zones = [
      {'name':  'المنزل', 'icon': Icons.home, 'time': '15 دقيقة', 'color': AppColors.skyBlue},
      {'name':  'المدرسة', 'icon': Icons.school, 'time': '20 دقيقة', 'color': AppColors.lightGreen},
      {'name':  'المسجد', 'icon':  Icons.mosque, 'time': '10 دقيقة', 'color': AppColors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المناطق التي زارها',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height:  12),
        Row(
          children: zones.map((zone) {
            return Expanded(
              child: Card(
                child:  Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (zone['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          zone['icon'] as IconData,
                          color: zone['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        zone['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        zone['time'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompletedActivities(BuildContext context) {
    final activities = [
      {'title': 'قصة الأرنب الصغير', 'type': 'قصة', 'result': 'مكتمل', 'icon': Icons.auto_stories},
      {'title':  'تعلم الألوان', 'type': 'نشاط تعليمي', 'result': 'نجمتان', 'icon': Icons. palette},
      {'title': 'سورة الفاتحة', 'type': 'تعليم ديني', 'result': 'مكتمل', 'icon': Icons. mosque},
      {'title': 'الأرقام من 1-10', 'type': 'حساب', 'result': 'نجمة واحدة', 'icon':  Icons.calculate},
      {'title': 'تنظيف الغرفة', 'type': 'مهارة يومية', 'result': 'مكتمل', 'icon': Icons.cleaning_services},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأنشطة المكتملة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ... activities.map((activity) {
          return ActivityCard(
            icon: activity['icon'] as IconData,
            title: activity['title'] as String,
            subtitle: activity['type'] as String,
            trailing: activity['result'] as String,
            color: AppColors.skyBlue,
          );
        }),
      ],
    );
  }

  Widget _buildBehaviorAnalysis(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology, color: AppColors. purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تحليل السلوك',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBehaviorItem('المزاج العام', 'سعيد ومتحمس', '😊', AppColors.orange),
            _buildBehaviorItem('مستوى التركيز', 'عالي جداً', '🎯', AppColors.lightGreen),
            _buildBehaviorItem('سرعة الاستجابة', 'سريعة', '⚡', AppColors.skyBlue),
            _buildBehaviorItem('التفاعل مع الأنشطة', 'ممتاز', '🌟', AppColors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorItem(String title, String value, String emoji, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight. w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsights(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors:  [
              AppColors.lightGreen.withOpacity(0.1),
              AppColors. skyBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.orange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'رؤى الذكاء الاصطناعي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius. circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 ملاحظات اليوم: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• سارة أظهرت اهتماماً كبيراً بالقصص اليوم\n'
                        '• تحسن ملحوظ في التعرف على الألوان\n'
                        '• تفاعلت بشكل إيجابي مع الأنشطة الدينية',
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'اقتراح:  جربي نشاط "عالم الحيوانات" غداً، سارة ستحبه!',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}