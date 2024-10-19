import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/update_user_dto.dart';
import 'package:salama_users/widgets/busy_button.dart';
import 'package:salama_users/widgets/custom_single_scroll_view.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {

  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();

  @override
  void initState() {
    final user = context.read<AuthNotifier>().user;
    setState(() {
      _firstNameController.text = user?.firstName ?? "";
      _middleNameController.text = user?.middleName ?? "";
      _lastNameController.text = user?.lastName ?? "";
    });

    super.initState();
  }

  // Disposing controllers when done
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(

      builder: (context, AuthNotifier auth, child) =>
       AbsorbPointer(
         absorbing: auth.isLoading,
         child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: const Text(
              "Profile Info",
              style: TextStyle(fontSize: 25),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: CustomSingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Gap(15),
                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 18.0),

                    TextFormField(
                      controller: _middleNameController,
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Please enter your first name';
                        // }
                        return null;
                      },
                    ),

                    SizedBox(height: 18.0),

                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 18.0),

                    Spacer(),
                    Gap(10),
                    BusyButton(
                        title: "Save",
                        isLoading: auth.isLoading,
                        onTap: (){
                      auth.updateUser(context, UpdateUserDto(firstName: _firstNameController.text, lastName: _lastNameController.text, middleName: _middleNameController.text, device: "android", firebaseToken: "", longitude: double.parse(auth.lng.toString()), latitude: double.parse(auth.lat.toString())));
                    }),
                    Gap(10),

                  ],
                ),
              ),
            ),
          ),
               ),
       ),
    );
  }
}
