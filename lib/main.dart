// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/services/local_notification.service.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/provider.dart';
import 'package:salama_users/routes/router.dart';

// Future<void> backgroundHandler(RemoteMessage message) async {
//   logger.d('Handling a background message ${message.notification?.title}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await LocalNtificationService().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
              highlightColor: Colors.transparent,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xffFFFFFF),
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
            splashColor: Colors.transparent
          ),
          onGenerateRoute: generateRoute),
    );
  }
}
