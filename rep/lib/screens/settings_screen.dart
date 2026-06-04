import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/child_service.dart';
import '../models/child_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  final _childService = ChildService();
  
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoUpdateEnabled = true;
  bool _analyticsEnabled = true;
  String _selectedLanguage = 'العربية';
  double _dailyTimeLimit = 45;
  
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 24),
          _buildChildrenSection(),
          const SizedBox(height: 24),
          _buildGeneralSettings(),
          const SizedBox(height: 24),
          _buildNotificationSettings(),
          const SizedBox(height: 24),
          _buildParentalControlSettings(),
          const SizedBox(height: 24),
          _buildPrivacySettings(),
          const SizedBox(height: 24),
          _buildSupportSection(),
          const SizedBox(height: 24),
          _buildLogoutButton(),
          const SizedBox(height: 40),
          _buildAppInfo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.2),
                  child: const Icon(
                      Icons.person, size: 40, color: Color(0xFF87CEEB)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                        Icons.edit, size: 14, color: Colors.white),
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
                    _userData?.name ?? 'المستخدم',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userData?.email ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90EE90).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'حساب مفعّل',
                      style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _showEditProfileDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الأطفال المسجلون',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/add-child');
                    _loadData();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_children.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('لا يوجد أطفال مسجلون بعد'),
                ),
              )
            else
              ..._children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                return Column(
                  children: [
                    _buildChildTile(
                      child.name,
                      '${child.age} سنوات',
                      child.avatar,
                      index == 0,
                    ),
                    if (index < _children.length - 1) const Divider(),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildChildTile(String name, String age, String avatar,
      bool isActive) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary
            .withOpacity(0.2),
        child: Text(avatar, style: const TextStyle(fontSize: 24)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(age),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF90EE90).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle, size: 14, color: Color(0xFF2E7D32)),
                  SizedBox(width: 4),
                  Text(
                    'يلعب الآن',
                    style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            onPressed: () => _showChildSettingsDialog(name),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return _buildSettingsSection(
      title: 'الإعدادات العامة',
      icon: Icons.settings,
      children: [
        _buildSwitchTile(
          icon: Icons.dark_mode,
          title: 'الوضع الداكن',
          subtitle: 'تغيير مظهر التطبيق',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.volume_up,
          title: 'الأصوات',
          subtitle: 'أصوات التنبيهات والتفاعل',
          value: _soundEnabled,
          onChanged: (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
        _buildNavigationTile(
          icon: Icons.language,
          title: 'اللغة',
          subtitle: _selectedLanguage,
          onTap: () => _showLanguageDialog(),
        ),
        _buildSwitchTile(
          icon: Icons.system_update,
          title: 'التحديث التلقائي',
          subtitle: 'تحديث المحتوى تلقائياً',
          value: _autoUpdateEnabled,
          onChanged: (value) {
            setState(() {
              _autoUpdateEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      title: 'الإشعارات',
      icon: Icons.notifications,
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_active,
          title: 'تفعيل الإشعارات',
          subtitle: 'استلام إشعارات التطبيق',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildNavigationTile(
          icon: Icons.tune,
          title: 'تخصيص الإشعارات',
          subtitle: 'اختر أنواع الإشعارات',
          onTap: () => _showNotificationTypesDialog(),
          enabled: _notificationsEnabled,
        ),
      ],
    );
  }

  Widget _buildParentalControlSettings() {
    return _buildSettingsSection(
      title: 'الرقابة الأبوية',
      icon: Icons.shield,
      children: [
        _buildSliderTile(
          icon: Icons.timer,
          title: 'الحد الزمني اليومي',
          value: _dailyTimeLimit,
          min: 15,
          max: 120,
          divisions: 21,
          label: '${_dailyTimeLimit.round()} دقيقة',
          onChanged: (value) {
            setState(() {
              _dailyTimeLimit = value;
            });
          },
        ),
        _buildNavigationTile(
          icon: Icons.content_paste,
          title: 'فلترة المحتوى',
          subtitle: 'التحكم في المحتوى المعروض',
          onTap: () => _showContentFilterDialog(),
        ),
        _buildNavigationTile(
          icon: Icons.schedule,
          title: 'جدول الاستخدام',
          subtitle: 'تحديد أوقات اللعب المسموحة',
          onTap: () => _showScheduleDialog(),
        ),
        _buildNavigationTile(
          icon: Icons.lock,
          title: 'رمز الحماية',
          subtitle: 'تغيير رمز PIN',
          onTap: () => _showChangePinDialog(),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsSection(
      title: 'الخصوصية والبيانات',
      icon: Icons.privacy_tip,
      children: [
        _buildSwitchTile(
          icon: Icons.analytics,
          title: 'مشاركة التحليلات',
          subtitle: 'المساعدة في تحسين التطبيق',
          value: _analyticsEnabled,
          onChanged: (value) {
            setState(() {
              _analyticsEnabled = value;
            });
          },
        ),
        _buildNavigationTile(
          icon: Icons.download,
          title: 'تحميل البيانات',
          subtitle: 'تحميل نسخة من بياناتك',
          onTap: () => _downloadData(),
        ),
        _buildNavigationTile(
          icon: Icons.delete_forever,
          title: 'حذف البيانات',
          subtitle: 'حذف جميع البيانات نهائياً',
          onTap: () => _showDeleteDataDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSettingsSection(
      title: 'الدعم والمساعدة',
      icon: Icons.help,
      children: [
        _buildNavigationTile(
          icon: Icons.help_outline,
          title: 'الأسئلة الشائعة',
          subtitle: 'إجابات على الأسئلة المتكررة',
          onTap: () => _showFAQScreen(),
        ),
        _buildNavigationTile(
          icon: Icons.chat_bubble_outline,
          title: 'تواصل معنا',
          subtitle: 'إرسال رسالة للدعم الفني',
          onTap: () => _showContactDialog(),
        ),
        _buildNavigationTile(
          icon: Icons.star_outline,
          title: 'تقييم التطبيق',
          subtitle: 'شاركنا رأيك',
          onTap: () => _showRatingDialog(),
        ),
        _buildNavigationTile(
          icon: Icons.description,
          title: 'سياسة الخصوصية',
          subtitle: 'الشروط والأحكام',
          onTap: () => _showPrivacyPolicy(),
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme
                    .of(context)
                    .colorScheme
                    .primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .primary
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme
            .of(context)
            .colorScheme
            .primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
          subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme
            .of(context)
            .colorScheme
            .primary,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.red
        : enabled
        ? Theme
        .of(context)
        .colorScheme
        .primary
        : Colors.grey;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: enabled,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: enabled ? (isDestructive ? Colors.red : null) : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 12, color: enabled ? Colors.grey[600] : Colors.grey[400]),
      ),
      trailing: Icon(
        Icons.chevron_left,
        color: enabled ? Colors.grey : Colors.grey[300],
      ),
      onTap: enabled ? onTap : null,
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme
                .of(context)
                .colorScheme
                .primary, size: 20),
          ),
          title: Text(
              title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme
                .of(context)
                .colorScheme
                .primary,
            inactiveTrackColor: Theme
                .of(context)
                .colorScheme
                .primary
                .withOpacity(0.2),
            thumbColor: Theme
                .of(context)
                .colorScheme
                .primary,
            overlayColor: Theme
                .of(context)
                .colorScheme
                .primary
                .withOpacity(0.1),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.logout, color: Colors.red, size: 20),
        ),
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_left, color: Colors.red),
        onTap: () => _showLogoutDialog(),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.spa, color: Color(0xFF87CEEB), size: 32);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'عالم الفسيلة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'الإصدار 1.0.0',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2024 جميع الحقوق محفوظة',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: 'أحمد محمد');
    final emailController = TextEditingController(text: 'ahmed@example.com');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
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
                'تعديل الملف الشخصي',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.2),
                  child: Stack(
                    children: [
                      const Icon(
                          Icons.person, size: 50, color: Color(0xFF87CEEB)),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          child: const Icon(Icons.camera_alt, size: 16,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور الجديدة (اختياري)',
                  prefixIcon: Icon(Icons.lock),
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

  void _showChildSettingsDialog(String childName) {
    showModalBottomSheet(
      context: context,
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
              Text(
                'إعدادات $childName',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF87CEEB)),
                title: const Text('تعديل الملف'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/child-profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.timer, color: Color(0xFF90EE90)),
                title: const Text('الحد الزمني'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.assessment, color: Color(0xFFFFB74D)),
                title: const Text('التقارير'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/progress');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                    'حذف الملف', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteChildDialog(childName);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteChildDialog(String childName) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[400]),
                const SizedBox(width: 8),
                const Text('حذف ملف الطفل'),
              ],
            ),
            content: Text(
              'هل أنت متأكد من حذف ملف $childName؟\n\nسيتم حذف جميع البيانات والتقارير المتعلقة بهذا الملف.  لا يمكن التراجع عن هذا الإجراء.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم حذف ملف $childName')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.language, color: Color(0xFF87CEEB)),
                SizedBox(width: 8),
                Text('اختر اللغة'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('العربية'),
                  subtitle: const Text('Arabic'),
                  value: 'العربية',
                  groupValue: _selectedLanguage,
                  activeColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تم تغيير اللغة إلى العربية')),
                    );
                  },
                ),
                RadioListTile<String>(
                  title: const Text('English'),
                  subtitle: const Text('الإنجليزية'),
                  value: 'English',
                  groupValue: _selectedLanguage,
                  activeColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Language changed to English')),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showNotificationTypesDialog() {
    bool activityNotifications = true;
    bool progressNotifications = true;
    bool tipsNotifications = true;
    bool updateNotifications = false;

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
                    'تخصيص الإشعارات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('نشاطات الطفل'),
                    subtitle: const Text('إشعارات عند بدء أو انتهاء اللعب'),
                    value: activityNotifications,
                    activeColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onChanged: (value) {
                      setModalState(() {
                        activityNotifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('تقارير التقدم'),
                    subtitle: const Text('ملخص أسبوعي لتقدم الطفل'),
                    value: progressNotifications,
                    activeColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onChanged: (value) {
                      setModalState(() {
                        progressNotifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('نصائح تربوية'),
                    subtitle: const Text('نصائح وتوصيات من الذكاء الاصطناعي'),
                    value: tipsNotifications,
                    activeColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onChanged: (value) {
                      setModalState(() {
                        tipsNotifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('التحديثات'),
                    subtitle: const Text('محتوى وميزات جديدة'),
                    value: updateNotifications,
                    activeColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    onChanged: (value) {
                      setModalState(() {
                        updateNotifications = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('تم حفظ إعدادات الإشعارات')),
                      );
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

  void _showContentFilterDialog() {
    Map<String, bool> contentFilters = {
      'قصص': true,
      'أنشطة تعليمية': true,
      'ألعاب': true,
      'محتوى ديني': true,
      'محتوى تربوي': true,
      'أناشيد': true,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    'فلترة المحتوى',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر أنواع المحتوى المسموح بها للطفل',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ... contentFilters.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key),
                      value: entry.value,
                      activeColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      onChanged: (value) {
                        setModalState(() {
                          contentFilters[entry.key] = value!;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ إعدادات المحتوى')),
                      );
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

  void _showScheduleDialog() {
    TimeOfDay startTime = const TimeOfDay(hour: 16, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 19, minute: 0);
    List<bool> selectedDays = [true, true, true, true, true, true, true];
    List<String> dayNames = ['س', 'أ', 'إ', 'ث', 'أ', 'خ', 'ج'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    'جدول الاستخدام',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('وقت البدء',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: startTime,
                                );
                                if (time != null) {
                                  setModalState(() {
                                    startTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time, size: 20),
                                    const SizedBox(width: 8),
                                    Text(startTime.format(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('وقت الانتهاء',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: endTime,
                                );
                                if (time != null) {
                                  setModalState(() {
                                    endTime = time;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time, size: 20),
                                    const SizedBox(width: 8),
                                    Text(endTime.format(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('أيام الاستخدام',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (index) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedDays[index] = !selectedDays[index];
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: selectedDays[index]
                                ? Theme
                                .of(context)
                                .colorScheme
                                .primary
                                : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              dayNames[index],
                              style: TextStyle(
                                color: selectedDays[index]
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ جدول الاستخدام')),
                      );
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

  void _showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
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
                'تغيير رمز الحماية',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: currentPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'رمز PIN الحالي',
                  prefixIcon: Icon(Icons.lock_outline),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'رمز PIN الجديد',
                  prefixIcon: Icon(Icons.lock),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'تأكيد رمز PIN الجديد',
                  prefixIcon: Icon(Icons.lock),
                  counterText: '',
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
                        if (newPinController.text ==
                            confirmPinController.text &&
                            newPinController.text.length == 4) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('تم تغيير رمز الحماية بنجاح')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('رمز PIN غير متطابق أو غير صحيح'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

  void _downloadData() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.download, color: Color(0xFF87CEEB)),
                SizedBox(width: 8),
                Text('تحميل البيانات'),
              ],
            ),
            content: const Text(
              'سيتم إرسال نسخة من بياناتك إلى بريدك الإلكتروني.\n\nتتضمن البيانات:\n• معلومات الحساب\n• ملفات الأطفال\n• تقارير التقدم\n• الإعدادات',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        'سيتم إرسال البيانات إلى بريدك الإلكتروني')),
                  );
                },
                child: const Text('تحميل'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[400]),
                const SizedBox(width: 8),
                const Text('حذف جميع البيانات'),
              ],
            ),
            content: const Text(
              'هل أنت متأكد من حذف جميع بياناتك؟\n\n⚠️ تحذير: سيتم حذف:\n• حسابك الشخصي\n• جميع ملفات الأطفال\n• جميع التقارير والإنجازات\n• جميع الإعدادات\n\nهذا الإجراء لا يمكن التراجع عنه! ',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFinalDeleteConfirmation();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }

  void _showFinalDeleteConfirmation() {
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('تأكيد الحذف النهائي'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('اكتب "حذف" للتأكيد: '),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب حذف',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (confirmController.text == 'حذف') {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف جميع البيانات')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('تأكيد الحذف'),
              ),
            ],
          ),
    );
  }

  void _showFAQScreen() {
    final faqs = [
      {
        'question': 'كيف أضيف طفل جديد؟',
        'answer': 'اذهب إلى الإعدادات > الأطفال المسجلون > إضافة طفل جديد، ثم أدخل بيانات الطفل.',
      },
      {
        'question': 'كيف أتحكم في وقت استخدام الطفل؟',
        'answer': 'من الإعدادات > الرقابة الأبوية > الحد الزمني اليومي، يمكنك تحديد عدد الدقائق المسموحة يومياً.',
      },
      {
        'question': 'كيف أربط اللعبة بالتطبيق؟',
        'answer': 'تأكد من تشغيل الجهاز وتفعيل البلوتوث، ثم اذهب إلى صفحة الاتصال واضغط على البحث عن الأجهزة.',
      },
      {
        'question': 'هل بيانات طفلي آمنة؟',
        'answer': 'نعم، جميع البيانات مشفرة ومحمية.  نحن لا نشارك بيانات الأطفال مع أي طرف ثالث.',
      },
      {
        'question': 'كيف أحصل على تقارير تقدم طفلي؟',
        'answer': 'من الشاشة الرئيسية، اضغط على "التقارير" أو من القائمة السفلية اختر "التقدم" لعرض تقارير مفصلة.',
      },
      {
        'question': 'هل يمكنني إضافة أكثر من طفل؟',
        'answer': 'نعم، يمكنك إضافة عدة أطفال ولكل طفل ملف خاص به مع إعدادات وتقارير منفصلة.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'الأسئلة الشائعة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: faqs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            title: Text(
                              faqs[index]['question']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  faqs[index]['answer']!,
                                  style: TextStyle(
                                      color: Colors.grey[700], height: 1.5),
                                ),
                              ),
                            ],
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

  void _showContactDialog() {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
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
                'تواصل معنا',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'الموضوع',
                  prefixIcon: Icon(Icons.subject),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'الرسالة',
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('تم إرسال رسالتك، سنرد عليك قريباً')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('إرسال'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showRatingDialog() {
    int rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('تقييم التطبيق', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('كيف تقيّم تجربتك مع عالم الفسيلة؟'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setDialogState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFB74D),
                          size: 36,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rating == 0
                        ? 'اضغط على النجوم للتقييم'
                        : rating <= 2
                        ? 'نأسف لعدم رضاك 😔'
                        : rating <= 4
                        ? 'شكراً لتقييمك!  😊'
                        : 'رائع! نسعد بذلك!  🎉',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لاحقاً'),
                ),
                ElevatedButton(
                  onPressed: rating > 0
                      ? () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('شكراً لتقييمك!  ❤️')),
                    );
                  }
                      : null,
                  child: const Text('إرسال'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'سياسة الخصوصية',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPolicySection(
                            'جمع البيانات',
                            'نقوم بجمع البيانات الضرورية فقط لتقديم تجربة تعليمية مخصصة لطفلك. تشمل هذه البيانات:  اسم الطفل، العمر، تفضيلات التعلم، وبيانات استخدام اللعبة.',
                          ),
                          _buildPolicySection(
                            'استخدام البيانات',
                            'نستخدم البيانات المجمعة لـ:\n• تخصيص المحتوى التعليمي\n• إنشاء تقارير التقدم\n• تحسين تجربة المستخدم\n• تطوير ميزات جديدة',
                          ),
                          _buildPolicySection(
                            'حماية البيانات',
                            'جميع البيانات مشفرة ومحمية بأحدث تقنيات الأمان. نستخدم بروتوكولات SSL/TLS لتأمين نقل البيانات.  لا نشارك بيانات الأطفال مع أي طرف ثالث تحت أي ظرف.',
                          ),
                          _buildPolicySection(
                            'حقوق المستخدم',
                            'يحق لك في أي وقت:\n• الوصول إلى بياناتك ومراجعتها\n• تعديل بياناتك الشخصية\n• حذف بياناتك بشكل كامل\n• طلب نسخة من بياناتك\n• إيقاف جمع البيانات التحليلية',
                          ),
                          _buildPolicySection(
                            'بيانات الأطفال',
                            'نولي اهتماماً خاصاً بحماية بيانات الأطفال:\n• لا نجمع بيانات شخصية حساسة\n• لا نعرض إعلانات للأطفال\n• لا نسمح بالتواصل مع الغرباء\n• جميع المحتوى مراجع ومناسب للأطفال',
                          ),
                          _buildPolicySection(
                            'ملفات تعريف الارتباط',
                            'نستخدم ملفات تعريف الارتباط لتحسين تجربة الاستخدام وتذكر تفضيلاتك. يمكنك التحكم في إعدادات ملفات تعريف الارتباط من إعدادات جهازك.',
                          ),
                          _buildPolicySection(
                            'التحديثات على السياسة',
                            'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر.  سنقوم بإشعارك بأي تغييرات جوهرية عبر التطبيق أو البريد الإلكتروني.',
                          ),
                          _buildPolicySection(
                            'التواصل',
                            'للأسئلة أو الاستفسارات المتعلقة بالخصوصية:\n\nالبريد الإلكتروني: privacy@alfaseelah.com\nالهاتف: +966-XX-XXX-XXXX\nالعنوان: المملكة العربية السعودية',
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'آخر تحديث: يناير 2024',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'الإصدار 1.0',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF87CEEB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text('تسجيل الخروج'),
              ],
            ),
            content: const Text('هل أنت متأكد من تسجيل الخروج من حسابك؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _authService.logout();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
    );
  }
}