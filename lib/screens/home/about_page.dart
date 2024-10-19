import 'package:flutter/material.dart';
import 'package:salama_users/constants/colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text("About Us"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              // Center(
              //   child: Text(
              //     "About Us",
              //     style: TextStyle(
              //       fontSize: 28,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),

              // Paragraph Text
              Text(
                "We are a leading company that specializes in delivering innovative technology solutions. "
                    "Our mission is to simplify complex challenges and provide cutting-edge solutions that meet the needs "
                    "of businesses and individuals alike. Whether it's mobile applications, web platforms, or AI-driven products, "
                    "we strive for excellence and customer satisfaction in all our endeavors. "
                    "\n\nOur team consists of talented developers, designers, and strategists who work tirelessly to push the boundaries "
                    "of what's possible with technology. We believe in a collaborative approach, where we partner with our clients to "
                    "understand their goals and deliver results that exceed their expectations."
                    "\n\nWith a focus on innovation, integrity, and impact, we are committed to helping businesses grow and succeed in the digital age. "
                    "At our core, we are problem-solvers, creators, and innovators. We are driven by the desire to make a meaningful impact in the world through technology."
                    "\n\nContact us to learn more about how we can help your business achieve its full potential.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),

              // Contact Information (Optional)
              Text(
                "Contact Us:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Email: contact@company.com\nPhone: +1 234 567 890",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}