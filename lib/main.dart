// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/services/local_notification.service.dart';
import 'package:salama_users/app/services/navigation_service.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/firebase_hander.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/provider.dart';
import 'package:salama_users/routes/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  logger.d('Handling a background message ${message.notification?.title}');

}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await LocalNtificationService().setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // @override
  // void initState() {
  // }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,

      child: MaterialApp(
          navigatorKey: getIt<NavigationService>().navigatorKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            // Add more locales as needed
          ],
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
