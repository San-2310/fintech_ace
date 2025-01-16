import 'package:fintech_ace/views/loan_screens/loan_bot.dart';
import 'package:flutter/material.dart';

class LoanCreditScreen extends StatefulWidget {
  const LoanCreditScreen({super.key});

  @override
  _LoanCreditScreenState createState() => _LoanCreditScreenState();
}

class _LoanCreditScreenState extends State<LoanCreditScreen> {
  final List<Map<String, String>> loanRecommendations = [
    {
      'loanType': 'Personal Loan',
      'interestRate': '12%',
      'repaymentSchedule': '24 months',
      'status': 'Approved',
    },
    {
      'loanType': 'Home Loan',
      'interestRate': '8%',
      'repaymentSchedule': '180 months',
      'status': 'Pending',
    },
    {
      'loanType': 'Car Loan',
      'interestRate': '10%',
      'repaymentSchedule': '60 months',
      'status': 'Approved',
    },
  ];

  // Show CIBIL score pop-up
  void _showCibilScoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('CIBIL Score'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What is CIBIL Score?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'CIBIL score is a three-digit number between 300 and 900 that represents your creditworthiness. It is used by financial institutions to evaluate your eligibility for loans and credit cards.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Why is it Important?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A good CIBIL score helps you get loan approval quickly and at better interest rates. A low score may result in loan rejections or high-interest rates.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'How to Maintain a Good CIBIL Score?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. Pay your bills on time.\n2. Avoid applying for too many loans.\n3. Maintain a healthy credit utilization ratio (use less than 30% of your credit limit).\n4. Regularly check and correct your credit report for errors.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDE0F5),
        title: const Text('Loan & Credit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Loan Recommendations Section
            const Text(
              'Loan Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: loanRecommendations.length,
                itemBuilder: (context, index) {
                  final loan = loanRecommendations[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(loan['loanType'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Interest Rate: ${loan['interestRate']}'),
                          Text(
                              'Repayment Schedule: ${loan['repaymentSchedule']}'),
                          Text('Status: ${loan['status']}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Handle loan application action
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  );
                },
              ),
            ),
            // CIBIL Score Info Button
            ElevatedButton(
              onPressed: _showCibilScoreDialog,
              child: const Text('Know About CIBIL Score'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoanAssistantPage()));
              },
              child: Positioned(
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 192, 167, 239),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Text('Ask our Loan Assistant for help'),
                        Icon(
                          Icons.chat_bubble_outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
