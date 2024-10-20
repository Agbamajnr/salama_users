import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salama_users/app/notifiers/auth.notifier.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/constants/colors.dart';
import 'package:salama_users/data/models/login_data.model.dart';
import 'package:salama_users/screens/home/about_page.dart';
import 'package:salama_users/screens/home/update_profile.dart';
import 'package:salama_users/widgets/custom_single_scroll_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, AuthNotifier auth, child) => Scaffold(
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
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('5.0 Rating'),
                  ],
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
        _buildListTile(context, Icons.lock, 'Login & Security', () {}),
        _buildListTile(context, Icons.privacy_tip, 'Privacy', () {}),
        _buildListTile(context, Icons.info_outline, 'About', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutUsPage()),
          );
        }),
        _buildListTile(context, Icons.support_agent, 'Support', () {}),
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
            auth.logout(context);
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
            // Handle delete account logic here
          },
        ),
      ],
    );
  }
}
