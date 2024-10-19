import 'package:get_it/get_it.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/firebase_hander.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<DioManager>(DioManager(''));
  getIt.registerSingleton<ErrorHandler>(ErrorHandler());


  getIt.registerSingleton<DBService>(DBService());

  // getIt.registerLazySingleton<FirebaseHandler>(
  //         () => FirebaseHandler()
  // );
  //
  // await getIt<FirebaseHandler>().init();
}
