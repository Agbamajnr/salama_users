import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salama_users/constants/colors.dart';

class NearbyDriversScreen extends StatefulWidget {
  const NearbyDriversScreen({super.key});

  @override
  _NearbyDriversScreenState createState() => _NearbyDriversScreenState();
}

class _NearbyDriversScreenState extends State<NearbyDriversScreen> {
  List<Driver> drivers = [
    // Sample data
    Driver(
        name: 'Ogar Emmanuel',
        rating: 4.7,
        car: 'Toyota, Corolla',
        price: 1289.45),
    Driver(
        name: 'Ogar Emmanuel',
        rating: 4.7,
        car: 'Toyota, Corolla',
        price: 1289.45),
    Driver(
        name: 'Ogar Emmanuel',
        rating: 4.7,
        car: 'Toyota, Corolla',
        price: 1289.45),
    Driver(
        name: 'Ogar Emmanuel',
        rating: 4.7,
        car: 'Toyota, Corolla',
        price: 1289.45),
    Driver(
        name: 'Ogar Emmanuel',
        rating: 4.7,
        car: 'Toyota, Corolla',
        price: 1289.45),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/maps.png",
                ),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            // Search bar
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const Gap(30),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Destination',
                      ),
                      onChanged: (value) {
                        // Filter drivers based on search query
                      },
                    ),
                  ),
                ],
              ),
            ),
            // List of drivers
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(color: AppColors.white),
                child: ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return ListTile(
                        contentPadding: EdgeInsets.zero,
                        // ignore: deprecated_member_use
                        splashColor: AppColors.grey.withOpacity(0.08),
                        tileColor: AppColors.grey.withOpacity(0.08),
                        leading: const CircleAvatar(),
                        title: Text(driver.name),
                        subtitle:
                            Text('${driver.rating} stars | ${driver.car}'),
                        trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(color: AppColors.white),
                            )));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Driver {
  final String name;
  final double rating;
  final String car;
  final double price;

  Driver({
    required this.name,
    required this.rating,
    required this.car,
    required this.price,
  });
}
