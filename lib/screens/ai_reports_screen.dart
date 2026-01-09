import 'package:flutter/material.dart';

/// شاشة التقارير الذكية
class AIReportsScreen extends StatefulWidget {
  const AIReportsScreen({super.key});

  @override
  State<AIReportsScreen> createState() => _AIReportsScreenState();
}

class _AIReportsScreenState extends State<AIReportsScreen> {
  String _selectedChild = 'سارة';
  final List<String> _children = ['سارة', 'أحمد'];

  // ألوان التطبيق
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color lightGreen = Color(0xFF90EE90);
  static const Color orange = Color(0xFFFFB74D);
  static const Color purple = Color(0xFFBA68C8);
  static const Color cyan = Color(0xFF4DD0E1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('التقارير الذكية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري مشاركة التقرير...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحميل التقرير.. .')),
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
            _buildChildSelector(),
            const SizedBox(height: 24),
            _buildWeeklySummary(),
            const SizedBox(height: 24),
            _buildSkillsAnalysis(),
            const SizedBox(height: 24),
            _buildBehaviorPatterns(),
            const SizedBox(height:  24),
            _buildEducationalRecommendations(),
            const SizedBox(height: 24),
            _buildOptimalLearningTimes(),
            const SizedBox(height: 24),
            _buildProgressComparison(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// اختيار الطفل
  Widget _buildChildSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height:  50,
              decoration: BoxDecoration(
                color: skyBlue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _selectedChild == 'سارة' ? '👧' :  '👦',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:  _selectedChild,
                  isExpanded: true,
                  items: _children.map((child) {
                    return DropdownMenuItem(
                      value:  child,
                      child: Text(
                        child,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight. bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedChild = value!;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: lightGreen),
                  SizedBox(width: 4),
                  Text(
                    'تحليل جديد',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  /// ملخص الأسبوع
  Widget _buildWeeklySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [skyBlue, lightGreen],
          begin: Alignment.topLeft,
          end: Alignment. bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow:  [
          BoxShadow(
            color: skyBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.summarize, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'ملخص الأسبوع',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'أظهرت سارة تقدماً ملحوظاً هذا الأسبوع في مهارات القراءة والتواصل.  '
                'كانت الجلسات أطول وأكثر تركيزاً مقارنة بالأسبوع الماضي.',
            style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height:  16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('⏱️', '5.2 ساعة', 'إجمالي اللعب'),
              _buildSummaryItem('📈', '+15%', 'نمو المهارات'),
              _buildSummaryItem('🌟', '12', 'نجوم جديدة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight. bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  /// تحليل المهارات
  Widget _buildSkillsAnalysis() {
    final skills = [
      {'name': 'القراءة والاستماع', 'progress': 85, 'trend': '+8%', 'color': skyBlue, 'icon': Icons.menu_book},
      {'name': 'المهارات الاجتماعية', 'progress': 72, 'trend':  '+5%', 'color':  lightGreen, 'icon':  Icons.people},
      {'name': 'التفكير المنطقي', 'progress': 68, 'trend':  '+3%', 'color':  orange, 'icon': Icons. psychology},
      {'name': 'الإبداع والخيال', 'progress': 90, 'trend': '+12%', 'color': purple, 'icon': Icons.brush},
      {'name': 'المهارات الحركية', 'progress': 75, 'trend': '+4%', 'color': cyan, 'icon': Icons.sports_handball},
    ];

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
                    color: purple. withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.analytics, color: purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تحليل المهارات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...skills.map((skill) => _buildSkillProgressBar(
              skill['name'] as String,
              skill['progress'] as int,
              skill['trend'] as String,
              skill['color'] as Color,
              skill['icon'] as IconData,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillProgressBar(String name, int progress, String trend, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color. withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lightGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, size: 14, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$progress%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  /// أنماط السلوك المكتشفة
  Widget _buildBehaviorPatterns() {
    final patterns = [
      {'emoji': '🎯', 'title': 'التركيز العالي', 'description': 'سارة تظهر أعلى مستويات التركيز عند سماع القصص', 'color': lightGreen},
      {'emoji':  '🎨', 'title': 'الميل للإبداع', 'description': 'تفضل الأنشطة التي تتيح لها التعبير عن نفسها', 'color':  purple},
      {'emoji': '🤝', 'title': 'التفاعل الاجتماعي', 'description': 'تستمتع بالأنشطة التي تحاكي التفاعل مع الآخرين', 'color': skyBlue},
      {'emoji':  '📚', 'title': 'حب التعلم', 'description':  'تطلب تكرار الأنشطة التعليمية بشكل متكرر', 'color':  orange},
    ];

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
                    color:  cyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology, color: cyan),
                ),
                const SizedBox(width: 12),
                const Text(
                  'أنماط السلوك المكتشفة',
                  style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...patterns.map((pattern) => _buildPatternItem(
              pattern['emoji'] as String,
              pattern['title'] as String,
              pattern['description'] as String,
              pattern['color'] as Color,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternItem(String emoji, String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight. bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// التوصيات التربوية
  Widget _buildEducationalRecommendations() {
    final recommendations = [
      {'icon': Icons.menu_book, 'title': 'القراءة التفاعلية', 'description': 'جربي قراءة القصص مع سارة وطرح أسئلة عن الشخصيات.  هذا يعزز مهارات التفكير النقدي.'},
      {'icon': Icons.group, 'title': 'اللعب الجماعي', 'description': 'شجعي سارة على اللعب مع أطفال آخرين لتطوير مهاراتها الاجتماعية.'},
      {'icon': Icons.schedule, 'title': 'روتين ثابت', 'description':  'حافظي على وقت لعب ثابت يومياً (4-6 مساءً) حيث تظهر سارة أفضل تركيز.'},
    ];

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors:  [
              orange.withOpacity(0.1),
              purple.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lightbulb, color: orange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'توصيات تربوية',
                  style: TextStyle(fontSize: 18, fontWeight:  FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map((rec) => _buildRecommendationItem(
              rec['icon'] as IconData,
              rec['title'] as String,
              rec['description'] as String,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius. circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: skyBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight. bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// أفضل أوقات التعلم
  Widget _buildOptimalLearningTimes() {
    final times = [
      {'emoji': '🌅', 'period': 'صباحاً', 'hours': '9-11', 'level': 'متوسط', 'color': orange},
      {'emoji': '☀️', 'period': 'ظهراً', 'hours': '1-3', 'level': 'منخفض', 'color': Colors.grey},
      {'emoji': '🌆', 'period': 'عصراً', 'hours':  '4-6', 'level': 'ممتاز', 'color':  lightGreen},
      {'emoji': '🌙', 'period': 'مساءً', 'hours':  '7-9', 'level': 'جيد', 'color': skyBlue},
    ];

    return Card(
      child:  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:  const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: skyBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.access_time, color: skyBlue),
                ),
                const SizedBox(width: 12),
                const Text(
                  'أفضل أوقات التعلم',
                  style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: times.map((time) => Expanded(
                child: _buildTimeBlock(
                  time['emoji'] as String,
                  time['period'] as String,
                  time['hours'] as String,
                  time['level'] as String,
                  time['color'] as Color,
                ),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: lightGreen),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'أفضل وقت للتعلم:  4: 00 - 6:00 مساءً',
                      style: TextStyle(fontWeight: FontWeight.w500),
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

  Widget _buildTimeBlock(String emoji, String period, String hours, String level, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            period,
            style:  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          Text(
            hours,
            style:  TextStyle(fontSize: 9, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius. circular(8),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// مقارنة التقدم
  Widget _buildProgressComparison() {
    final comparisons = [
      {'label': 'وقت اللعب', 'current': '5. 2 ساعة', 'previous': '4.5 ساعة', 'isUp': true},
      {'label':  'الأنشطة المكتملة', 'current': '28', 'previous': '22', 'isUp': true},
      {'label': 'مستوى التركيز', 'current': '85%', 'previous': '78%', 'isUp': true},
      {'label': 'النجوم المكتسبة', 'current': '12', 'previous': '9', 'isUp': true},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:  lightGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.compare_arrows, color: lightGreen),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'مقارنة التقدم',
                      style: TextStyle(fontSize:  18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'هذا الأسبوع vs الماضي',
                    style:  TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...comparisons.map((comp) => _buildComparisonRow(
              comp['label'] as String,
              comp['current'] as String,
              comp['previous'] as String,
              comp['isUp'] as bool,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String current, String previous, bool isUp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:  Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  current,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: skyBlue,
                  ),
                ),
                const Text(
                  'الحالي',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isUp
                  ? lightGreen.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUp ? Icons.trending_up : Icons.trending_down,
              size: 16,
              color: isUp ?  const Color(0xFF2E7D32) : Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  previous,
                  style:  TextStyle(
                    fontWeight:  FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const Text(
                  'السابق',
                  style: TextStyle(fontSize: 10, color:  Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}