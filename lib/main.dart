import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  // Simulate OTP verification (replace with actual API call)
  Future<void> _sendOtp() async {
    final phoneNumber = _phoneController.text;
    if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid phone number')));
      return;
    }
    setState(() {
      _isOtpSent = true;
    });
    // In a real app, you would send OTP via SMS here
    print('OTP sent to: $phoneNumber');
  }

  // Simulate OTP verification (replace with actual API call)
  Future<void> _verifyOtp() async {
    final otp = _otpController.text;
    if (otp.length != 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid OTP')));
      return;
    }
    // In a real app, you would verify OTP with backend
    if (otp == '123456') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect OTP')));
    }
  }

  // Skip login and navigate to main screen
  void _skipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login/Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mobile Number Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter your 10-digit mobile number',
                counterText: "",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

            // OTP Input (Visible after OTP is sent)
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter 6-digit OTP',
                  counterText: "",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

            const SizedBox(height: 30),

            // Action Button (Send OTP / Verify OTP)
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
            ),

            const SizedBox(height: 20),

            // Skip Login Button
            TextButton(
              onPressed: _skipLogin,
              child: const Text('Skip Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Main Screen!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text(
                'This is the main content of the app. You can add your app features here.'),
          ],
        ),
      ),
    );
  }
}
