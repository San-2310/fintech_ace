import 'package:fintech_ace/views/navigator_screen.dart';
import 'package:flutter/material.dart';

import 'referral_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to FinSmart")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Referral Banner
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/referral-card.png",
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Add navigation to referral screen here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferralScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Referral Bonus!",
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Explore basic options or",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the main app screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigatorScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    "Skip to Main App",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildOptionCard(
                  context,
                  "See Tutorials on App Usage",
                  Icons.school,
                  Colors.purple,
                ),
                _buildOptionCard(
                  context,
                  "Learn Basics with Education Modules",
                  Icons.book,
                  Colors.green,
                ),
                _buildOptionCard(
                  context,
                  "Ask Your Doubts to Our Chatbot",
                  Icons.chat,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 191, 241),
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            // Add navigation for each option here
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
