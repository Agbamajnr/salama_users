import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/screens/auth/login_screen.dart';
import 'package:salama_users/screens/home/home.dart';
import 'package:salama_users/screens/home/loading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final _db = getIt<DBService>();
  Future<void> runNavigate() async {

    if( await _db.getToken() == null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => true);
    }else{
      final user = context.read<AuthNotifier>();
      await context.read<AuthNotifier>().fetchAccount(context);
      if(user.user != null){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => true);
      }else{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoadingScreen()),
                (Route<dynamic> route) => true);
      }

    }

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
