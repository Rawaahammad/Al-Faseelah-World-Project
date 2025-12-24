import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (! _agreeToTerms) {
        ScaffoldMessenger. of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب الموافقة على الشروط والأحكام'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF90EE90).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: Color(0xFF90EE90),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تم إنشاء الحساب بنجاح! ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'مرحباً ${_nameController.text}، يمكنك الآن تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator. pop(context);
                  Navigator. pushReplacementNamed(context, '/login');
                },
                child: const Text('تسجيل الدخول'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'إنشاء حساب جديد',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle:  true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // مؤشر التقدم
                _buildProgressIndicator(),
                const SizedBox(height: 32),

                // محتوى الخطوة الحالية
                _buildStepContent(),
                const SizedBox(height:  32),

                // أزرار التنقل
                _buildNavigationButtons(),
                const SizedBox(height: 24),

                // رابط تسجيل الدخول
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Colors. grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ?  Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      index == 0
                          ? 'البيانات'
                          : index == 1
                          ? 'الأمان'
                          : 'التأكيد',
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < _currentStep
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildSecurityStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'البيانات الشخصية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height:  8),
        Text(
          'أدخل بياناتك الشخصية لإنشاء حسابك',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // الاسم
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization. words,
          decoration: const InputDecoration(
            labelText:  'الاسم الكامل',
            hintText: 'أدخل اسمك الكامل',
            prefixIcon: Icon(Icons.person_outlined),
          ),
          validator:  (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال الاسم';
            }
            if (value.length < 3) {
              return 'الاسم يجب أن يكون 3 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // البريد الإلكتروني
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            hintText: 'example@email.com',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (value) {
            if (value == null || value. isEmpty) {
              return 'الرجاء إدخال البريد الإلكتروني';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'الرجاء إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // رقم الهاتف
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف (اختياري)',
            hintText: '+966 5X XXX XXXX',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment. start,
      children: [
        const Text(
          'إعدادات الأمان',
          style: TextStyle(fontSize: 20, fontWeight:  FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'أنشئ كلمة مرور قوية لحماية حسابك',
          style: TextStyle(color: Colors. grey[600]),
        ),
        const SizedBox(height:  24),

        // كلمة المرور
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال كلمة المرور';
            }
            if (value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        // مؤشر قوة كلمة المرور
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),

        // تأكيد كلمة المرور
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'تأكيد كلمة المرور',
            hintText: '••••••••',
            prefixIcon: const Icon(Icons. lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء تأكيد كلمة المرور';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    String password = _passwordController.text;
    double strength = 0;
    String strengthText = 'ضعيفة';
    Color strengthColor = Colors.red;

    if (password.length >= 6) strength += 0.25;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;

    if (strength <= 0.25) {
      strengthText = 'ضعيفة';
      strengthColor = Colors.red;
    } else if (strength <= 0.5) {
      strengthText = 'متوسطة';
      strengthColor = Colors.orange;
    } else if (strength <= 0.75) {
      strengthText = 'جيدة';
      strengthColor = Colors.lightGreen;
    } else {
      strengthText = 'قوية';
      strengthColor = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text(
              'قوة كلمة المرور',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              strengthText,
              style: TextStyle(
                fontSize:  12,
                color: strengthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildPasswordHint('6 أحرف', password.length >= 6),
            _buildPasswordHint('حرف كبير', password. contains(RegExp(r'[A-Z]'))),
            _buildPasswordHint('رقم', password.contains(RegExp(r'[0-9]'))),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordHint(String text, bool isValid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons. check_circle : Icons.circle_outlined,
          size: 14,
          color: isValid ?  Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isValid ?  Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تأكيد البيانات',
          style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'راجع بياناتك قبل إنشاء الحساب',
          style:  TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // ملخص البيانات
        Card(
          child: Padding(
            padding:  const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryItem('الاسم', _nameController.text, Icons.person),
                const Divider(),
                _buildSummaryItem('البريد', _emailController.text, Icons. email),
                if (_phoneController.text.isNotEmpty) ...[
                  const Divider(),
                  _buildSummaryItem('الهاتف', _phoneController. text, Icons.phone),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // الموافقة على الشروط
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child:  Checkbox(
                value: _agreeToTerms,
                onChanged:  (value) {
                  setState(() {
                    _agreeToTerms = value! ;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:  Wrap(
                children: [
                  const Text('أوافق على '),
                  GestureDetector(
                    onTap: () => _showTermsDialog(),
                    child:  const Text(
                      'الشروط والأحكام',
                      style: TextStyle(
                        color: Color(0xFF87CEEB),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(' و'),
                  GestureDetector(
                    onTap:  () => _showPrivacyDialog(),
                    child: const Text(
                      'سياسة الخصوصية',
                      style: TextStyle(
                        color: Color(0xFF87CEEB),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:  const Text('السابق'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed:  _isLoading
                ? null
                : () {
              if (_currentStep < 2) {
                if (_formKey.currentState! .validate()) {
                  setState(() {
                    _currentStep++;
                  });
                }
              } else {
                _register();
              }
            },
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
                : Text(_currentStep < 2 ? 'التالي' : 'إنشاء حساب'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الشروط والأحكام'),
        content: const SingleChildScrollView(
          child:  Text(
            'شروط وأحكام استخدام تطبيق عالم الفسيلة:\n\n'
                '1. يجب أن يكون المستخدم ولي أمر الطفل أو وصيه القانوني.\n\n'
                '2. يتحمل ولي الأمر مسؤولية استخدام التطبيق ومراقبة تفاعل الطفل.\n\n'
                '3. نحافظ على خصوصية بيانات الأطفال ولا نشاركها مع أطراف ثالثة.\n\n'
                '4. المحتوى التعليمي مصمم للأطفال من 3-12 سنة.\n\n'
                '5. يحق لنا تحديث الشروط والأحكام مع إشعار المستخدمين.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'سياسة الخصوصية لتطبيق عالم الفسيلة:\n\n'
                '• نجمع البيانات الضرورية فقط لتقديم الخدمة.\n\n'
                '• لا نشارك بيانات الأطفال مع أطراف ثالثة.\n\n'
                '• يمكنك طلب حذف بياناتك في أي وقت.\n\n'
                '• نستخدم تشفير عالي المستوى لحماية البيانات.\n\n'
                '• نحتفظ بالبيانات فقط للمدة اللازمة لتقديم الخدمة.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}