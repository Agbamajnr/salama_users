import 'package:flutter/material.dart';
import 'package:salama_users/data/models/trips_model.dart';

class SingleTrip extends StatefulWidget {
  Trip trip;
  SingleTrip({super.key, required this.trip});

  @override
  State<SingleTrip> createState() => _SingleTripState();
}

class _SingleTripState extends State<SingleTrip> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rider Details
            Text(
              'Rider Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/default.png'), // Change if you use a network image
                radius: 30,
              ),
              title: Text("${widget.trip.user?.name}"),
              subtitle: Text("${widget.trip.user?.phone}"),
            ),
            Divider(),

            // Driver Details
            Text(
              'Driver Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              // leading: CircleAvatar(
              //   backgroundColor: Colors.blue, // Replace with driver's image if available
              //   radius: 30,
              //   child: Text("${widget.trip.driver?.}"), // Initials as placeholder
              // ),
              title: Text("${widget.trip.driver?.name}"),
              subtitle: Text("${widget.trip.driver?.phone}"),
            ),
            SizedBox(height: 10),
            Text('Plate Number: ${widget.trip.driver!.plateNo == null  ? "N/A" : widget.trip.driver!.plateNo}'),
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
                Text('${widget.trip.riderFromAddress}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('To:', style: TextStyle(fontSize: 16)),
                Text('${widget.trip.riderToAddress}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fare:', style: TextStyle(fontSize: 16)),
                Text('\₦${'${widget.trip.amount}'}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ride Status:', style: TextStyle(fontSize: 16)),
                Text('${widget.trip.rideStatus}', style: TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
            SizedBox(height: 20),

            // Ride Time Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ride Created At:', style: TextStyle(fontSize: 16)),
                Text('${widget.trip.createdAt}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ride Updated At:', style: TextStyle(fontSize: 16)),
                Text('${widget.trip.updatedAt}', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
