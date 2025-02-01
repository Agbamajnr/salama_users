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
  final AddressResponse userSelectedTo;
  final AddressResponse userSelectedFrom;

  const AvailableScreen({
    super.key,
    required this.userSelectedTo,
    required this.userSelectedFrom,
  });

  @override
  State<AvailableScreen> createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthNotifier>().fetchAvailableDrivers(
      context,
      latitude: widget.userSelectedFrom.latitude ?? "0.0",
      longitude: widget.userSelectedFrom.longitude ?? "0.0",
      radius: 5000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, auth, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Text('Available Drivers', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: auth.isLoading && auth.drivers.isEmpty
                ? _buildLoadingState()
                : auth.drivers.isEmpty
                ? _buildNoDriversState(auth)
                : _buildDriverList(auth),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoDriversState(AuthNotifier auth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.drive_eta_sharp, size: 50, color: Colors.red),
        const Gap(10),
        const Text(
          "No drivers available, try again later.",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const Gap(20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () async {
            await auth.fetchAvailableDrivers(
              context,
              radius: 100000,
              latitude: widget.userSelectedFrom.latitude ?? "0.0",
              longitude: widget.userSelectedFrom.longitude ?? "0.0",
            );
          },
          child: auth.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Retry", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  Widget _buildDriverList(AuthNotifier auth) {
    return ListView.builder(
      itemCount: auth.drivers.length,
      itemBuilder: (context, index) {
        final driver = auth.drivers[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: AppColors.lightBlue.withOpacity(0.2),
              radius: 20,
              child: ClipOval(
                child: driver.profileImage == null || driver.profileImage == 'default.png'
                    ? const Icon(Icons.person, size: 25)
                    : CachedNetworkImage(
                  imageUrl: driver.profileImage ?? "",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            title: Text(
              "${driver.firstName ?? ""} ${driver.lastName ?? ""}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text("Fare: \$${driver.amount ?? "NIL"}"),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              ),
              onPressed: () => _showDriverTripDetails(context, driver),
              child: const Text("Book Now", style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  void _showDriverTripDetails(BuildContext context, AvailableDriver driver) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer<AuthNotifier>(
          builder: (context, auth, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Driver Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.lightBlue.withOpacity(0.2),
                    radius: 30,
                    child: ClipOval(
                      child: driver.profileImage == null || driver.profileImage == 'default.png'
                          ? const Icon(Icons.person, size: 30)
                          : CachedNetworkImage(
                        imageUrl: driver.profileImage ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                    '${driver.firstName} ${driver.lastName}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Rating: ★★★★★'),
                ),
                const Divider(),
                const Text(
                  'Trip Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                _buildTripDetail("Pickup:", widget.userSelectedFrom.address ?? "N?A"),
                _buildTripDetail("Destination:", widget.userSelectedTo.address ?? "N/A"),
                _buildTripDetail("Distance:", '${widget.userSelectedTo.distance ?? "N/A"} km'),
                const Gap(30),
                BusyButton(
                  title: "Proceed to book",
                  isLoading: auth.isLoading,
                  onTap: () {
                    final payload = BookRideDto(
                      driverId: driver.userId,
                      riderToLong: double.parse(widget.userSelectedTo.longitude ?? "0.0"),
                      riderToLat: double.parse(widget.userSelectedTo.latitude ?? "0.0"),
                      riderFromLong: double.parse(widget.userSelectedFrom.longitude ?? "0.0"),
                      driverLongitude: double.parse(driver.latitude ?? "0.0"),
                      driverLatitude: double.parse(driver.longitude ?? "0.0"),
                      riderFromAddress: widget.userSelectedFrom.address,
                      riderToAddress: widget.userSelectedTo.address,
                      riderFromLat: double.parse(widget.userSelectedFrom.latitude.toString()),
                      amount: 0,
                    );
                    logger.d(payload);
                    auth.bookRide(context, payload);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTripDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
