import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/functions.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/trips_model.dart';
import 'package:salama_users/screens/home/address_search_screen.dart';
import 'package:salama_users/screens/home/single-trip.dart';
import 'package:salama_users/widgets/busy_button.dart';

class RideHistoryScreen extends StatefulWidget {
  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    logger.d("Initializing RideHistoryScreen");

    // Use WidgetsBinding to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger.d("Fetching trips after frame is rendered");
      context.read<AuthNotifier>().fetchAllTrips(context, skip: 0, limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Ride History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                context.read<AuthNotifier>().fetchAllTrips(context, skip: 0, limit: 10);
              },
            ),
          ],
        ),
        body: auth.isLoading && auth.trips.isEmpty
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        )
            : auth.trips.isEmpty
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
              const Gap(10),
              const Text(
                "No trips found, try again later.",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final results = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressSearchScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Book A Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: auth.trips.length,
          itemBuilder: (context, index) {
            return _buildRideHistoryCard(context, auth.trips[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRideHistoryCard(BuildContext context, Trip ride) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleTrip(trip: ride),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.riderToAddress ?? "Unknown Destination",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      Functions.getFormattedDate(ride.createdAt!),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (ride.rideStatus != BookingStatus.COMPLETED)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    )
                  else
                    InkWell(
                      onTap: () {
                        if (ride.id == null) return;
                        _showTripReport(context, ride.id!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _reportMessageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showTripReport(BuildContext context, String tripId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer<AuthNotifier>(
          builder: (context, AuthNotifier auth, child) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Report Trip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _reportMessageController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a message";
                        }
                        if (value.length > 200) {
                          return "Message cannot exceed 200 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    BusyButton(
                      title: "Submit Report",
                      isLoading: auth.isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          auth.reportTrip(
                            context,
                            tripId,
                            _reportMessageController.text.trim(),
                          );
                          _reportMessageController.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}