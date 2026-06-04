import 'package:flutter/material.dart';
import '../services/child_service.dart';
import '../models/child_model.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  final ChildService _childService = ChildService();
  List<Child> _children = [];
  bool _isLoading = true;
  int selectedChildIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final children = await _childService.getChildren();
    if (mounted) {
      setState(() {
        _children = children;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _childToMap(Child child) {
    return {
      'id': child.id,
      'name': child.name,
      'age': child.age,
      'avatar': child.avatar,
      'gender': child.gender,
      'interests': child.interests,
      'learningProgress': {
        'language': 50,
        'math': 50,
        'social': 50,
        'creativity': 50,
      },
      'dailyUsage': 0,
      'totalDays': 0,
      'achievements': 0,
      'isActive': true,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('ملف الطفل')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_children.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('ملف الطفل')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.child_care, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('لا يوجد أطفال مسجلين', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/add-child');
                  _loadChildren();
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة طفل'),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedChildIndex >= _children.length) {
      selectedChildIndex = 0;
    }

    final child = _childToMap(_children[selectedChildIndex]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملف الطفل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditChildDialog(context, child);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_children.length > 1) _buildChildSelector(),
              const SizedBox(height: 16),
              _buildProfileCard(child),
              const SizedBox(height: 24),
              _buildInterestsSection(child),
              const SizedBox(height: 24),
              _buildLearningProgressSection(child),
              const SizedBox(height: 24),
              _buildEducationalSettings(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-child');
          _loadChildren();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('إضافة طفل'),
      ),
    );
  }

  Widget _buildChildSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: _children.length,
        itemBuilder: (context, index) {
          final child = _children[index];
          final isSelected = index == selectedChildIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedChildIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    child.avatar,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[700],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF90EE90),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  radius: 50,
                  child: Text(
                    child['avatar'],
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90EE90),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              child['name'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${child['age']} سنوات • ${child['gender']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: Icons.timer,
                  value: '${child['dailyUsage']}',
                  label: 'دقيقة/يوم',
                  color: const Color(0xFF87CEEB),
                ),
                _buildStatItem(
                  icon: Icons.emoji_events,
                  value: '${child['achievements']}',
                  label: 'إنجاز',
                  color: const Color(0xFFFFB74D),
                ),
                _buildStatItem(
                  icon: Icons.calendar_today,
                  value: '${child['totalDays']}',
                  label: 'يوم',
                  color: const Color(0xFF90EE90),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(Map<String, dynamic> child) {
    final interests = child['interests'] as List<dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الاهتمامات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _showEditInterestsDialog(context, child);
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('تعديل'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        interests.isEmpty
            ? const Text('لا توجد اهتمامات محددة', style: TextStyle(color: Colors.grey))
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  return Chip(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                    label: Text(interest.toString()),
                    avatar: const Icon(
                      Icons.favorite,
                      size: 16,
                      color: Color(0xFF90EE90),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildLearningProgressSection(Map<String, dynamic> child) {
    final progress = child['learningProgress'] as Map<String, int>;
    final skillNames = {
      'language': 'اللغة',
      'math': 'الرياضيات',
      'social': 'المهارات الاجتماعية',
      'creativity': 'الإبداع',
    };
    final skillColors = {
      'language': const Color(0xFF87CEEB),
      'math': const Color(0xFFFFB74D),
      'social': const Color(0xFF90EE90),
      'creativity': const Color(0xFFBA68C8),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تقدم التعلم',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: progress.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            skillNames[entry.key] ?? entry.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${entry.value}%',
                            style: TextStyle(
                              color: skillColors[entry.key],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            skillColors[entry.key] ?? Colors.blue,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationalSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإعدادات التربوية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87CEEB).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.timer, color: Color(0xFF87CEEB)),
                ),
                title: const Text('وقت الاستخدام اليومي'),
                subtitle: const Text('45 دقيقة'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90EE90).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.content_copy, color: Color(0xFF90EE90)),
                ),
                title: const Text('المحتوى المسموح'),
                subtitle: const Text('قصص، أنشطة، ألعاب تعليمية'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB74D).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: Color(0xFFFFB74D)),
                ),
                title: const Text('المسار التعليمي'),
                subtitle: const Text('متوازن - تركيز على اللغة'),
                trailing: const Icon(Icons.chevron_left),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/progress');
                },
                icon: const Icon(Icons.assessment),
                label: const Text('التقارير'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/library');
                },
                icon: const Icon(Icons.library_books),
                label: const Text('المحتوى'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmDialog(context),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('حذف ملف الطفل', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteChild() async {
    if (_children.isEmpty || selectedChildIndex >= _children.length) return;
    
    final childToDelete = _children[selectedChildIndex];
    final result = await _childService.deleteChild(childToDelete.id);
    
    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف ${childToDelete.name} بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          selectedChildIndex = 0;
        });
        _loadChildren();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    if (_children.isEmpty || selectedChildIndex >= _children.length) return;
    
    final childName = _children[selectedChildIndex].name;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ملف "$childName"؟\nلا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteChild();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditChildDialog(BuildContext context, Map<String, dynamic> child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
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
                'تعديل بيانات الطفل',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: child['name'],
                decoration: const InputDecoration(
                  labelText: 'اسم الطفل',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: child['age'].toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'العمر',
                  prefixIcon: Icon(Icons.cake),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم حفظ التغييرات')),
                        );
                      },
                      child: const Text('حفظ'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showEditInterestsDialog(BuildContext context, Map<String, dynamic> child) {
    final allInterests = [
      'قصص الحيوانات',
      'الألوان',
      'الموسيقى',
      'الأرقام',
      'الحروف',
      'الفضاء',
      'الطبيعة',
      'الرياضة',
      'الفن',
      'العلوم',
    ];

    List<String> selectedInterests = List<String>.from(
      (child['interests'] as List<dynamic>).map((e) => e.toString()),
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'اختر اهتمامات الطفل',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allInterests.map((interest) {
                      final isSelected = selectedInterests.contains(interest);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(interest),
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedInterests.add(interest);
                            } else {
                              selectedInterests.remove(interest);
                            }
                          });
                        },
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        child['interests'] = selectedInterests;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('حفظ'),
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
