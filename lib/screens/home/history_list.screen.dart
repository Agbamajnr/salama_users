import 'package:flutter/material.dart';
import 'package:salama_users/constants/colors.dart';

class RideHistoryScreen extends StatelessWidget {
  final List<RideHistoryItem> rideHistory = List.generate(
    10,
    (index) => RideHistoryItem(
      date: '7 Sep, 17:45 PM',
      address: '1A Atekong Street, Calabar',
      amount: '\$26.65',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
        itemCount: rideHistory.length,
        itemBuilder: (context, index) {
          return _buildRideHistoryCard(rideHistory[index]);
        },
      ),
    );
  }

  Widget _buildRideHistoryCard(RideHistoryItem ride) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        color: AppColors.grey.withOpacity(0.09),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child:
                const Icon(Icons.directions_car, color: AppColors.primaryColor),
          ),
          title: Text(ride.address),
          subtitle: Text(ride.date),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ride.amount,
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
