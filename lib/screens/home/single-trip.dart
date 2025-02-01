import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/trips_model.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
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

class SingleTrip extends StatefulWidget {
  Trip? trip;
  SingleTrip({super.key, required this.trip});

  @override
  State<SingleTrip> createState() => _SingleTripState();
}

class _SingleTripState extends State<SingleTrip> {
  bool _isLoading = false;
  Trip? _trip;

  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  final _db = getIt<DBService>();

  Future<void> fetchTrip(id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      logger.d(id);
      Response response = await _api.dio.get('/taxi/booking/${id}');

      if (response.statusCode == 200) {
        logger.w(response.data['data']);
        if (response.data['data'] == null) {
          widget.trip = null;
          _trip = null;
        } else {
          final result = Trip.fromJson(response.data['data']);
          if (!mounted) return;
          setState(() {
            _trip = result;
            widget.trip = result;
          });
        }
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
      if (!mounted) return;
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
      Response response = await _api.dio
          .put('/taxi/booking/drivers/decline', data: {"tripId": tripId});
      logger.d(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _trip = Trip.fromJson(response.data['data']);
        });
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

  String getBooking(status) {
    switch (status) {
      case BookingStatus.BOOKING:
        return "BOOKING";
      case BookingStatus.DRIVER_ACCEPTED:
        return "DRIVER ACCEPTED";
      case BookingStatus.DRIVING:
        return "DRIVING";
      case BookingStatus.RIDER_CANCELLED:
        return "RIDER CANCELLED";
      case BookingStatus.COMPLETED:
        return "COMPLETED";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Ride Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              fetchTrip(widget.trip?.id);
            },
          ),
        ],
      ),
      body: Consumer<AuthNotifier>(
        builder: (context, AuthNotifier auth, child) => RefreshIndicator(
          onRefresh: () {
            return fetchTrip(widget.trip?.id);
          },
          child: _isLoading && _trip == null
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
              : _trip == null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 50,
                ),
                const Gap(10),
                const Text(
                  "Error fetching trip details!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
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
                  onPressed: () {
                    fetchTrip(widget.trip?.id);
                  },
                  child: const Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver Details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Driver Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                            size: 30,
                          ),
                          title: Text(
                            _trip?.driver?.name ?? "Unknown Driver",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _trip?.driver?.phone ?? "N/A",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'Plate Number: ${_trip?.driver?.plateNo ?? "N/A"}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),

                // Trip Details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trip Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        _buildDetailRow(
                          label: 'From:',
                          value: _trip?.riderFromAddress ?? "N/A",
                        ),
                        const Gap(10),
                        _buildDetailRow(
                          label: 'To:',
                          value: _trip?.riderToAddress ?? "N/A",
                        ),
                        const Gap(10),
                        _buildDetailRow(
                          label: 'Fare:',
                          value: '\₦${_trip?.amount ?? "N/A"}',
                        ),
                        const Gap(10),
                        _buildDetailRow(
                          label: 'Status:',
                          value: getBooking(_trip?.rideStatus),
                          valueColor: Colors.green,
                        ),
                        if (_trip?.startTime != null) ...[
                          const Gap(10),
                          _buildDetailRow(
                            label: 'Start Time:',
                            value: _trip!.startTime!,
                          ),
                        ],
                        if (_trip?.endTime != null) ...[
                          const Gap(10),
                          _buildDetailRow(
                            label: 'End Time:',
                            value: _trip!.endTime!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Gap(30),

                // Action Buttons
                if (_trip?.rideStatus == "BOOKING")
                  BusyButton(
                    title: "Cancel Trip",
                    isLoading: _isLoading,
                    color: Colors.red,
                    onTap: () {
                      if (_trip?.id == null) return;
                      declineTrip(context, _trip!.id!);
                    },
                  ),
                if (_trip?.rideStatus == "COMPLETED" ||
                    _trip?.rideStatus == "DRIVING")
                  BusyButton(
                    title: "Report Issue",
                    isLoading: _isLoading,
                    color: AppColors.primaryColor,
                    onTap: () {
                      // Handle report issue
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}