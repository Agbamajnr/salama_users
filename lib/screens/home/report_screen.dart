import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/constants/colors.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text("Trips Reports"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: auth.isLoading && auth.tripReport.isEmpty
              ? Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.primaryColor,
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
            ),
          )
              : auth.tripReport.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.report,
                  size: 50,
                  color: AppColors.primaryColor,
                ),
                Gap(10),
                Text(
                  "No reports yet!",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
                Gap(7),
              ],
            ),
          )
              : ListView.builder(
            padding:
            EdgeInsets.symmetric(horizontal: 17, vertical: 10),
            itemCount: auth.tripReport.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final report = auth.tripReport[index];
              return Column(children: [
                Gap(10),
                Text(
                    report.message ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey
                  ),
                )
              ]);
            },
          ),
        ),
      ),
    );
  }
}
