import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/address_response.model.dart';
import 'package:salama_users/data/models/available_driver.model.dart';
import 'package:salama_users/data/models/book_ride_dto.dart';
import 'package:salama_users/widgets/busy_button.dart';


class AvailableScreen extends StatefulWidget {
  AddressResponse userSelectedTo;
  AddressResponse userSelectedFrom;
  AvailableScreen(
      {super.key,
      required this.userSelectedTo,
      required this.userSelectedFrom});

  @override
  State<AvailableScreen> createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  @override
  void initState() {
    context.read<AuthNotifier>().fetchAvailableDrivers(context,
        latitude: widget.userSelectedFrom.latitude ?? "0.0",
        longitude: widget.userSelectedFrom.longitude ?? "0.0",
        radius: 5000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text("Available Drivers"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: auth.isLoading && auth.drivers.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.primaryColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
                  ),
                )
              : auth.drivers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.drive_eta_sharp,
                            size: 50,
                            color: AppColors.primaryColor,
                          ),
                          Gap(10),
                          Text(
                            "Drivers not found, try again later.",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          Gap(7),
                          ElevatedButton(
                              style: ButtonStyle(
                                  // backgroundBuilder: AppColors.primaryColor
                                  ),
                              onPressed: () async {
                                await auth.fetchAvailableDrivers(context,
                                    radius: 100000,
                                    latitude:
                                        widget.userSelectedFrom.latitude ??
                                            "0.0",
                                    longitude:
                                        widget.userSelectedFrom.longitude ??
                                            "0.0");
                              },
                              child: auth.isLoading
                                  ? CircularProgressIndicator()
                                  : Text("Retry"))
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                      itemCount: auth.drivers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final driver = auth.drivers[index];
                        return Column(children: [
                          Gap(10),
                          ListTile(
                              contentPadding: EdgeInsets.zero,
                              // ignore: deprecated_member_use
                              splashColor: AppColors.grey.withOpacity(0.08),
                              tileColor: AppColors.grey.withOpacity(0.08),
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.lightBlue.withOpacity(0.2),
                                radius: 18,
                                child: driver.profileImage == null ||
                                        driver.profileImage == 'default.png'
                                    ? Icon(Icons.error_outline)
                                    : CachedNetworkImage(
                                        imageUrl: driver.profileImage ?? "",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.red,
                                                    BlendMode.colorBurn)),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                              ),
                              title: Text(
                                  "${driver.firstName ?? ""} ${driver.lastName ?? ""}"),
                              subtitle: Text('${driver.amount ?? "NIL"}'),
                              trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () {
                                      _showDriverTripDetails(
                                          context,
                                          driver,
                                          BookRideDto(
                                              driverId: driver.userId,
                                              riderToLong: double.parse(widget
                                                      .userSelectedTo
                                                      .longitude ??
                                                  "0.0"),
                                              riderToLat: double.parse(
                                                  widget.userSelectedTo.latitude ??
                                                      "0.0"),
                                              riderFromLong: double.parse(widget
                                                      .userSelectedFrom
                                                      .longitude ??
                                                  "0.0"),
                                              driverLongitude: double.parse(
                                                  driver.latitude ?? "0.0"),
                                              driverLatitude: double.parse(
                                                  driver.longitude ?? "0.0"),
                                              riderFromAddress:
                                                  widget.userSelectedFrom.address,
                                              riderToAddress: widget.userSelectedTo.address,
                                              riderFromLat: double.parse(widget.userSelectedFrom.latitude.toString()),
                                              amount: 0));
                                    },
                                    child: const Text(
                                      "Book Now",
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  )))
                        ]);
                      },
                    ),
        ),
      ),
    );
  }

  void _showDriverTripDetails(
      BuildContext context, AvailableDriver driver, BookRideDto payload) {
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
            Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min, // Adjusts size based on content
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driver Details
                    Center(
                      child: Text(
                        'Driver Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.lightBlue.withOpacity(0.2),
                        radius: 18,
                        child: driver.profileImage == null ||
                                driver.profileImage == 'default.png'
                            ? Icon(Icons.error_outline)
                            : CachedNetworkImage(
                                imageUrl: driver.profileImage ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.red, BlendMode.colorBurn)),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),
                      title: Text('${driver.firstName} ${driver.lastName}',
                          style: TextStyle(fontSize: 18)),
                      subtitle: Text('Rating: ★★★★★'),
                    ),
                    Divider(),

                    // Trip Details
                    Center(
                      child: Text(
                        'Trip Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pickup:', style: TextStyle(fontSize: 16)),
                        Text('${widget.userSelectedTo.address}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Destination:', style: TextStyle(fontSize: 16)),
                        Text('${widget.userSelectedTo.address}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Distance:', style: TextStyle(fontSize: 16)),
                        Text('${widget.userSelectedTo.distance} km',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 30),
                    BusyButton(
                        title: "Proceed to book",
                        isLoading: auth.isLoading,
                        onTap: () {
                          logger.d(payload);
                          auth.bookRide(context, payload);
                        })
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
