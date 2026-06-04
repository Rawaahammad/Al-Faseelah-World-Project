import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../services/child_service.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _childService = ChildService();

  int _selectedAge = 5;
  String _selectedGender = 'ذكر';
  String _selectedAvatar = '👦';
  final List<String> _selectedInterests = [];
  bool _isLoading = false;

  final List<String> _avatars = ['👦', '👧', '🧒', '👶', '🧒🏻', '👦🏻', '👧🏻'];

  final List<Map<String, dynamic>> _allInterests = [
    {'name': 'القصص', 'icon': Icons.auto_stories},
    {'name': 'الأرقام', 'icon': Icons.calculate},
    {'name': 'الحروف', 'icon': Icons.abc},
    {'name': 'الألوان', 'icon': Icons.palette},
    {'name': 'الحيوانات', 'icon': Icons.pets},
    {'name': 'الطبيعة', 'icon': Icons.park},
    {'name': 'الفضاء', 'icon': Icons.rocket},
    {'name': 'الموسيقى', 'icon': Icons.music_note},
    {'name': 'الرسم', 'icon': Icons.brush},
    {'name': 'الرياضة', 'icon': Icons.sports_soccer},
    {'name': 'العلوم', 'icon': Icons.science},
    {'name': 'الطبخ', 'icon': Icons.restaurant},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChild() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedInterests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار اهتمام واحد على الأقل'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final newChild = Child(
        id: '',
        name: _nameController.text,
        age: _selectedAge,
        gender: _selectedGender,
        avatar: _selectedAvatar,
        interests: _selectedInterests,
        createdAt: DateTime.now(),
      );

      final result = await _childService.addChild(newChild);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (result.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة ${_nameController.text} بنجاح! 🎉'),
              backgroundColor: const Color(0xFF90EE90),
            ),
          );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طفل جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 32),
              _buildNameSection(),
              const SizedBox(height: 24),
              _buildAgeSection(),
              const SizedBox(height: 24),
              _buildGenderSection(),
              const SizedBox(height: 24),
              _buildInterestsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: Text(
                _selectedAvatar,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'اختر صورة رمزية',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _avatars.map((avatar) {
              final isSelected = avatar == _selectedAvatar;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                        : null,
                  ),
                  child: Text(avatar, style: const TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person, color: Color(0xFF87CEEB), size: 20),
            SizedBox(width: 8),
            Text(
              'اسم الطفل',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'أدخل اسم الطفل',
            prefixIcon: Icon(Icons.child_care),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال اسم الطفل';
            }
            if (value.length < 2) {
              return 'الاسم يجب أن يكون حرفين على الأقل';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.cake, color: Color(0xFF90EE90), size: 20),
            SizedBox(width: 8),
            Text(
              'العمر',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.cake, color: Color(0xFF90EE90)),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _selectedAge.toDouble(),
                  min: 3,
                  max: 9,
                  divisions: 6,
                  label: '$_selectedAge سنوات',
                  activeColor: const Color(0xFF90EE90),
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value.round();
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF90EE90),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_selectedAge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'العمر المناسب: 3-9 سنوات',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.wc, color: Color(0xFFFFB74D), size: 20),
            SizedBox(width: 8),
            Text(
              'الجنس',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                'ذكر',
                '👦',
                const Color(0xFF87CEEB),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption(
                'أنثى',
                '👧',
                const Color(0xFFFF9ECE),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, String emoji, Color color) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _selectedAvatar = emoji;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Color(0xFFBA68C8), size: 20),
                SizedBox(width: 8),
                Text(
                  'الاهتمامات',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            Text(
              '${_selectedInterests.length} مختار',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'اختر اهتمامات طفلك لتخصيص المحتوى',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest['name']);
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    interest['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(interest['name'] as String),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest['name'] as String);
                  } else {
                    _selectedInterests.remove(interest['name']);
                  }
                });
              },
              selectedColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChild,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save),
            SizedBox(width: 8),
            Text('حفظ', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
