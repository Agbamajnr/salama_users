import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/trips_model.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/widgets/busy_button.dart';

enum BookingStatus {
  BOOKING,
  COMPLETED,
  DRIVING,
  DRIVER_ACCEPTED,
  DRIVER_CANCELLED,
  RIDER_CANCELLED
}

class OnBookingScreen extends StatefulWidget {
  Trip? trip;
  OnBookingScreen({super.key, required this.trip});

  @override
  State<OnBookingScreen> createState() => _OnBookingScreenState();
}

class _OnBookingScreenState extends State<OnBookingScreen> {



  bool _isLoading = false;

  Trip? _trip;

  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  final _db = getIt<DBService>();



  Future<void> fetchTrip(id)async {

    setState(() {
      _isLoading = true;
    });

    try {
      logger.d(id);
      Response response =
      await _api.dio.get('/taxi/booking/${id}');

      if (response.statusCode == 200) {
        logger.w(response.data['data']);
        if(response.data['data'] == null){
          widget.trip = null;
          _trip = null;
        }else{
          final result = Trip.fromJson(response.data['data']);
          if(!mounted)return;
          setState(() {
            _trip = result;
            widget.trip = result;
          });

        }
      } else {
      }
    } on DioException catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });

    }
  }

  //DECLINE TRIP
  Future<void> declineTrip(BuildContext context, String tripId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Response response =
      await _api.dio.put('/taxi/booking/drivers/decline', data: {
        "tripId": tripId
      });
      logger.d(response.data);


      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _trip = Trip.fromJson(response.data['data']);
        });
        Navigator.pop(context);

      } else {
      }
    } on DioException catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });

    }
  }


  @override
  void initState() {
    fetchTrip(widget.trip?.id);
    super.initState();
  }

  var bookingStatus = "";

  String getBooking(status){
    switch (status) {
      case BookingStatus.BOOKING:
        bookingStatus = BookingStatus.BOOKING.toString();
        return bookingStatus;
        break;

      case BookingStatus.DRIVER_ACCEPTED:
        bookingStatus = "DRIVER ACCEPTED";
        return bookingStatus;
        break;

      case BookingStatus.DRIVING:
        bookingStatus = "DRIVING";
        return bookingStatus;
        break;
    // case BookingStatus.RIDER_CANCELLED:
    //   bookingStatus = "COMPLETED";
    //   break;
      case BookingStatus.RIDER_CANCELLED:
        bookingStatus = "RIDER CANCELLED";
        return "RIDER_CANCELLED";
        break;
      case BookingStatus.COMPLETED:
        bookingStatus = "COMPLETED";
        return bookingStatus;
      default:
        return status;
        print(' invalid entry');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white
              ),
              child: Consumer<AuthNotifier>(
                builder: (context, AuthNotifier auth, child) =>  RefreshIndicator(
                  onRefresh:(){
                    return fetchTrip(widget.trip?.id);
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
                          trailing: Icon(Icons.call),
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
                            Text('${getBooking(_trip?.rideStatus)}', style: TextStyle(fontSize: 16, color: Colors.green)),
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
                            isLoading: _isLoading,
                            color: Colors.red.withOpacity(0.9),
                            onTap:(){
                              if(_trip?.id == null)return;
                              declineTrip(context, _trip!.id!);
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
          ],
        ),
      ),
    );
  }
}
