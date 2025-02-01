import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/address_response.model.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/screens/home/available_screen.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  TextEditingController toController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  bool isLoading = false;
  List<AddressResponse> searchResults = [];
  AddressResponse? _userSelectedTo;
  AddressResponse? _userSelectedFrom;
  bool isTo = false;

  Future<void> performSearch(String search) async {
    if(search.length < 1)return;
    setState(() => isLoading = true);
    String apiUrl = '/taxi/location/address?address=${search}';

    try {
      var response = await _api.dio.get(apiUrl);
      if (response.statusCode == 200) {
        logger.d(response.data);
        final List<dynamic> data = response.data['data'];
        if(data.isNotEmpty){
          setState(() {
            searchResults = data.map((json) => AddressResponse.fromJson(json)).toList();
          });
        }

      } else {
        setState(() => searchResults = []);
        AppSnackbar.error(context, message: "Error while fetching address");
      }
    } on DioException catch (e) {
      setState(() => searchResults = []);
      final message = e.response?.data['message'] ?? "Error while fetching address, try again later";
      AppSnackbar.error(context, message: message);
      setState(() => searchResults = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('Search Address', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FROM LOCATION FIELD
            _buildTextField(
              controller: fromController,
              hint: 'Enter your current location',
              icon: Icons.my_location,
              isLoading: isLoading && !isTo,
              onChanged: (value) async {
                setState(() => isTo = false);
                await performSearch(value);
              },
            ),
            SizedBox(height: 12),

            // DESTINATION LOCATION FIELD
            _buildTextField(
              controller: toController,
              hint: 'Enter destination',
              icon: Icons.location_on,
              isLoading: isLoading && isTo,
              onChanged: (value) async {
                setState(() => isTo = true);
                await performSearch(value);
              },
            ),
            SizedBox(height: 20),

            // SEARCH RESULTS LIST
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: searchResults.isEmpty
                    ? Center(child: Text('No results found', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final address = searchResults[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            if (isTo) {
                              _userSelectedTo = address;
                              toController.text = address.address.toString();
                            } else {
                              _userSelectedFrom = address;
                              fromController.text = address.address.toString();
                            }
                            searchResults.clear();
                          });
                        },
                        title: Text(address.address ?? "", style: TextStyle(fontWeight: FontWeight.w500)),
                        leading: Icon(Icons.place, color: AppColors.primaryColor),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        elevation: 6,
        onPressed: () {
          if (_userSelectedTo == null) {
            AppSnackbar.error(context, message: "Please select a destination.");
          } else if (_userSelectedFrom == null) {
            AppSnackbar.error(context, message: "Please select your location.");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AvailableScreen(
                  userSelectedTo: _userSelectedTo!,
                  userSelectedFrom: _userSelectedFrom!,
                ),
              ),
            );
          }
        },
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required bool isLoading,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        suffixIcon: isLoading
            ? Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : null,
      ),
    );
  }
}
