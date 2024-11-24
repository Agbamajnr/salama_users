import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/services/local_notification.service.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/trips_model.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/widgets/busy_button.dart';
import 'firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHandler {
  Future<void> init() async {
    await Firebase.initializeApp(
      name: 'com.salama.users_app',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final fcmToken = await FirebaseMessaging.instance.getToken().then((value) {
      logger.wtf(value);
    }

    ).catchError((e) => logger.e(e));
    // debugPrint("FCMToken $fcmToken");
    logger.wtf(fcmToken);
    await getIt<DBService>().saveFirebaseToken(fcmToken.toString());
  }

    // debugPrint("FCMToken $fcmToken");
    // await getIt<DBService>().saveFirebaseToken(fcmToken.toString());
  }






class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  BuildContext? _context;

  Future initialize(BuildContext context) async {
    _context = context;
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message?.notification != null) {
        final Map<String, dynamic> data;
        data = message!.data;
        logger.wtf(data);
        LocalNtificationService().showLocalNotification(message.notification!);
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final Map<String, dynamic> data;
      data = message.data;
      logger.wtf(data);
      _handleForegroundMessage(message);
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationOpen(message);
    });
  }

  Trip? _trip;

  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();

  bool _isLoading = false;

  void _handleForegroundMessage(RemoteMessage message) {
    if (_context != null && _context!.mounted) {
      final Map<String, dynamic> data;
      data = message.data;
      logger.wtf(data);
      if(data['event_type'] != null && data['tripId'] != null){
        _context!.read<AuthNotifier>().fetchTrip(_context, data['tripId']);
        showTripDetails(_context!, data['tripId'], _trip);
      }else{
        showDialog(
          barrierColor: Theme.of(_context!).colorScheme.brightness == Brightness.light ? Colors.transparent .withOpacity(0.6) : const Color(0xff110C00).withOpacity(0.8),
          context: _context!, builder:(context) {
          return deleteDialog(context, message);
        },);
      }
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    // Handle navigation when notification is tapped
    if (_context != null && _context!.mounted) {
      // Add your navigation logic here
      print("Notification tapped: ${message.notification?.title}");
    }


    Future<String?> getToken() async {
      String? token = await _fcm.getToken();
      return token;
    }

    Future<void> backgroundHandler(RemoteMessage message) async {

    }
  }





  void showTripDetails(BuildContext context, String tripId, Trip? trip) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      // isDismissible: context.read<AuthNotifier>().isLoading,
      builder: (BuildContext context) {
        return Consumer<AuthNotifier>(
          builder: (context, AuthNotifier auth, child) => Wrap(children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjusts size based on content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driver Details
                    Center(
                      child: Text(
                        'Trip Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white
                      ),
                      child: Consumer<AuthNotifier>(
                        builder: (context, AuthNotifier auth, child) =>  RefreshIndicator(
                          onRefresh:(){
                            return auth.fetchTrip(context, tripId);
                          },
                          child:_isLoading == true && _trip == null ? Center(child: CircularProgressIndicator()) :
                          _trip == null ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline_outlined, color: Colors.red,),
                                Text("Error fetching trips!", style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red
                                ),)
                              ],
                            ),
                          ) :
                          SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),

                                // Driver Details
                                Text(
                                  'Driver Details',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                ListTile(
                                  // leading: _trip.driver.== null ||
                                  //     user.profileImage == 'default.png'
                                  //     ? Icon(Icons.error_outline)
                                  //     : CachedNetworkImage(
                                  //   imageUrl: user.profileImage ?? "",
                                  //   imageBuilder: (context, imageProvider) => Container(
                                  //     decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //         image: imageProvider,
                                  //         fit: BoxFit.cover,
                                  //         // colorFilter:
                                  //         // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   placeholder: (context, url) =>
                                  //       CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                                  // ),

                                  title: Text("${_trip?.driver?.name}"),
                                  subtitle: Text("${_trip?.driver?.phone}"),
                                  trailing: InkWell(
                                      onTap: () async{
                                        await EasyLauncher.call(number: "${_trip?.driver?.phone}");
                                      },
                                      child: Icon(Icons.call)),
                                ),
                                SizedBox(height: 10),
                                Text('Plate Number: ${_trip?.driver?.plateNo == null  ? "N/A" : _trip?.driver!.plateNo}'),
                                Divider(),

                                // Trip Details
                                Text(
                                  'Trip Details',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('From:', style: TextStyle(fontSize: 16)),
                                    Text('${_trip?.riderFromAddress}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('To:', style: TextStyle(fontSize: 16)),
                                    Text('${_trip?.riderToAddress}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Fare:', style: TextStyle(fontSize: 16)),
                                    Text('\₦${'${_trip?.amount}'}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ride Status:', style: TextStyle(fontSize: 16)),
                                    Text('${_trip?.rideStatus}', style: TextStyle(fontSize: 16, color: Colors.green)),
                                  ],
                                ),
                                SizedBox(height: 20),

                                // Ride Time Details
                                _trip?.startTime == null ? Container() : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ride Start Time:', style: TextStyle(fontSize: 16)),
                                    Text('${_trip?.startTime}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                _trip?.endTime == null ? Container() : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ride End Time:', style: TextStyle(fontSize: 16)),
                                    Text('${_trip?.endTime}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                Gap(50),
                                // Spacer(),
                                _trip?.rideStatus == "BOOKING" ? BusyButton(
                                    title: "Cancel",
                                    // isLoading: _isLoading,
                                    color: Colors.red.withOpacity(0.9),
                                    onTap:(){
                                      if(_trip?.id == null)return;
                                      // declineTrip(context, _trip!.id!);
                                    }): Container(),
                                _trip?.rideStatus == "COMPLETED" || _trip?.rideStatus == "DRIVING" ? BusyButton(
                                    title: "Report.",
                                    color: AppColors.primaryColor,
                                    onTap:(){

                                    }): Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(20),
                    // BusyButton(
                    //     title: "Procced",
                    //     isLoading: auth.isLoading,
                    //     onTap: () {
                    //       auth.fetchTrip(context, tripId);
                    //     })
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}


Widget deleteDialog(BuildContext context, RemoteMessage message) {
  bool _isProcessing = false;
  final Map<String, dynamic> data;
  data = message.data;
  logger.wtf(data);

  return Dialog(
    insetPadding: const EdgeInsets.all(10),
    child: AbsorbPointer(
      absorbing: _isProcessing,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8)
              ),
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.red, size: 40,),
                      Gap(10),
                      Text(
                        message.notification?.title ?? "",
                        style: TextStyle(
                          // fontFamily: AppFonts.mulishRegular,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          // color: AppColors.black,
                        ),
                      ),
                      Gap(18),
                      Text(
                        message.notification?.body ?? "",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: Color(0xff6D6D6D),
                          // fontFamily: AppFonts.mulishRegular,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          // color: AppColors.textColor,
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),

                  const Gap(24),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          //  Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor,
                          ),
                          child: SizedBox(
                            height: 15,
                            child:  Center(
                              child: Text(
                                "Dismiss",
                                style: TextStyle(
                                  // fontFamily: AppFonts.mulishRegular,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
                      Consumer<AuthNotifier>(
                          builder: (context, AuthNotifier user, child) {
                            return InkWell(
                              onTap: () async {
                                await user.deleteAccount(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.primaryColor
                                    // width: 1,
                                    // color: AppColors.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SizedBox(
                                  height:15,
                                  child: Center(
                                    child: Text("Proceed", style: TextStyle(
                                      color: AppColors.background
                                    ),),
                                  )
                                ),
                              ),
                            );
                          }
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}