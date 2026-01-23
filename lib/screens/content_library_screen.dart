import 'package:flutter/material.dart';

class ContentLibraryScreen extends StatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  State<ContentLibraryScreen> createState() => _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends State<ContentLibraryScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'الكل';
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'الكل',
    'قصص',
    'أنشطة',
    'ألعاب',
    'تعليمي',
    'تربوي',
    'ديني'
  ];

  final List<Map<String, dynamic>> _contentItems = [
    {
      'id': '1',
      'title': 'قصة الأرنب الصغير',
      'category': 'قصص',
      'duration': '10 دقائق',
      'age': '3-5 سنوات',
      'rating': 4.8,
      'reviews': 156,
      'isDownloaded': true,
      'isNew': false,
      'color': const Color(0xFF87CEEB),
      'icon': Icons.auto_stories,
      'description':  'قصة ممتعة عن أرنب صغير يتعلم قيمة الصداقة والمشاركة',
    },
    {
      'id': '2',
      'title': 'تعلم الأرقام',
      'category': 'تعليمي',
      'duration': '15 دقيقة',
      'age':  '4-6 سنوات',
      'rating': 4.5,
      'reviews': 203,
      'isDownloaded': true,
      'isNew': false,
      'color': const Color(0xFF90EE90),
      'icon': Icons.calculate,
      'description': 'نشاط تفاعلي لتعلم الأرقام من 1 إلى 10 بطريقة ممتعة',
    },
    {
      'id': '3',
      'title': 'لعبة المزارع',
      'category': 'ألعاب',
      'duration': '20 دقيقة',
      'age': '5-7 سنوات',
      'rating': 4.9,
      'reviews': 89,
      'isDownloaded': false,
      'isNew': true,
      'color':  const Color(0xFFFFB74D),
      'icon': Icons.agriculture,
      'description': 'ساعد المزارع في زراعة الخضروات والعناية بالحيوانات',
    },
    {
      'id':  '4',
      'title':  'مساعدة الآخرين',
      'category':  'تربوي',
      'duration': '12 دقيقة',
      'age': '3-6 سنوات',
      'rating': 4.7,
      'reviews': 134,
      'isDownloaded': true,
      'isNew': false,
      'color':  const Color(0xFFBA68C8),
      'icon': Icons.volunteer_activism,
      'description': 'تعلم قيمة مساعدة الآخرين من خلال مواقف يومية',
    },
    {
      'id': '5',
      'title': 'أشكال الحيوانات',
      'category': 'أنشطة',
      'duration': '8 دقائق',
      'age': '3-5 سنوات',
      'rating': 4.6,
      'reviews': 178,
      'isDownloaded': false,
      'isNew': false,
      'color': const Color(0xFF4DD0E1),
      'icon': Icons.pets,
      'description': 'تعرف على الحيوانات وأصواتها بطريقة تفاعلية',
    },
    {
      'id': '6',
      'title': 'سورة الفاتحة',
      'category': 'ديني',
      'duration':  '10 دقائق',
      'age': '4-7 سنوات',
      'rating': 4.9,
      'reviews': 312,
      'isDownloaded': true,
      'isNew': false,
      'color':  const Color(0xFF81C784),
      'icon': Icons.menu_book,
      'description': 'تعلم سورة الفاتحة مع التجويد بطريقة سهلة وممتعة',
    },
    {
      'id':  '7',
      'title':  'الألوان السحرية',
      'category':  'أنشطة',
      'duration': '15 دقيقة',
      'age':  '3-5 سنوات',
      'rating': 4.4,
      'reviews': 98,
      'isDownloaded': false,
      'isNew': true,
      'color':  const Color(0xFFFF8A65),
      'icon': Icons.palette,
      'description': 'اكتشف عالم الألوان وتعلم مزجها',
    },
    {
      'id': '8',
      'title': 'آداب الطعام',
      'category': 'تربوي',
      'duration': '8 دقائق',
      'age': '3-6 سنوات',
      'rating': 4.6,
      'reviews': 145,
      'isDownloaded': true,
      'isNew': false,
      'color':  const Color(0xFF9575CD),
      'icon': Icons.restaurant,
      'description': 'تعلم آداب الطعام الإسلامية بأسلوب شيق',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _contentItems;

    if (_selectedCategory != 'الكل') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      items = items
          .where((item) => item['title']
          .toString()
          .toLowerCase()
          .contains(_searchController.text. toLowerCase()))
          .toList();
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync:  this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتبة المحتوى'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore, size: 20),
                  SizedBox(width: 8),
                  Text('استكشاف'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_done, size: 20),
                  SizedBox(width: 8),
                  Text('المحفوظات'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExploreTab(),
          _buildDownloadedTab(),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return Column(
      children: [
        // شريط البحث والفلاتر
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration:  InputDecoration(
                  hintText: 'ابحث في المحتوى...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                ),
              ),
              const SizedBox(height:  12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection:  Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding:  const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        selected:  isSelected,
                        label:  Text(category),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor:
                        Theme.of(context).colorScheme.primary. withOpacity(0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[700],
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // قائمة المحتوى
        Expanded(
          child:  _filteredItems.isEmpty
              ?  _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:  _filteredItems.length,
            itemBuilder: (context, index) {
              return _buildContentCard(_filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadedTab() {
    final downloadedItems =
    _contentItems.where((item) => item['isDownloaded'] == true).toList();

    if (downloadedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا يوجد محتوى محفوظ',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بتحميل المحتوى للوصول إليه بدون إنترنت',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets. all(16),
      itemCount: downloadedItems.length,
      itemBuilder: (context, index) {
        return _buildContentCard(downloadedItems[index], showDownloadButton: false);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style:  TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item,
      {bool showDownloadButton = true}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showContentDetails(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // أيقونة المحتوى
              Stack(
                children: [
                  Container(
                    width:  70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 35,
                      color: item['color'] as Color,
                    ),
                  ),
                  if (item['isNew'] == true)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:  Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'جديد',
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // معلومات المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius. circular(8),
                          ),
                          child: Text(
                            item['category'],
                            style: TextStyle(
                              fontSize: 11,
                              color: item['color'] as Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          item['duration'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors. grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.child_care, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          item['age'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors. grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 14, color: Color(0xFFFFB74D)),
                        const SizedBox(width: 4),
                        Text(
                          '${item['rating']}',
                          style: const TextStyle(
                            fontSize:  12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' (${item['reviews']})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors. grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // زر التحميل/التشغيل
              if (showDownloadButton)
                IconButton(
                  onPressed: () {
                    setState(() {
                      item['isDownloaded'] = !item['isDownloaded'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          item['isDownloaded']
                              ? 'تم تحميل ${item['title']}'
                              : 'تم حذف ${item['title']}',
                        ),
                        action: SnackBarAction(
                          label: 'تراجع',
                          onPressed: () {
                            setState(() {
                              item['isDownloaded'] = !item['isDownloaded'];
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    item['isDownloaded']
                        ? Icons.download_done
                        : Icons.download_outlined,
                    color: item['isDownloaded']
                        ? const Color(0xFF90EE90)
                        :  Colors.grey,
                  ),
                )
              else
                IconButton(
                  onPressed: () => _showContentDetails(item),
                  icon: const Icon(Icons.play_circle_filled,
                      color: Color(0xFF87CEEB), size: 32),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContentDetails(Map<String, dynamic> item) {
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
            return SingleChildScrollView(
              controller:  scrollController,
              child:  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // المقبض
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height:  20),
                    // صورة المحتوى
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (item['color'] as Color).withOpacity(0.7),
                            (item['color'] as Color),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // العنوان والتصنيف
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item['category'],
                            style:  TextStyle(
                              color: item['color'] as Color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // معلومات إضافية
                    Row(
                      children: [
                        _buildDetailChip(
                            Icons.timer, item['duration'], Colors.grey[600]!),
                        const SizedBox(width: 16),
                        _buildDetailChip(
                            Icons.child_care, item['age'], Colors.grey[600]!),
                        const SizedBox(width: 16),
                        _buildDetailChip(Icons.star, '${item['rating']}',
                            const Color(0xFFFFB74D)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // الوصف
                    const Text(
                      'الوصف',
                      style:  TextStyle(
                        fontSize:  18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height:  8),
                    Text(
                      item['description'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors. grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // المهارات المكتسبة
                    const Text(
                      'المهارات المكتسبة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSkillChip('التركيز'),
                        _buildSkillChip('الاستماع'),
                        _buildSkillChip('القيم'),
                        _buildSkillChip('اللغة'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // أزرار الإجراءات
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton. icon(
                            onPressed:  () {
                              setState(() {
                                item['isDownloaded'] = !item['isDownloaded'];
                              });
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              item['isDownloaded']
                                  ?  Icons.delete_outline
                                  : Icons.download,
                            ),
                            label: Text(
                                item['isDownloaded'] ?  'حذف' : 'تحميل'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                  Text('جاري تشغيل ${item['title']}... '),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label:  const Text('تشغيل الآن'),
                            style:  ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF90EE90).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF90EE90).withOpacity(0.3),
        ),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 13,
        ),
      ),
    );
  }
}