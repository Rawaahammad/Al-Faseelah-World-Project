import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
        _resendCountdown = 60;
      });

      _startResendCountdown();
    }
  }

  void _startResendCountdown() {
    Future. doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        return true;
      }
      return false;
    });
  }

  Future<void> _resendEmail() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _resendCountdown = 60;
    });

    _startResendCountdown();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إعادة إرسال البريد الإلكتروني'),
          backgroundColor: Color(0xFF90EE90),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent ?  _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // الأيقونة
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB).withOpacity(0.15),
              shape: BoxShape. circle,
            ),
            child: const Icon(
              Icons.lock_reset,
              size: 60,
              color: Color(0xFF87CEEB),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // العنوان
        const Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            fontSize:  28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height:  12),
        Text(
          'لا تقلق!  أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height:  40),

        // نموذج البريد الإلكتروني
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'الرجاء إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),

              const SizedBox(height:  32),

              // زر إرسال
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ?  null : _resetPassword,
                  style: ElevatedButton. styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height:  20,
                    width:  20,
                    child:  CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'إرسال رابط الاستعادة',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height:  24),

        // العودة لتسجيل الدخول
        TextButton. icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('العودة لتسجيل الدخول'),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        // أيقونة النجاح
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF90EE90).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read,
              size: 80,
              color: Color(0xFF90EE90),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // رسالة النجاح
        const Text(
          'تم إرسال البريد! ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'تم إرسال رابط استعادة كلمة المرور إلى: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF87CEEB),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height:  32),

        // تعليمات
        Card(
          child: Padding(
            padding:  const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInstructionItem(
                  '1',
                  'تحقق من صندوق الوارد في بريدك الإلكتروني',
                  Icons.inbox,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  '2',
                  'اضغط على رابط استعادة كلمة المرور',
                  Icons. link,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(
                  '3',
                  'أدخل كلمة المرور الجديدة',
                  Icons.lock_open,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ملاحظة
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB74D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFFB74D).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFFFB74D)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'إذا لم تجد البريد، تحقق من مجلد الرسائل غير المرغوب فيها (Spam)',
                  style:  TextStyle(
                    fontSize: 13,
                    color: Colors. grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height:  32),

        // إعادة الإرسال
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لم يصلك البريد؟',
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed:
              _resendCountdown > 0 || _isLoading ? null : _resendEmail,
              child: Text(
                _resendCountdown > 0
                    ? 'إعادة الإرسال ($_resendCountdown)'
                    : 'إعادة الإرسال',
              ),
            ),
          ],
        ),

        const SizedBox(height:  16),

        // العودة لتسجيل الدخول
        OutlinedButton. icon(
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('العودة لتسجيل الدخول'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String number, String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF87CEEB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style:  TextStyle(
              fontSize: 14,
              color: Colors. grey[700],
            ),
          ),
        ),
      ],
    );
  }
}