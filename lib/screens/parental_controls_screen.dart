import 'package:flutter/material.dart';

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super. key});

  @override
  State<ParentalControlsScreen> createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  // إعدادات الوقت
  double _dailyTimeLimit = 45;
  bool _weekendExtraTime = true;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 0);
  List<bool> _activeDays = [true, true, true, true, true, true, true];

  // إعدادات المحتوى
  final Map<String, bool> _contentCategories = {
    'قصص':  true,
    'ألعاب تعليمية':  true,
    'أنشطة': true,
    'محتوى ديني':  true,
    'محتوى تربوي': true,
    'أناشيد': true,
    'فيديوهات': false,
  };

  // إعدادات المهارات
  final Map<String, bool> _skillsFocus = {
    'القراءة': true,
    'الكتابة':  true,
    'الحساب': true,
    'المهارات الاجتماعية': true,
    'الإبداع': false,
    'التركيز':  true,
  };

  // إعدادات الأمان
  bool _requirePinForSettings = true;
  bool _requirePinForPurchases = true;
  bool _allowNotifications = true;
  bool _allowSoundEffects = true;
  bool _allowBackgroundMusic = true;

  final List<String> _dayNames = ['س', 'أ', 'إ', 'ث', 'أ', 'خ', 'ج'];
  final List<String> _dayFullNames = [
    'السبت',
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرقابة الأبوية'),
        actions: [
          TextButton. icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'حفظ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeLimitSection(),
            const SizedBox(height: 24),
            _buildScheduleSection(),
            const SizedBox(height: 24),
            _buildContentFilterSection(),
            const SizedBox(height: 24),
            _buildSkillsFocusSection(),
            const SizedBox(height: 24),
            _buildSecuritySection(),
            const SizedBox(height: 24),
            _buildNotificationSection(),
            const SizedBox(height: 24),
            _buildSoundSection(),
            const SizedBox(height: 24),
            _buildResetSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors. grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLimitSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'الحد الزمني اليومي',
              icon:  Icons.timer,
              color: const Color(0xFF87CEEB),
              subtitle: 'تحديد وقت الاستخدام اليومي',
            ),
            const SizedBox(height:  24),

            // عرض الوقت المحدد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_dailyTimeLimit.round()} دقيقة',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CEEB),
                      ),
                    ),
                    Text(
                      '${(_dailyTimeLimit / 60).toStringAsFixed(1)} ساعة يومياً',
                      style:  TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90EE90).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF90EE90),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'مفعّل',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // شريط التحكم
            SliderTheme(
              data:  SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF87CEEB),
                inactiveTrackColor: const Color(0xFF87CEEB).withOpacity(0.2),
                thumbColor: const Color(0xFF87CEEB),
                overlayColor: const Color(0xFF87CEEB).withOpacity(0.1),
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              ),
              child: Slider(
                value: _dailyTimeLimit,
                min: 15,
                max: 180,
                divisions: 33,
                onChanged: (value) {
                  setState(() {
                    _dailyTimeLimit = value;
                  });
                },
              ),
            ),

            // تسميات الشريط
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('15 د', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  Text('1 س', style: TextStyle(color:  Colors.grey[500], fontSize: 12)),
                  Text('2 س', style: TextStyle(color:  Colors.grey[500], fontSize: 12)),
                  Text('3 س', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // وقت إضافي في العطلة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child:  SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'وقت إضافي في عطلة نهاية الأسبوع',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '+30 دقيقة يومي الجمعة والسبت',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                value: _weekendExtraTime,
                activeColor: const Color(0xFF87CEEB),
                onChanged: (value) {
                  setState(() {
                    _weekendExtraTime = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'جدول الاستخدام',
              icon: Icons.schedule,
              color: const Color(0xFF90EE90),
              subtitle:  'تحديد أوقات وأيام اللعب',
            ),
            const SizedBox(height: 24),

            // أوقات الاستخدام
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    'وقت البدء',
                    _startTime,
                    Icons.play_circle_outline,
                        (time) => setState(() => _startTime = time),
                  ),
                ),
                const SizedBox(width:  16),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_forward, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSelector(
                    'وقت الانتهاء',
                    _endTime,
                    Icons.stop_circle_outlined,
                        (time) => setState(() => _endTime = time),
                  ),
                ),
              ],
            ),

            const SizedBox(height:  24),

            // أيام الاستخدام
            const Text(
              'أيام الاستخدام المسموحة',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  List.generate(7, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeDays[index] = !_activeDays[index];
                    });
                  },
                  child:  Tooltip(
                    message: _dayFullNames[index],
                    child: AnimatedContainer(
                      duration:  const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _activeDays[index]
                            ? const Color(0xFF90EE90)
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                        boxShadow: _activeDays[index]
                            ? [
                          BoxShadow(
                            color: const Color(0xFF90EE90).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _dayNames[index],
                          style: TextStyle(
                            color: _activeDays[index] ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${_activeDays.where((d) => d).length} أيام مفعّلة',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
      String label,
      TimeOfDay time,
      IconData icon,
      Function(TimeOfDay) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height:  8),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: time,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme. light(
                      primary: Color(0xFF87CEEB),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedTime != null) {
              onChanged(selectedTime);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets. all(14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF90EE90)),
                const SizedBox(width: 8),
                Text(
                  time.format(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentFilterSection() {
    return Card(
      child:  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment. start,
          children: [
            _buildSectionHeader(
              title: 'فلترة المحتوى',
              icon: Icons.filter_list,
              color: const Color(0xFFFFB74D),
              subtitle: 'اختر أنواع المحتوى المسموح بها',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _contentCategories.entries.map((entry) {
                return FilterChip(
                  selected: entry.value,
                  label: Text(entry.key),
                  onSelected: (selected) {
                    setState(() {
                      _contentCategories[entry.key] = selected;
                    });
                  },
                  selectedColor: const Color(0xFFFFB74D).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFFFB74D),
                  avatar: entry.value
                      ? null
                      : const Icon(Icons.block, size: 16, color: Colors.grey),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed:  () {
                    setState(() {
                      _contentCategories. updateAll((key, value) => true);
                    });
                  },
                  child: const Text('تحديد الكل'),
                ),
                TextButton(
                  onPressed:  () {
                    setState(() {
                      _contentCategories. updateAll((key, value) => false);
                    });
                  },
                  child: const Text('إلغاء الكل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsFocusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'التركيز على المهارات',
              icon: Icons.psychology,
              color: const Color(0xFFBA68C8),
              subtitle:  'حدد المهارات التي تريد تطويرها',
            ),
            const SizedBox(height: 20),
            ..._skillsFocus.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: entry.value
                      ? const Color(0xFFBA68C8).withOpacity(0.05)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: entry.value ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  value: entry.value,
                  activeColor: const Color(0xFFBA68C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _skillsFocus[entry.key] = value!;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'الأمان',
              icon: Icons.security,
              color: Colors.red,
              subtitle: 'إعدادات الحماية والأمان',
            ),
            const SizedBox(height:  20),

            // رمز PIN للإعدادات
            _buildSecuritySwitch(
              title: 'رمز PIN للإعدادات',
              subtitle: 'طلب رمز PIN للدخول للإعدادات',
              value: _requirePinForSettings,
              icon: Icons.lock,
              onChanged: (value) {
                setState(() {
                  _requirePinForSettings = value;
                });
              },
            ),
            const Divider(),

            // رمز PIN للمشتريات
            _buildSecuritySwitch(
              title: 'رمز PIN للمشتريات',
              subtitle: 'طلب رمز PIN لأي عملية شراء',
              value: _requirePinForPurchases,
              icon: Icons. shopping_cart,
              onChanged: (value) {
                setState(() {
                  _requirePinForPurchases = value;
                });
              },
            ),
            const Divider(),

            // تغيير رمز PIN
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors. red. withOpacity(0.1),
                  borderRadius: BorderRadius. circular(8),
                ),
                child: const Icon(Icons. pin, color: Colors.red),
              ),
              title: const Text('تغيير رمز PIN'),
              subtitle: const Text('تحديث رمز الحماية'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => _showChangePinDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySwitch({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets. zero,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF90EE90).withOpacity(0.15)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: value ? const Color(0xFF90EE90) : Colors.grey,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight. w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors. grey[600])),
      value: value,
      activeColor: const Color(0xFF90EE90),
      onChanged: onChanged,
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'الإشعارات',
              icon: Icons.notifications,
              color: const Color(0xFF4DD0E1),
              subtitle:  'التحكم في إشعارات التطبيق',
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets. zero,
              title: const Text('السماح بالإشعارات'),
              subtitle: const Text('إرسال إشعارات عن نشاط الطفل'),
              value: _allowNotifications,
              activeColor: const Color(0xFF4DD0E1),
              onChanged: (value) {
                setState(() {
                  _allowNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'الصوت',
              icon: Icons.volume_up,
              color: const Color(0xFF9575CD),
              subtitle: 'إعدادات الأصوات والموسيقى',
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets. zero,
              title: const Text('المؤثرات الصوتية'),
              subtitle: const Text('أصوات التفاعل واللعب'),
              value:  _allowSoundEffects,
              activeColor:  const Color(0xFF9575CD),
              onChanged: (value) {
                setState(() {
                  _allowSoundEffects = value;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('الموسيقى الخلفية'),
              subtitle: const Text('موسيقى هادئة أثناء اللعب'),
              value: _allowBackgroundMusic,
              activeColor: const Color(0xFF9575CD),
              onChanged: (value) {
                setState(() {
                  _allowBackgroundMusic = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetSection() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'إعادة الضبط',
              icon: Icons.restore,
              color: Colors.red,
              subtitle: 'استعادة الإعدادات الافتراضية',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double. infinity,
              child: OutlinedButton. icon(
                onPressed: _showResetConfirmDialog,
                icon: const Icon(Icons.restore, color: Colors.red),
                label: const Text(
                  'إعادة ضبط جميع الإعدادات',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors. red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePinDialog() {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder:  (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Color(0xFF87CEEB)),
            SizedBox(width: 8),
            Text('تغيير رمز PIN'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الرمز الحالي',
                counterText: '',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height:  16),
            TextField(
              controller: newPinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الرمز الجديد',
                counterText: '',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'تأكيد الرمز الجديد',
                counterText: '',
                prefixIcon:  Icon(Icons.lock),
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
              if (newPinController.text == confirmPinController.text &&
                  newPinController.text.length == 4) {
                Navigator. pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تغيير رمز PIN بنجاح'),
                    backgroundColor: Color(0xFF90EE90),
                  ),
                );
              } else {
                ScaffoldMessenger. of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرمز غير متطابق أو غير صحيح'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmDialog() {
    showDialog(
      context:  context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children:  [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('تأكيد إعادة الضبط'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من إعادة ضبط جميع إعدادات الرقابة الأبوية إلى الإعدادات الافتراضية؟\n\nهذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed:  () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              _resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إعادة ضبط الإعدادات'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إعادة الضبط'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _dailyTimeLimit = 45;
      _weekendExtraTime = true;
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 20, minute: 0);
      _activeDays = [true, true, true, true, true, true, true];
      _contentCategories. updateAll((key, value) => true);
      _skillsFocus. updateAll((key, value) => true);
      _requirePinForSettings = true;
      _requirePinForPurchases = true;
      _allowNotifications = true;
      _allowSoundEffects = true;
      _allowBackgroundMusic = true;
    });
  }

  void _saveSettings() {
    // حفظ الإعدادات
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('تم حفظ إعدادات الرقابة الأبوية بنجاح'),
          ],
        ),
        backgroundColor: Color(0xFF90EE90),
      ),
    );
    Navigator.pop(context);
  }
}