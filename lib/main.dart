import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/provider.dart';
import 'package:salama_users/routes/router.dart';

void main() async {
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          onGenerateRoute: generateRoute),
    );
  }
}
