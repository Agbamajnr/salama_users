import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/login_data.model.dart';
import 'package:salama_users/routes/router_names.dart';
import 'package:salama_users/screens/home/about_page.dart';
import 'package:salama_users/screens/home/report_screen.dart';
import 'package:salama_users/screens/home/update_profile.dart';
import 'package:salama_users/widgets/custom_single_scroll_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) =>
          Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: CustomSingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildProfileInfo(auth.user!),
                  const SizedBox(height: 10),
                  _buildProfileOptions(context, auth.user),
                  Spacer(),
                  const SizedBox(height: 20),
                  _buildLogoutAndDeleteOptions(auth.user, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(User user) {
    logger.d(user.profileImage);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.skyBlue,
              child: user.profileImage == null ||
                      user.profileImage == 'default.png'
                  ? Icon(Icons.error_outline)
                  : CachedNetworkImage(
                      imageUrl: user.profileImage ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            // colorFilter:
                            // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName} ${user.middleName ?? ""}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('${user.phone}', style: TextStyle(color: Colors.black54)),
                Text('${user.email ?? ""}',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, dynamic user) {
    return Column(
      children: [
        _buildListTile(context, Icons.person, 'Personal Info', () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileUpdateScreen()),
          );
        }),
        _buildListTile(context, Icons.lock, 'Reports', () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportsScreen()),
          );
        }),
        _buildListTile(context, Icons.privacy_tip, 'Privacy', () async{
          await EasyLauncher.url(url: "https://pub.dev");
        }),
        _buildListTile(context, Icons.info_outline, 'About', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutUsPage()),
          );
        }),
        // _buildListTile(context, Icons.support_agent, 'Support', () {}),
      ],
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor.withOpacity(0.6),
        child: Icon(icon, color: AppColors.white),
      ),
      title: Text(title,
          style: const TextStyle(color: AppColors.background, fontSize: 16)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: AppColors.background),
      onTap: onTap,
    );
  }

  Widget _buildLogoutAndDeleteOptions(dynamic user, BuildContext context) {
    final auth = context.read<AuthNotifier>();
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.secondaryYellow,
            child: Icon(Icons.settings, color: Colors.white),
          ),
          title: const Text('Logout',
              style: TextStyle(color: AppColors.background, fontSize: 16)),
          // trailing:
          //     const Icon(Icons.arrow_forward_ios, color: AppColors.background),
          onTap: () {
            // if(_scaffoldkey.currentContext == null)return;
            showDialog(

              barrierColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.transparent .withOpacity(0.6) : const Color(0xff110C00).withOpacity(0.8),
              context: context, builder:(context) {
              return dialog(context);
            },);
            // Handle logout logic here
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          title: const Text('Delete Account',
              style: TextStyle(color: AppColors.background, fontSize: 16)),
          // trailing:
          // const Icon(Icons.arrow_forward_ios, color: AppColors.background),
          onTap: () {
            showDialog(

              barrierColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.transparent .withOpacity(0.6) : const Color(0xff110C00).withOpacity(0.8),
              context: context, builder:(context) {
              return deleteDialog(context);
            },);
            // Handle delete account logic here
          },
        ),
      ],
    );
  }

  bool _isProcessing = false;

  Widget dialog(BuildContext context) {
    bool _isProcessing = false;
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: AbsorbPointer(
        absorbing: _isProcessing,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8)
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            // fontFamily: AppFonts.mulishRegular,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            // color: AppColors.black,
                          ),
                        ),
                        Gap(18),
                        const Text(
                          'Oh no you’re leaving, are you sure?',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: Color(0xff6D6D6D),
                            // fontFamily: AppFonts.mulishRegular,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            // color: AppColors.textColor,
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),

                    const Gap(24),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            //  Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryColor,
                            ),
                            child: SizedBox(
                              height: 15,
                              child: const Center(
                                child: Text(
                                  "No, Cancel",
                                  style: TextStyle(
                                    // fontFamily: AppFonts.mulishRegular,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Consumer<AuthNotifier>(
                            builder: (context, AuthNotifier user, child) {
                              return InkWell(
                                onTap: () async {
                                  await user.logout(context).then((value) {
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.primaryColor
                                      // width: 1, color: AppColors.secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height:15,
                                    child: Center(
                                      child: _isProcessing ?  SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: const CircularProgressIndicator(color: AppColors.primaryColor,)) : const Text(
                                        "Yes, log me out",
                                        style: TextStyle(
                                          // fontFamily: AppFonts.manRope,
                                          color: AppColors.primaryColor,
                                          // fontFamily: AppFonts.mulishRegular,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          // color: AppColors.secondary
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget deleteDialog(BuildContext context) {
    bool _isProcessing = false;
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: AbsorbPointer(
        absorbing: _isProcessing,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8)
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.delete_forever_outlined, color: Colors.red, size: 40,),
                        Gap(10),
                        const Text(
                          'Delete Account',
                          style: TextStyle(
                            // fontFamily: AppFonts.mulishRegular,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            // color: AppColors.black,
                          ),
                        ),
                        Gap(18),
                        const Text(
                          'Oh no you’re leaving, are you sure?',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: Color(0xff6D6D6D),
                            // fontFamily: AppFonts.mulishRegular,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            // color: AppColors.textColor,
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),

                    const Gap(24),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            //  Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryColor,
                            ),
                            child: SizedBox(
                              height: 15,
                              child: const Center(
                                child: Text(
                                  "No, Cancel",
                                  style: TextStyle(
                                    // fontFamily: AppFonts.mulishRegular,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Consumer<AuthNotifier>(
                            builder: (context, AuthNotifier user, child) {
                              return InkWell(
                                onTap: () async {
                                  await user.deleteAccount(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.primaryColor
                                      // width: 1, color: AppColors.secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height:15,
                                    child: Center(
                                      child: _isProcessing ?  SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: const CircularProgressIndicator(color: AppColors.primaryColor,))
                                          : const Text(
                                        "Yes, delete",
                                        style: TextStyle(
                                          // fontFamily: AppFonts.manRope,
                                          color: AppColors.primaryColor,
                                          // fontFamily: AppFonts.mulishRegular,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          // color: AppColors.secondary
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
