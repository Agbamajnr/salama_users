import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/widgets/busy_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String identity;
  final String intent;

  VerifyOtpScreen({super.key, required this.identity, required this.intent});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isResending = false;
  int _resendCooldown = 30;

  @override
  void initState() {
    super.initState();
    _requestOtp();
  }

  void _requestOtp() {
    context.read<AuthNotifier>().requestOtp(
      context,
      identity: widget.identity,
      intent: widget.intent,
      userType: "user",
    );

    setState(() {
      _isResending = true;
      _resendCooldown = 30;
    });

    _startResendTimer();
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
        return true;
      }
      setState(() {
        _isResending = false;
      });
      return false;
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Verify OTP'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  "Enter the 6-digit OTP sent to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Gap(20),

                // OTP Input Field
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  autoDisposeControllers: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: AppColors.primaryColor,
                    selectedColor: AppColors.primaryColor.withOpacity(0.7),
                    inactiveColor: Colors.grey.shade400,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your OTP';
                    }
                    if (value.length < 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),

                const Gap(20),

                // Resend OTP Button
                _isResending
                    ? Text(
                  "Resend in $_resendCooldown seconds",
                  style: TextStyle(color: Colors.grey),
                )
                    : TextButton(
                  onPressed: _requestOtp,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                // Verify Button
                BusyButton(
                  title: "Verify",
                  isLoading: auth.isLoading,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      await auth.verifyAccount(
                        context,
                        identity: widget.identity,
                        intent: widget.intent,
                        userType: "user",
                        otp: _otpController.text,
                      );
                    }
                  },
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
