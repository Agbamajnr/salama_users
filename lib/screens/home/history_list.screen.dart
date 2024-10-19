import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/trips_model.dart';
import 'package:salama_users/screens/home/address_search_screen.dart';

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
              MaterialPageRoute(builder: (context) => const AddressSearchScreen()),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child:
                const Icon(Icons.directions_car, color: AppColors.primaryColor),
          ),
          title: Text('${ride.riderToAddress}'),
          subtitle: Text('${ride.createdAt}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${ride.amount}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Report",
                    style: TextStyle(color: AppColors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class RideHistoryItem {
  final String date;
  final String address;
  final String amount;

  RideHistoryItem({
    required this.date,
    required this.address,
    required this.amount,
  });
}
