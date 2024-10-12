import 'package:flutter/material.dart';
import 'package:salama_users/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: TextStyle(fontSize: 25),
              ),
              _buildProfileInfo(),
              SizedBox(height: 10),
              _buildProfileOptions(context),
              SizedBox(height: 20),
              _buildLogoutAndDeleteOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                  'assets/profile_picture.png'), // Use actual image path or network image
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ogar Emmanuel Bassey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('5.0 Rating'),
                  ],
                ),
                Text('08178383838', style: TextStyle(color: Colors.black54)),
                Text('emmanue.logar512@gmail.com',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildListTile(context, Icons.person, 'Personal Info'),
        _buildListTile(context, Icons.lock, 'Login & Security'),
        _buildListTile(context, Icons.privacy_tip, 'Privacy'),
        _buildListTile(context, Icons.card_giftcard, 'Referral'),
        _buildListTile(context, Icons.info_outline, 'About'),
        _buildListTile(context, Icons.support_agent, 'Support'),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Icon(icon, color: AppColors.white),
      ),
      title: Text(title,
          style: TextStyle(color: AppColors.background, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.background),
      onTap: () {
        // Handle onTap navigation or logic here
      },
    );
  }

  Widget _buildLogoutAndDeleteOptions() {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.settings, color: Colors.white),
          ),
          title: Text('Logout',
              style: TextStyle(color: AppColors.background, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.background),
          onTap: () {
            // Handle logout logic here
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          title: Text('Delete Account',
              style: TextStyle(color: AppColors.background, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.background),
          onTap: () {
            // Handle delete account logic here
          },
        ),
      ],
    );
  }
}
