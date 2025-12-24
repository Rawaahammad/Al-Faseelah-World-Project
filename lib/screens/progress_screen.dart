import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedPeriod = 'أسبوعي';
  String _selectedChild = 'سارة';

  final List<String> _periods = ['يومي', 'أسبوعي', 'شهري', 'فصلي'];
  final List<String> _children = ['سارة', 'أحمد'];

  final Map<String, dynamic> progressData = {
    'totalMinutes': 345,
    'averageDaily': 49,
    'completedActivities': 23,
    'earnedStars': 45,
    'dailyProgress': [
      {'day': 'السبت', 'minutes': 45, 'activities': 3},
      {'day': 'الأحد', 'minutes':  60, 'activities': 4},
      {'day': 'الإثنين', 'minutes': 30, 'activities': 2},
      {'day': 'الثلاثاء', 'minutes':  55, 'activities': 4},
      {'day': 'الأربعاء', 'minutes': 40, 'activities': 3},
      {'day': 'الخميس', 'minutes': 65, 'activities': 5},
      {'day': 'الجمعة', 'minutes': 50, 'activities':  4},
    ],
    'skills': [
      {'name': 'القراءة', 'progress': 80, 'trend': 'up', 'change': '+5%', 'icon': Icons.menu_book},
      {'name': 'الحساب', 'progress': 65, 'trend': 'up', 'change': '+3%', 'icon': Icons.calculate},
      {'name': 'التواصل', 'progress': 70, 'trend': 'stable', 'change': '0%', 'icon': Icons.chat},
      {'name': 'التركيز', 'progress':  85, 'trend': 'up', 'change': '+8%', 'icon': Icons.psychology},
      {'name':  'الإبداع', 'progress': 75, 'trend': 'up', 'change': '+2%', 'icon': Icons.brush},
    ],
    'achievements': [
      {'title': 'القارئ الصغير', 'description': 'أكمل 10 قصص', 'icon': Icons.auto_stories, 'date': '15 يناير 2024', 'color': const Color(0xFF87CEEB)},
      {'title': 'عالم الأرقام', 'description': 'أتقن الأرقام من 1-20', 'icon': Icons. calculate, 'date': '12 يناير 2024', 'color': const Color(0xFF90EE90)},
      {'title': 'المستكشف', 'description':  'زار جميع مناطق اللعبة', 'icon': Icons.explore, 'date': '10 يناير 2024', 'color': const Color(0xFFFFB74D)},
      {'title': 'الصديق المتعاون', 'description': 'شارك في 5 أنشطة جماعية', 'icon': Icons.people, 'date': '8 يناير 2024', 'color': const Color(0xFFBA68C8)},
    ],
    'recentSessions':  [
      {'date': 'اليوم', 'duration': '45 دقيقة', 'activities': ['قصة الأرنب', 'تعلم الألوان'], 'mood': 'سعيد', 'focus': 'عالي'},
      {'date': 'أمس', 'duration': '60 دقيقة', 'activities': ['الأرقام', 'لعبة المزرعة', 'سورة الفاتحة'], 'mood': 'متحمس', 'focus': 'ممتاز'},
      {'date': 'قبل يومين', 'duration': '35 دقيقة', 'activities': ['قصة النملة', 'الأشكال'], 'mood': 'هادئ', 'focus':  'جيد'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير التقدم'),
        actions: [
          IconButton(
            icon: const Icon(Icons. share),
            onPressed: () => _showShareOptions(),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed:  () => _downloadReport(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(),
              const SizedBox(height: 20),
              _buildStatsSummary(),
              const SizedBox(height: 24),
              _buildUsageChart(),
              const SizedBox(height: 24),
              _buildSkillsProgress(),
              const SizedBox(height: 24),
              _buildAchievements(),
              const SizedBox(height:  24),
              _buildRecentSessions(),
              const SizedBox(height: 24),
              _buildAIRecommendations(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding:  const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.child_care, color: Color(0xFF87CEEB)),
                const SizedBox(width: 12),
                const Text('الطفل:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedChild,
                        isExpanded: true,
                        items:  _children.map((child) {
                          return DropdownMenuItem(value: child, child: Text(child));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedChild = value! ;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:  _periods.map((period) {
                  final isSelected = _selectedPeriod == period;
                  return Padding(
                    padding: const EdgeInsets. only(left: 8),
                    child: ChoiceChip(
                      label: Text(period),
                      selected:  isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors. white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.timer,
            value: '${progressData['totalMinutes']}',
            label: 'دقيقة إجمالي',
            color: const Color(0xFF87CEEB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            value: '${progressData['completedActivities']}',
            label: 'نشاط مكتمل',
            color: const Color(0xFF90EE90),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            value: '${progressData['earnedStars']}',
            label: 'نجمة',
            color: const Color(0xFFFFB74D),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding:  const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color. withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child:  Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style:  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors. grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageChart() {
    final dailyProgress = progressData['dailyProgress'] as List;
    final maxMinutes = dailyProgress. map((d) => d['minutes'] as int).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الاستخدام الأسبوعي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90EE90).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize:  MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, size: 16, color: Color(0xFF90EE90)),
                      const SizedBox(width: 4),
                      Text(
                        'معدل ${progressData['averageDaily']} د/يوم',
                        style: const TextStyle(
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
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: dailyProgress.map((day) {
                  final percentage = (day['minutes'] as int) / maxMinutes;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${day['minutes']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: 120 * percentage,
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF87CEEB),
                              const Color(0xFF90EE90),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        day['day']. toString().substring(0, 3),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsProgress() {
    final skills = progressData['skills'] as List;
    final skillColors = [
      const Color(0xFF87CEEB),
      const Color(0xFF90EE90),
      const Color(0xFFFFB74D),
      const Color(0xFFBA68C8),
      const Color(0xFF4DD0E1),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تقدم المهارات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight. bold),
            ),
            const SizedBox(height: 20),
            ...skills.asMap().entries.map((entry) {
              final index = entry. key;
              final skill = entry.value;
              final color = skillColors[index % skillColors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color. withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(skill['icon'] as IconData, size: 18, color: color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            skill['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical:  4),
                          decoration:  BoxDecoration(
                            color: skill['trend'] == 'up'
                                ? const Color(0xFF90EE90).withOpacity(0.15)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize:  MainAxisSize.min,
                            children: [
                              Icon(
                                skill['trend'] == 'up'
                                    ? Icons.trending_up
                                    : Icons.trending_flat,
                                size: 14,
                                color: skill['trend'] == 'up'
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width:  4),
                              Text(
                                skill['change'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: skill['trend'] == 'up'
                                      ? const Color(0xFF2E7D32)
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${skill['progress']}%',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius:  BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value:  skill['progress'] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = progressData['achievements'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            const Text(
              'الإنجازات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _showAllAchievements(),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView. builder(
            scrollDirection:  Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                width: 130,
                margin: const EdgeInsets.only(left: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (achievement['color'] as Color).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            achievement['icon'] as IconData,
                            color: achievement['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          achievement['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement['date'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors. grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSessions() {
    final sessions = progressData['recentSessions'] as List;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الجلسات الأخيرة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:  16),
            ...sessions.map((session) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Color(0xFF87CEEB)),
                            const SizedBox(width: 6),
                            Text(
                              session['date'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 16, color:  Color(0xFF90EE90)),
                            const SizedBox(width: 4),
                            Text(
                              session['duration'],
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing:  6,
                      children:  (session['activities'] as List).map((activity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF87CEEB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activity,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildSessionTag('المزاج:  ${session['mood']}', Icons.emoji_emotions, const Color(0xFFFFB74D)),
                        const SizedBox(width: 12),
                        _buildSessionTag('التركيز: ${session['focus']}', Icons.psychology, const Color(0xFFBA68C8)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTag(String text, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAIRecommendations() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF90EE90).withOpacity(0.1),
              const Color(0xFF87CEEB).withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets. all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA68C8).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Color(0xFFBA68C8)),
                ),
                const SizedBox(width: 12),
                const Text(
                  'توصيات الذكاء الاصطناعي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              icon: Icons.trending_up,
              title: 'تحسن ملحوظ في القراءة',
              description:  'سارة أظهرت تقدماً كبيراً في مهارات القراءة.  ننصح بزيادة مستوى صعوبة القصص.',
              color: const Color(0xFF90EE90),
            ),
            const Divider(height: 24),
            _buildRecommendationItem(
              icon: Icons.lightbulb,
              title:  'اقتراح نشاط جديد',
              description: 'بناءً على اهتمامات سارة، جرّبي نشاط "عالم الفضاء" الجديد.',
              color: const Color(0xFFFFB74D),
            ),
            const Divider(height: 24),
            _buildRecommendationItem(
              icon: Icons. schedule,
              title: 'أفضل وقت للعب',
              description: 'سارة تُظهر أعلى تركيز بين الساعة 4-6 مساءً.',
              color: const Color(0xFF87CEEB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context:  context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'مشاركة التقرير',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chat, color: Color(0xFF25D366)),
                ),
                title: const Text('واتساب'),
                onTap: () {
                  Navigator.pop(context);
                  _showShareSuccess();
                },
              ),
              ListTile(
                leading: Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DA1F2).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.email, color: Color(0xFF1DA1F2)),
                ),
                title: const Text('البريد الإلكتروني'),
                onTap:  () {
                  Navigator.pop(context);
                  _showShareSuccess();
                },
              ),
              ListTile(
                leading: Container(
                  padding:  const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey. withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy, color: Colors.grey),
                ),
                title: const Text('نسخ الرابط'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الرابط')),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showShareSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content:  Text('تم مشاركة التقرير بنجاح')),
    );
  }

  void _downloadReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red),
            SizedBox(width: 8),
            Text('تحميل التقرير'),
          ],
        ),
        content: const Text('سيتم تحميل تقرير مفصل بصيغة PDF يحتوي على:\n\n• ملخص الاستخدام\n• تقدم المهارات\n• الإنجازات\n• التوصيات'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content:  Text('جاري تحميل التقرير.. .')),
              );
            },
            child: const Text('تحميل'),
          ),
        ],
      ),
    );
  }

  void _showAllAchievements() {
    final achievements = progressData['achievements'] as List;

    showModalBottomSheet(
      context:  context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color:  Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'جميع الإنجازات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading:  Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (achievement['color'] as Color).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                achievement['icon'] as IconData,
                                color: achievement['color'] as Color,
                              ),
                            ),
                            title: Text(
                              achievement['title'],
                              style:  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(achievement['description']),
                            trailing: Text(
                              achievement['date'],
                              style: TextStyle(fontSize: 12, color: Colors. grey[500]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}