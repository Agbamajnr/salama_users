import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/functions.dart';
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
    context.read<AuthNotifier>().fetchAllTrips(context, skip: 0, limit: 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) =>
       Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'History',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body:
        auth.isLoading && auth.trips.isEmpty ? Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.primaryColor,
            valueColor:
            AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
          ),
        ) : auth.trips.isEmpty ?
        Center(
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
                "Trips not found, try again later.",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700
                ),),
              Gap(7),
              ElevatedButton(
                  style: ButtonStyle(
                    // backgroundBuilder: AppColors.primaryColor
                  ),
                  onPressed: () async {
                    final results = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddressSearchScreen()),
                    );
                  },
                  child: auth.isLoading
                      ? CircularProgressIndicator()
                      : Text("Book A trip")
              )
            ],
          ),
        ) :
        ListView.builder(
          itemCount: auth.trips.length,
          itemBuilder: (context, index) {
            return _buildRideHistoryCard(context,auth.trips[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRideHistoryCard(BuildContext context, Trip ride) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        color: AppColors.grey.withOpacity(0.09),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingleTrip(trip: ride)),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child:
                const Icon(Icons.directions_car, color: AppColors.primaryColor),
          ),
          title: Text('${ride.riderToAddress}', style: TextStyle(
            fontWeight: FontWeight.w700
          ),),
          subtitle: Text('${Functions.getFormattedDate(ride.createdAt!)}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('${ride.amount}',
              //     style: const TextStyle(fontWeight: FontWeight.bold)),
              // const SizedBox(height: 5),
              ride.rideStatus != BookingStatus.COMPLETED ?  Icon(Icons.arrow_forward_ios_outlined, size: 16,) : InkWell(
                onTap: (){
                  if(ride.id == null)return;
                  _showTripReport(context, ride.id!);
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        color: ride.rideStatus == BookingStatus.COMPLETED ? AppColors.primaryColor: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      ride.rideStatus == BookingStatus.COMPLETED ? "Report" : "Cancel",
                      style: TextStyle(color: AppColors.white),
                    ))

                ,
              )
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adjusts size based on content
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Driver Details
                      Center(
                        child: Text(
                          'Report Trip',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _reportMessageController,
                        maxLines: 3,
                        validator: (value){
                          if(value == null)return "message is empty";
                          if(value.isEmpty){
                            return "Add a message";
                          }
                          if(value.length > 200){
                            return "length cannot be more than 200 characters";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 30),
                      BusyButton(
                          title: "Report",
                          isLoading: auth.isLoading,
                          onTap: () {
                            if(_formKey.currentState!.validate()){
                              auth.reportTrip(context, tripId, _reportMessageController.text.trim());
                              _reportMessageController.clear();
                            }

                          })
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

