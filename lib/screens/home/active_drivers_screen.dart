import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
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
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  bool _isLoading = true;

  // Fallback location: Calabar, Nigeria
  final LatLng _fallbackLocation = const LatLng(4.9757, 8.3417);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    if (context.mounted) {
      context.read<AuthNotifier>().getCurrentLocation(context);
      context.read<AuthNotifier>().fetchAvailableDrivers(
        context,
        latitude: "333",
        longitude: "211121",
        radius: 50000,
      );
    }
  }

  Future<void> _getUserLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isLoading = false;
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
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isLoading = false;
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
        logger.d(_currentLocation);
        _isLoading = false;
      });
    } catch (e) {
      // If an error occurs (e.g., timeout), use fallback location
      setState(() {
        _currentLocation = _fallbackLocation;
        _isLoading = false;
      });
      logger.e("Error fetching location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? _fallbackLocation, // Use fallback location if current location is null
                zoom: 14.0,
              ),
              myLocationEnabled: true, // Show the user's location on the map
              myLocationButtonEnabled: true, // Show the "my location" button
              markers: _currentLocation != null
                  ? {
                Marker(
                  markerId: const MarkerId("user_location"),
                  position: _currentLocation!,
                  infoWindow: const InfoWindow(title: "Your Current Location"),
                ),
              }
                  : {},
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: const BoxDecoration(color: AppColors.white),
                child: Column(
                  children: [
                    const Gap(15),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300), // Animation duration
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const AddressSearchScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0); // Start from bottom
                              const end = Offset.zero; // End at default position
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.grey.withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Where To",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}