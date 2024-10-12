import 'package:flutter/material.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/screens/auth/login_screen.dart';
import 'package:salama_users/screens/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> runNavigate() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => true);
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), runNavigate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(child: Image.asset("assets/logo.png")),
      ),
    );
  }
}
