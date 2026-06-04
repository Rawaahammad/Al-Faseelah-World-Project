import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'مرحباً بك في عالم الفسيلة',
      description: 'تجربة تعليمية فريدة تجمع بين اللعب الملموس والذكاء الاصطناعي لتنمية مهارات طفلك',
      icon: Icons.spa,
      color: const Color(0xFF87CEEB),
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingItem(
      title: 'تعلم من خلال اللعب',
      description: 'أربع مناطق تعليمية:  المنزل، المدرسة، المسجد، ومنطقة متغيرة تتيح لطفلك استكشاف عوالم جديدة',
      icon: Icons.toys,
      color: const Color(0xFF90EE90),
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingItem(
      title: 'ذكاء اصطناعي متطور',
      description: 'يتعرف على طفلك ويتكيف مع احتياجاته، يقدم محتوى مخصص ويتابع تقدمه بشكل مستمر',
      icon: Icons. psychology,
      color: const Color(0xFFFFB74D),
      image: 'assets/images/onboarding3.png',
    ),
    OnboardingItem(
      title: 'تقارير ذكية للأهل',
      description: 'تابعي تقدم طفلك واحصلي على تقارير مفصلة وتوصيات مخصصة من الذكاء الاصطناعي',
      icon: Icons.assessment,
      color: const Color(0xFFBA68C8),
      image: 'assets/images/onboarding4.png',
    ),
    OnboardingItem(
      title: 'تحكم أبوي كامل',
      description: 'تحكمي في المحتوى، حددي وقت الاستخدام، واختاري المسار التعليمي المناسب لطفلك',
      icon: Icons.shield,
      color: const Color(0xFF4DD0E1),
      image: 'assets/images/onboarding5.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds:  300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds:  300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // زر التخطي
            _buildSkipButton(),

            // محتوى الصفحات
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_items[index]);
                },
              ),
            ),

            // مؤشرات الصفحات
            _buildPageIndicators(),

            // أزرار التنقل
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment. topLeft,
      child:  Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: _navigateToLogin,
          child:  Text(
            'تخطي',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment. center,
        children: [
          // الأيقونة مع تأثير متحرك
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder:  (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: item.color. withOpacity(0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: item.color.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                item.icon,
                size: 80,
                color: item.color,
              ),
            ),
          ),
          const SizedBox(height:  48),

          // العنوان
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height:  16),

          // الوصف
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _items. length,
              (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 32 : 8,
            height: 8,
            decoration:  BoxDecoration(
              color: _currentPage == index
                  ? _items[_currentPage].color
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets. all(24),
      child: Row(
        children: [
          // زر السابق
          if (_currentPage > 0)
            Expanded(
              child:  OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _items[_currentPage].color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward, color: _items[_currentPage]. color),
                    const SizedBox(width: 8),
                    Text(
                      'السابق',
                      style: TextStyle(color: _items[_currentPage]. color),
                    ),
                  ],
                ),
              ),
            ),

          if (_currentPage > 0) const SizedBox(width: 16),

          // زر التالي
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _items[_currentPage]. color,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _items.length - 1 ?  'ابدأ الآن' : 'التالي',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentPage == _items.length - 1
                        ? Icons.login
                        : Icons.arrow_back,
                    color: Colors. white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this. icon,
    required this.color,
    required this.image,
  });
}