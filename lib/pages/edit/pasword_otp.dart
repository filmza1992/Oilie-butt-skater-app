import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  String? _actualOtp; // ตัวแปรสำหรับเก็บ OTP ที่ส่งไป

  // ฟังก์ชันเพื่อส่ง OTP ไปที่อีเมล
  Future<void> sendOtp(String email) async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    // สุ่ม OTP 6 หลัก
    _actualOtp = (Random().nextInt(900000) + 100000).toString();

    // ตั้งค่า SMTP server
    final smtpServer = gmail('smtp.gmail.com', 'YOUR_EMAIL_PASSWORD');

    // สร้างข้อความอีเมล
    final message = Message()
      ..from = Address('ddza1992@gmail.com')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $_actualOtp';

    // ส่งอีเมล
    try {
      await send(message, smtpServer);
      setState(() {
        _message = 'OTP sent successfully to $email';
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to send OTP: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ฟังก์ชันเพื่อยืนยัน OTP
  void verifyOtp(String inputOtp) {
    if (inputOtp == _actualOtp) {
      setState(() {
        _message = 'OTP is valid. Proceed to reset password.';
        // ที่นี่คุณสามารถเพิ่มฟังก์ชันการรีเซ็ตรหัสผ่านได้
      });
    } else {
      setState(() {
        _message = 'Invalid OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (!_isLoading)
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  if (email.isNotEmpty) {
                    sendOtp(email);
                  }
                },
                child: const Text('Send OTP'),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            if (!_isLoading)
              ElevatedButton(
                onPressed: () {
                  verifyOtp(_otpController.text);
                },
                child: const Text('Verify OTP'),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
