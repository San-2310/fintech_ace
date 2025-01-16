import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  late String referralCode;

  @override
  void initState() {
    super.initState();
    referralCode = _generateReferralCode();
  }

  // Generate a random 6-character alphanumeric code
  String _generateReferralCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          6, (_) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

  // Copy referral code to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Referral code copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earn Rewards"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 177, 140, 242),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    "🎉 Welcome to FinSmart!",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You’ve earned 50 points for joining!",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Refer your friends to join with your referral code and they’ll earn 100 points. "
                    "You’ll also earn an additional 50 points for every friend who joins!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Referral Code Section
            Text(
              "Your Referral Code",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color.fromARGB(255, 177, 140, 242),
                    width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    referralCode,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  IconButton(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy,
                        color: Color.fromARGB(255, 177, 140, 242)),
                    tooltip: "Copy to clipboard",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                // Add share functionality here
              },
              icon: const Icon(Icons.share),
              label: const Text("Share Referral Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 177, 140, 242),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to rewards page
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text("Explore Rewards"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade50,
                foregroundColor: Color.fromARGB(255, 177, 140, 242),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 177, 140, 242), width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
