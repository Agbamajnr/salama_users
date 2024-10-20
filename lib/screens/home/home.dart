import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/screens/home/active_drivers_screen.dart';
import 'package:salama_users/screens/home/history_list.screen.dart';
import 'package:salama_users/screens/home/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of pages (screens) for each navigation tab
  final List<Widget> _pages = [
    NearbyDriversScreen(),
    RideHistoryScreen(),
    ProfileScreen()
  ];

  // Function to handle navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    if (context.mounted) {
      context.read<AuthNotifier>().dashboard(context,
          longitude: "6.99",
          latitude: "4.66",
          isActive: false,
          firebaseToken: "dkhgjhgfeguyghuiegfguhufgih");
      context.read<AuthNotifier>().getCurrentLocation(context);
      context.read<AuthNotifier>().fetchAllTrips(context, skip: 0, limit: 10);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // appBar: AppBar(
      //   title: Text('Home with Navigation'),
      //   automaticallyImplyLeading: false,
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Tab Screen
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// History Tab Screen
class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'History Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Profile Tab Screen
class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
