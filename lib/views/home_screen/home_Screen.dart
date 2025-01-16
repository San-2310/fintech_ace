import 'dart:convert';

import 'package:fintech_ace/views/insurance_screen/insurance_screen.dart';
import 'package:fintech_ace/views/loan_screens/loans_screen.dart';
import 'package:fintech_ace/views/savings_screen/savings_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../transactions_screen/transaction_screen.dart';

Future<List<dynamic>> fetchRecentTransactions() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.100:3000/recenttransactions'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Parse the JSON response
  } else {
    throw Exception('Failed to load transactions');
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                  color: const Color(0xFFDDE0F5)),
              child: SectionCard(
                title: 'Quick Actions',
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                      color: const Color(0xFFDDE0F5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SavingsGoalsScreen()));
                          },
                          child: QuickActionTile(
                              icon: Icons.savings, label: 'Add savings goal'),
                        ),
                        QuickActionTile(
                            icon: Icons.monetization_on,
                            label: 'Apply for Loan'),
                        QuickActionTile(
                            icon: Icons.wallet, label: 'View Transactions'),
                        QuickActionTile(
                            icon: Icons.shield, label: 'View Insurance Plans'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SectionCard(
              title: 'Recent Transactions',
              child: FutureBuilder<List<dynamic>>(
                future: fetchRecentTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No recent transactions found.'));
                  } else {
                    final transactions = snapshot.data!;
                    return Column(
                      children: transactions.map((transaction) {
                        return TransactionItem(
                          id: transaction['id'],
                          userId: transaction['userId'],
                          amount: transaction['amount'],
                          recipient: transaction['recipient'],
                          status: transaction['status'],
                          title: transaction['title'],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            SectionCard(
              title: 'Financial Education',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Progress',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    color: Colors.purple,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Next lesson: Investment Basics',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SectionCard(
              title: 'Weather Insurance',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Coverage',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Crop Protection Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Next payout forecast: 7 days',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(

      //   selectedItemColor: Colors.purple,
      //   unselectedItemColor: Colors.grey,
      //   showUnselectedLabels: true,
      // ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickActionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.1),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        if (label == 'Add savings goal')
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SavingsGoalsScreen()));
        else if (label == 'Apply for Loan')
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoanCreditScreen()));
        else if (label == 'View Insurance Plans')
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InsuranceScreen()));
        else if (label == 'View Transactions')
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TransactionScreen()));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple, size: 30),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String id;
  final String userId;
  final int amount;
  final String recipient;
  final String status;
  final String title;

  const TransactionItem({
    required this.id,
    required this.userId,
    required this.amount,
    required this.recipient,
    required this.status,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the amount should be shown as positive or negative
    final bool isPositive = status == "success" && amount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction title
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              // Recipient information
              Text(
                "Recipient: $recipient",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // User ID (Optional: Remove if not needed)
              Text(
                "User ID: $userId",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          // Amount displayed with positive/negative sign and color
          Text(
            "${isPositive ? '+' : '-'}₹$amount",
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
