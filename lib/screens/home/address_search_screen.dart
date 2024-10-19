import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/address_response.model.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/screens/home/available_screen.dart';
import 'package:salama_users/widgets/custom_single_scroll_view.dart';

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

  Future<void> performSearch() async {
    String toValue = toController.text;
    String fromValue = fromController.text;

    // if (toValue.isEmpty && fromValue.isEmpty) {
    //   // Show error if fields are empty
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Please fill both fields'),
    //   ));
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    // Assuming your API URL looks like this
    String apiUrl = '/taxi/location/address?longitude=212331&latitude=3.1211&radius=50000&address=diamond hill';

    try {
      var response = await _api.dio.get(apiUrl);
      logger.wtf(response.data);
      if (response.statusCode == 200) {
        logger.d(response.data);
        final List<dynamic> data = response.data['data'];
        final List<AddressResponse> results = data.map((json) => AddressResponse.fromJson(json)).toList();
        setState(() {
            searchResults = results;
            // toSearchResults = results;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching data: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Screen'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: fromController,
                onChanged: (String value) async{
                  setState(() {
                    isTo = false;
                  });
                  await performSearch();
                },
                decoration: InputDecoration(
                  labelText: 'Where To',
                  suffix: isTo == false && isLoading == true ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(

                    ),
                  ) : Text(""),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: toController,
                onChanged: (String value) async{
                  setState(() {
                    isTo = true;
                  });
                  await performSearch();
                },
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  suffix: isTo == true && isLoading == true ?
                  SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator()) : Text("")
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: List.generate(searchResults.length, (index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() {
                        if (isTo == true) {
                          _userSelectedTo = searchResults[index];
                          toController.text = _userSelectedTo!.address.toString();
                          searchResults = [];
                        } else {
                          _userSelectedFrom = searchResults[index];
                          fromController.text = _userSelectedFrom!.address.toString();
                        }
                      });
                    },
                    title: Text('${searchResults[index].address}'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  );
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: (){
            if(_userSelectedTo == null){
              AppSnackbar.error(context, message: "Input a valid destination address");
            }

            else if(_userSelectedFrom == null){
              AppSnackbar.error(context, message: "Input a valid location address");
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AvailableScreen(userSelectedTo: _userSelectedTo!, userSelectedFrom: _userSelectedFrom!,)),
              );
            }


          }, // The function to be executed
          child: Icon(Icons.arrow_forward, color: AppColors.white,), // Icon for the button
          tooltip: 'Go', // Tooltip when hovering over the button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position of the button
      ),
    );
  }
}
