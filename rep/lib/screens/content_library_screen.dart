import 'package:flutter/material.dart';
import '../models/content_pack_model.dart';
import '../services/content_service.dart';

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
  final ContentService _contentService = ContentService();

  List<ContentPack> _contentPacks = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'الكل',
    'قصص',
    'أنشطة',
    'ألعاب',
    'تعليمي',
    'تربوي',
    'ديني'
  ];

  static const Map<String, IconData> _categoryIcons = {
    'قصص': Icons.auto_stories,
    'أنشطة': Icons.palette,
    'ألعاب': Icons.sports_esports,
    'تعليمي': Icons.school,
    'تربوي': Icons.volunteer_activism,
    'ديني': Icons.menu_book,
  };

  static const Map<String, Color> _categoryColors = {
    'قصص': Color(0xFF87CEEB),
    'أنشطة': Color(0xFF4DD0E1),
    'ألعاب': Color(0xFFFFB74D),
    'تعليمي': Color(0xFF90EE90),
    'تربوي': Color(0xFFBA68C8),
    'ديني': Color(0xFF81C784),
  };

  List<ContentPack> get _filteredItems {
    var items = _contentPacks;

    if (_selectedCategory != 'الكل') {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      items = items
          .where((item) => item.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return items;
  }

  List<ContentPack> get _downloadedItems {
    return _contentPacks.where((item) => item.isOfflineAvailable).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadContent();
  }

  Future<void> _loadContent() async {
    await _contentService.seedInitialContent();
    final packs = await _contentService.getContentPacks();
    if (mounted) {
      setState(() {
        _contentPacks = packs;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  IconData _getIconForCategory(String category) {
    return _categoryIcons[category] ?? Icons.article;
  }

  Color _getColorForCategory(String category) {
    return _categoryColors[category] ?? const Color(0xFF87CEEB);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
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
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
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
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
        Expanded(
          child: _filteredItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return _buildContentCard(_filteredItems[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDownloadedTab() {
    if (_downloadedItems.isEmpty) {
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
      padding: const EdgeInsets.all(16),
      itemCount: _downloadedItems.length,
      itemBuilder: (context, index) {
        return _buildContentCard(_downloadedItems[index], showDownloadButton: false);
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
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
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

  Widget _buildContentCard(ContentPack pack, {bool showDownloadButton = true}) {
    final color = _getColorForCategory(pack.category);
    final icon = _getIconForCategory(pack.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showContentDetails(pack),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 35, color: color),
                  ),
                  if (pack.isNew)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'جديد',
                          style: TextStyle(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pack.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${pack.durationMinutes} دقيقة',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.child_care, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          pack.ageRange,
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 14, color: Color(0xFFFFB74D)),
                        const SizedBox(width: 4),
                        Text(
                          '${pack.rating}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          ' (${pack.reviewsCount})',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showDownloadButton)
                Icon(
                  pack.isOfflineAvailable
                      ? Icons.download_done
                      : Icons.download_outlined,
                  color: pack.isOfflineAvailable
                      ? const Color(0xFF90EE90)
                      : Colors.grey,
                )
              else
                const Icon(Icons.play_circle_filled,
                    color: Color(0xFF87CEEB), size: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showContentDetails(ContentPack pack) {
    final color = _getColorForCategory(pack.category);
    final icon = _getIconForCategory(pack.category);

    showModalBottomSheet(
      context: context,
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
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.7), color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pack.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pack.category,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDetailChip(Icons.timer, '${pack.durationMinutes} دقيقة', Colors.grey[600]!),
                        const SizedBox(width: 16),
                        _buildDetailChip(Icons.child_care, pack.ageRange, Colors.grey[600]!),
                        const SizedBox(width: 16),
                        _buildDetailChip(Icons.star, '${pack.rating}', const Color(0xFFFFB74D)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'الوصف',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pack.description,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    if (pack.zone.isNotEmpty) ...[
                      _buildInfoRow('المنطقة', pack.zone),
                      const SizedBox(height: 8),
                    ],
                    _buildInfoRow('الإصدار', pack.version),
                    const SizedBox(height: 16),
                    if (pack.topics.isNotEmpty) ...[
                      const Text(
                        'المواضيع',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pack.topics
                            .map((topic) => Chip(
                                  label: Text(topic, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: color.withOpacity(0.1),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (pack.skills.isNotEmpty) ...[
                      const Text(
                        'المهارات المستهدفة',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pack.skills
                            .map((skill) => Chip(
                                  label: Text(skill, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: const Color(0xFF90EE90).withOpacity(0.15),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('جاري تشغيل "${pack.title}"'),
                              backgroundColor: const Color(0xFF90EE90),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('تشغيل المحتوى'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
        Text(text, style: TextStyle(fontSize: 13, color: color)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
