import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/widgets/busy_button.dart';
import 'package:salama_users/widgets/custom_single_scroll_view.dart';

class VerifyotpScreen extends StatefulWidget {
  final String identiy;
  final String intent;
  VerifyotpScreen({super.key, required this.identiy, required this.intent});

  @override
  _VerifyotpScreenState createState() => _VerifyotpScreenState();
}

class _VerifyotpScreenState extends State<VerifyotpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _otpController = TextEditingController();

  @override
  void initState() {
    context.read<AuthNotifier>().requestOtp(context,
        identity: widget.identiy, intent: widget.intent, userType: "user");
    super.initState();
  }

  // Disposing controllers when done
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Verify Otp'),
          automaticallyImplyLeading: false,
        ),
        body: CustomSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Gap(40),
                  // Email field
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your otp';
                      }
                      if (value.length < 6) {
                        return 'otp must be 6 characters';
                      }

                      return null;
                    },
                  ),

                  Spacer(),
                  BusyButton(
                    title: "Proceed",
                    isLoading: auth.isLoading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild?.unfocus();
                        }
                        await auth.verifyAccount(context,
                            identity: widget.identiy,
                            intent: widget.intent,
                            userType: "user",
                            otp: _otpController.text);
                      }
                    },
                  ),
                  Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
