import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/child_service.dart';
import '../models/child_model.dart';
import 'child_profile_screen.dart';
import 'connection_screen.dart';
import 'content_library_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ProgressScreen(),
    const ContentLibraryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa, color: Colors.white),
            const SizedBox(width: 8),
            const Text('عالم الفسيلة'),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      )
          : null,
      body: _screens[_currentIndex],
      bottomNavigationBar:  Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey. withOpacity(0.2),
              blurRadius: 10,
              offset:  const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex:  _currentIndex,
          onTap:  (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor:  Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight. bold,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons. home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon:  Icon(Icons.trending_up),
              label: 'التقدم',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons. library_books_outlined),
              activeIcon: Icon(Icons.library_books),
              label:  'المحتوى',
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'الحساب',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _authService = AuthService();
  final _childService = ChildService();
  
  UserData? _userData;
  List<Child> _children = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final userData = await _authService.getCurrentUserData();
    final children = await _childService.getChildren();
    
    if (mounted) {
      setState(() {
        _userData = userData;
        _children = children;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),

            _buildConnectionStatus(context),
            const SizedBox(height: 24),

            // الإجراءات السريعة
            const Text(
              'الإجراءات السريعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // شبكة الإجراءات
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
              children:  [
                _buildActionCard(
                  context,
                  icon: Icons.child_care,
                  title:  'ملف الطفل',
                  subtitle: 'إدارة بيانات الأطفال',
                  color: const Color(0xFF87CEEB),
                  onTap: () {
                    Navigator. pushNamed(context, '/child-profile');
                  },
                ),
                _buildActionCard(
                  context,
                  icon:  Icons.assessment,
                  title: 'التقارير',
                  subtitle: 'تقدم التعلم',
                  color: const Color(0xFF90EE90),
                  onTap: () {
                    Navigator.pushNamed(context, '/progress');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.wifi,
                  title:  'الاتصال',
                  subtitle: 'توصيل اللعبة',
                  color: const Color(0xFF98D8AA),
                  onTap:  () {
                    Navigator.pushNamed(context, '/connection');
                  },
                ),
                _buildActionCard(
                  context,
                  icon:  Icons.library_books,
                  title: 'المحتوى',
                  subtitle:  'مكتبة التعليم',
                  color: const Color(0xFFFFB74D),
                  onTap: () {
                    Navigator. pushNamed(context, '/library');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.flag,
                  title: 'أهداف السلوك',
                  subtitle: 'تحديد الأهداف',
                  color: const Color(0xFFBA68C8),
                  onTap: () {
                    Navigator.pushNamed(context, '/behavior-goals');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.analytics,
                  title: 'التقارير الذكية',
                  subtitle: 'تحليل التقدم',
                  color: const Color(0xFF4DD0E1),
                  onTap: () {
                    Navigator.pushNamed(context, '/ai-reports');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // آخر النشاطات
            _buildRecentActivities(context),

            const SizedBox(height: 24),

            // نصائح تربوية
            _buildTipsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final childName = _children.isNotEmpty ? _children.first.name : 'طفلك';
    final userName = _userData?.name ?? 'المستخدم';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFF90EE90)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF87CEEB).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً $userName!  👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _children.isNotEmpty ? '${_children.first.name} مستعد للعب!' : 'أضف طفلك للبدء',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding:  const EdgeInsets. symmetric(horizontal: 16, vertical: 10),
            decoration:  BoxDecoration(
              color: Colors. white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWelcomeStatItem('45', 'دقيقة اليوم'),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white. withOpacity(0.5),
                ),
                _buildWelcomeStatItem('3', 'أنشطة مكتملة'),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.5),
                ),
                _buildWelcomeStatItem('⭐', 'نجمة جديدة'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize:  18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white. withOpacity(0.9),
            fontSize:  12,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:  BoxDecoration(
                color: const Color(0xFF90EE90).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons. check_circle,
                color: Color(0xFF90EE90),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اللعبة متصلة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:  FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Al-Faseelah-001',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/connection');
              },
              child: const Text('التفاصيل'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    final List<Map<String, dynamic>> activities = [];
    
    if (_children.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر النشاطات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد نشاطات بعد',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قم بإضافة طفل وابدأ استخدام التطبيق',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'آخر النشاطات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activities.map((activity) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child:  ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:  (activity['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius. circular(8),
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
              ),
            ),
            title: Text(
              activity['title'] as String,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              activity['time'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Card(
      child:  Container(
        padding:  const EdgeInsets. all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius. circular(16),
          gradient: LinearGradient(
            colors:  [
              const Color(0xFF90EE90).withOpacity(0.1),
              const Color(0xFF87CEEB).withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment. start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFFFB74D),
                ),
                const SizedBox(width: 8),
                const Text(
                  'نصيحة اليوم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'شجعي طفلك على استكشاف منطقة المزرعة الجديدة!  تحتوي على أنشطة رائعة لتعلم أسماء الحيوانات وأصواتها.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}