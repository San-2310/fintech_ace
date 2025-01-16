import 'package:flutter/material.dart';

import 'buy_insurance.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  _InsuranceScreenState createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  // Sample insurance options (mock data)
  final List<Map<String, String>> insuranceRecommendations = [
    {
      'insuranceType': 'Health Insurance',
      'premium': '₹500/month',
      'coverage': '₹5,00,000',
      'details':
          'Comprehensive health coverage for hospitalization, doctor visits, etc.',
    },
    {
      'insuranceType': 'Life Insurance',
      'premium': '₹1000/month',
      'coverage': '₹10,00,000',
      'details': 'Term life insurance with critical illness coverage.',
    },
    {
      'insuranceType': 'Weather-Linked Microinsurance',
      'premium': '₹300/month',
      'coverage': '₹2,00,000',
      'details':
          'Microinsurance for weather-related damages (e.g., crop insurance).',
    },
  ];

  // Sample insurance claims (mock data)
  final List<Map<String, String>> insuranceClaims = [
    {
      'claimType': 'Health Claim',
      'status': 'Approved',
      'amount': '₹50,000',
      'date': '01-Jan-2024',
    },
    {
      'claimType': 'Life Claim',
      'status': 'Pending',
      'amount': '₹1,00,000',
      'date': '10-Jan-2024',
    },
  ];

  // Show insurance plan details pop-up
  void _showInsurancePlanDetailsDialog(String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insurance Plan Details'),
          content: SingleChildScrollView(
            child: Text(details),
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
        title: const Text('Insurance Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InsurancePage()));
              },
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color.fromARGB(255, 223, 219, 245),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Get Custom Insurance Plans",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
            const Text(
              'Insurance Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...insuranceRecommendations.map(
              (insurance) => Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(insurance['insuranceType'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium: ${insurance['premium']}'),
                      Text('Coverage: ${insurance['coverage']}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _showInsurancePlanDetailsDialog(
                          insurance['details'] ?? '');
                    },
                    child: const Text('View Details'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Weather-Linked Microinsurance Section
            const Text(
              'Weather-Linked Microinsurance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text('Crop Insurance (Weather-Linked)'),
                subtitle: const Text(
                  'Insurance for weather-related damages to crops, ensuring income protection.',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showInsurancePlanDetailsDialog(
                      'This insurance covers losses from adverse weather conditions such as floods or droughts. Premium: ₹300/month, Coverage: ₹2,00,000.',
                    );
                  },
                  child: const Text('View Details'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Insurance Claims Section
            const Text(
              'Insurance Claims',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...insuranceClaims.map(
              (claim) => Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(claim['claimType'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Claim Status: ${claim['status']}'),
                      Text('Claim Amount: ${claim['amount']}'),
                      Text('Claim Date: ${claim['date']}'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
