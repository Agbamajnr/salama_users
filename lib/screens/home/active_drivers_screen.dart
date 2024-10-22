import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/screens/home/address_search_screen.dart';

class NearbyDriversScreen extends StatefulWidget {
  const NearbyDriversScreen({super.key});

  @override
  _NearbyDriversScreenState createState() => _NearbyDriversScreenState();
}

class _NearbyDriversScreenState extends State<NearbyDriversScreen> {


  @override
  void initState() {
    if(context.mounted){
      context.read<AuthNotifier>().dashboard(context,
          longitude: "6.99",
          latitude: "4.66",
          isActive: false,
          firebaseToken: "dkhgjhgfeguyghuiegfguhufgih"
      );
      context.read<AuthNotifier>().getCurrentLocation(context);
      context.read<AuthNotifier>().fetchAvailableDrivers(context, latitude: "333", longitude: "211121", radius: 50000);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) =>
       Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/maps.png",
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
            Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Column(
                children: [
                  Gap(15),
                  InkWell(
                    onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddressSearchScreen()),
                          );

                    },
                    child: Container(

                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey.withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text(
                        "Where To",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey.withOpacity(0.9)
                        ),
                      ),
                    ),
                  ),


                  // TextFormField(
                  //   onTap: () async{
                  //     FocusScopeNode currentFocus = FocusScope.of(context);
                  //     if (!currentFocus.hasPrimaryFocus &&
                  //         currentFocus.focusedChild != null) {
                  //       currentFocus.focusedChild?.unfocus();
                  //     }
                  //     final results = await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const AddressSearchScreen()),
                  //     );
                  //
                  //     logger.d(results);
                  //
                  //   },
                  //   decoration: const InputDecoration(
                  //     labelText: 'Where To',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  Gap(20),
                  // ListView.builder(
                  //   itemCount: auth.drivers.length,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) {
                  //     final driver = auth.drivers[index];
                  //     return ListTile(
                  //         contentPadding: EdgeInsets.zero,
                  //         // ignore: deprecated_member_use
                  //         splashColor: AppColors.grey.withOpacity(0.08),
                  //         tileColor: AppColors.grey.withOpacity(0.08),
                  //         leading: CircleAvatar(
                  //           radius: 18,
                  //           child: driver.profileImage == null || driver.profileImage == 'default.png' ?
                  //           Icon(Icons.error_outline) :
                  //           CachedNetworkImage(
                  //             imageUrl: driver.profileImage ?? "",
                  //             imageBuilder: (context, imageProvider) => Container(
                  //               decoration: BoxDecoration(
                  //                 image: DecorationImage(
                  //                     image: imageProvider,
                  //                     fit: BoxFit.cover,
                  //                     colorFilter:
                  //                     ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                  //               ),
                  //             ),
                  //             placeholder: (context, url) => CircularProgressIndicator(),
                  //             errorWidget: (context, url, error) => Icon(Icons.error),
                  //           ),
                  //         ),
                  //         title: Text("${driver.firstName ?? ""} ${driver.lastName ?? ""}"),
                  //         subtitle:
                  //             Text('${driver.amount ?? "NIL"}'),
                  //         trailing: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 6, vertical: 3),
                  //             decoration: BoxDecoration(
                  //                 color: AppColors.primaryColor,
                  //                 borderRadius: BorderRadius.circular(5)),
                  //             child: const Text(
                  //               "Book Now",
                  //               style: TextStyle(color: AppColors.white),
                  //             )));
                  //   },
                  // ),
                ],
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }
}

class Driver {
  final String name;
  final double rating;
  final String car;
  final double price;

  Driver({
    required this.name,
    required this.rating,
    required this.car,
    required this.price,
  });
}
