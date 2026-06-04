import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super. key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _isConnected = false;
  String?  _connectedDevice;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'Al-Faseelah-001',
      'signal': 'قوية',
      'signalStrength': 3,
      'lastConnected':  'آخر اتصال: اليوم',
    },
    {
      'name': 'Al-Faseelah-002',
      'signal':  'متوسطة',
      'signalStrength': 2,
      'lastConnected':  'آخر اتصال: أمس',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:  const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
    });
    _animationController. repeat();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _animationController.stop();
      }
    });
  }

  void _connectToDevice(String deviceName) {
    setState(() {
      _isConnected = true;
      _connectedDevice = deviceName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('تم الاتصال بـ $deviceName'),
          ],
        ),
        backgroundColor: const Color(0xFF90EE90),
      ),
    );
  }

  void _disconnectDevice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('قطع الاتصال'),
        content: const Text('هل تريد قطع الاتصال بالجهاز؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isConnected = false;
                _connectedDevice = null;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('قطع الاتصال'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('توصيل الجهاز'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectionStatusCard(),
            const SizedBox(height: 24),
            if (_isConnected) ...[
              _buildConnectedDeviceInfo(),
              const SizedBox(height: 24),
            ],
            _buildAvailableDevices(),
            const SizedBox(height: 24),
            _buildConnectionInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(20),
      ),
      child: Container(
        width: double. infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors:  _isConnected
                ? [const Color(0xFF90EE90), const Color(0xFF98D8AA)]
                : [const Color(0xFF87CEEB), const Color(0xFFB0E0E6)],
            begin:  Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment. center,
              children: [
                if (_isScanning)
                  RotationTransition(
                    turns:  _animationController,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape:  BoxShape.circle,
                        border: Border.all(
                          color: Colors.white. withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isConnected
                        ? Icons.check_circle
                        : _isScanning
                        ? Icons.wifi_find
                        : Icons.wifi_off,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isConnected
                  ? 'متصل'
                  : _isScanning
                  ? 'جاري البحث.. .'
                  : 'غير متصل',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isConnected
                  ? _connectedDevice!
                  : _isScanning
                  ? 'يتم البحث عن أجهزة قريبة'
                  :  'ابحث عن جهاز الفسيلة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isScanning
                    ? null
                    :  _isConnected
                    ?  _disconnectDevice
                    : _startScanning,
                style:  ElevatedButton.styleFrom(
                  backgroundColor: _isConnected ? Colors.red : Colors.white,
                  foregroundColor:  _isConnected
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  _isConnected ? 'قطع الاتصال' : 'البحث عن الأجهزة',
                  style:  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedDeviceInfo() {
    return Card(
      child: Padding(
        padding:  const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات الجهاز',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.devices, 'اسم الجهاز', _connectedDevice! ),
            const Divider(),
            _buildInfoRow(Icons.signal_wifi_4_bar, 'قوة الإشارة', 'ممتازة'),
            const Divider(),
            _buildInfoRow(Icons.battery_charging_full, 'البطارية', '85%'),
            const Divider(),
            _buildInfoRow(Icons.update, 'إصدار البرنامج', 'v2.1.0'),
            const Divider(),
            _buildInfoRow(Icons.sd_storage, 'المساحة المتاحة', '2.3 GB'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton. icon(
                    onPressed:  () {
                      _showUpdateDialog();
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('تحديث'),
                  ),
                ),
                const SizedBox(width:  12),
                Expanded(
                  child: OutlinedButton. icon(
                    onPressed:  () {
                      _showDeviceSettingsDialog();
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('إعدادات'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableDevices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الأجهزة المتاحة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (! _isScanning)
              TextButton. icon(
                onPressed: _startScanning,
                icon:  const Icon(Icons.refresh, size: 18),
                label: const Text('تحديث'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isScanning)
          const Center(
            child:  Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري البحث عن الأجهزة... '),
                ],
              ),
            ),
          )
        else if (_devices.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.devices_other,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد أجهزة متاحة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تأكد من تشغيل جهاز الفسيلة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: _devices.map((device) {
              final isCurrentDevice = device['name'] == _connectedDevice;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCurrentDevice
                      ? const BorderSide(color: Color(0xFF90EE90), width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CEEB).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.toys,
                      color: Color(0xFF87CEEB),
                      size: 28,
                    ),
                  ),
                  title: Text(
                    device['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ... List.generate(
                            3,
                                (index) => Icon(
                              Icons.signal_cellular_alt,
                              size: 14,
                              color: index < device['signalStrength']
                                  ? const Color(0xFF90EE90)
                                  : Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'إشارة ${device['signal']}',
                            style:  TextStyle(
                              fontSize:  12,
                              color:  Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        device['lastConnected'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  trailing: isCurrentDevice
                      ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90EE90),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'متصل',
                      style:  TextStyle(
                        color:  Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      :  ElevatedButton(
                    onPressed: () => _connectToDevice(device['name']),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text('اتصال'),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildConnectionInstructions() {
    return Card(
      child: Padding(
        padding:  const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB74D).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    color:  Color(0xFFFFB74D),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تعليمات الاتصال',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              number: '1',
              title:  'تشغيل الجهاز',
              description: 'تأكد من تشغيل جهاز عالم الفسيلة',
            ),
            _buildInstructionStep(
              number: '2',
              title: 'تفعيل البلوتوث',
              description: 'قم بتفعيل البلوتوث على هاتفك',
            ),
            _buildInstructionStep(
              number: '3',
              title: 'البحث والاتصال',
              description: 'اضغط على "البحث عن الأجهزة" واختر جهازك',
            ),
            _buildInstructionStep(
              number: '4',
              title: 'بدء اللعب',
              description: 'بعد الاتصال، يمكن لطفلك بدء اللعب! ',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep({
    required String number,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius:  14,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (! isLast)
              Container(
                width: 2,
                height: 40,
                color: Theme.of(context).colorScheme.primary. withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child:  Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors. grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder:  (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Color(0xFF87CEEB)),
            SizedBox(width: 8),
            Text('تحديث الجهاز'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإصدار الحالي: v2.1.0'),
            SizedBox(height: 8),
            Text('أحدث إصدار: v2.2.0'),
            SizedBox(height: 16),
            Text(
              'التحديث الجديد يتضمن:\n• تحسينات في الأداء\n• محتوى تعليمي جديد\n• إصلاح بعض الأخطاء',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed:  () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحميل التحديث.. .')),
              );
            },
            child: const Text('تحديث الآن'),
          ),
        ],
      ),
    );
  }

  void _showDeviceSettingsDialog() {
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
                'إعدادات الجهاز',
                style:  TextStyle(
                  fontSize:  20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Color(0xFF87CEEB)),
                title: const Text('مستوى الصوت'),
                trailing: SizedBox(
                  width:  150,
                  child: Slider(
                    value: 0.7,
                    onChanged: (value) {},
                    activeColor: const Color(0xFF87CEEB),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Color(0xFFFFB74D)),
                title: const Text('سطوع الشاشة'),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: 0.8,
                    onChanged: (value) {},
                    activeColor: const Color(0xFFFFB74D),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF90EE90)),
                title:  const Text('لغة الجهاز'),
                trailing:  const Text('العربية'),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double. infinity, 50),
                ),
                child: const Text('حفظ الإعدادات'),
              ),
            ],
          ),
        );
      },
    );
  }
}