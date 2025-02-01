import 'package:dio/dio.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
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

class OnBookingScreen extends StatefulWidget {
  Trip? trip;
  OnBookingScreen({super.key, this.trip});

  @override
  State<OnBookingScreen> createState() => _OnBookingScreenState();
}

class _OnBookingScreenState extends State<OnBookingScreen> {
  bool _isLoading = false;
  Trip? _trip;

  late GoogleMapController mapController;
  LatLng? _currentLocation;
  bool _isMapLoading = true;

  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  final _db = getIt<DBService>();

  // Fallback location: Calabar, Nigeria
  final LatLng _fallbackLocation = const LatLng(4.9757, 8.3417);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    fetchTrip(widget.trip?.id);
  }

  Future<void> _getUserLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isMapLoading = false;
      });
      return;
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, use fallback location
        setState(() {
          _currentLocation = _fallbackLocation;
          _isMapLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isMapLoading = false;
      });
      return;
    }

    // Fetch the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isMapLoading = false;
      });
    } catch (e) {
      // If an error occurs (e.g., timeout), use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isMapLoading = false;
      });
      logger.e("Error fetching location: $e");
    }
  }

  Future<void> fetchTrip(id)async {
    logger.d("running fetch trip");
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? _fallbackLocation,
              zoom: 14.0,
            ),
            myLocationEnabled: true, // Show the user's location on the map
            myLocationButtonEnabled: true, // Show the "my location" button
            markers: _currentLocation != null
                ? {
              Marker(
                markerId: const MarkerId("user_location"),
                position: _currentLocation!,
                infoWindow: const InfoWindow(title: "Your Location"),
              ),
            }
                : {},
          ),

          // Loading indicator for map
          if (_isMapLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Bottom Container
          RefreshIndicator(
            onRefresh:() async{
              return await fetchTrip(widget.trip?.id);
            },
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trip Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            await fetchTrip(widget.trip?.id);
                          },
                          child: Icon(Icons.refresh_outlined),
                        )
                      ],
                    ),
                    const Gap(10),
                    if (_trip != null) ...[
                      _trip?.driver == null ? Container() : Divider(),
                      // Driver Details
                      _trip?.driver == null ? Container()  : Text(
                        'Driver Details',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 10),
                      _trip?.driver == null ? Container()  : ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Name: ${_trip?.driver?.name ?? ""}"),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                              onTap: () async{
                                await EasyLauncher.call(number: "${_trip?.driver?.phone}");
                              },
                              child: Text("Tel: ${_trip?.driver?.phone ?? ""}", style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold
                              ),)),
                        ),
                        trailing: InkWell(
                            onTap: () async{
                              await EasyLauncher.call(number: "${_trip?.driver?.phone}");
                            },
                            child: Icon(Icons.call)),
                      ),
                      SizedBox(height: 10),
                      _trip?.driver == null ? Container() : Text('Plate Number: ${_trip?.driver?.plateNo == null  ? "N/A" : _trip?.driver!.plateNo}'),
                      Divider(),
                      Text('From: ${_trip!.riderFromAddress}'),
                      const Gap(10),
                      Text('To: ${_trip!.riderToAddress}'),
                      const Gap(10),
                      Text('Fare: ₦${_trip!.amount}'),
                      const Gap(10),
                      Text('Status: ${_trip!.rideStatus}'),
                      const Gap(20),
                      if (_trip!.rideStatus == "BOOKING")
                        BusyButton(
                          title: "Cancel Trip",
                          isLoading: _isLoading,
                          color: Colors.red,
                          onTap: () {
                            if(_trip?.id == null)return;
                            declineTrip(context, _trip!.id!);
                            // Handle cancel trip
                          },
                        ),
                      if (_trip!.rideStatus == "COMPLETED" || _trip!.rideStatus == "DRIVING")
                        BusyButton(
                          title: "Report Issue",
                          isLoading: _isLoading,
                          color: AppColors.primaryColor,
                          onTap: () {
                            // Handle report issue
                          },
                        ),
                    ] else if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      const Center(
                        child: Text(
                          "No trip details available.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}