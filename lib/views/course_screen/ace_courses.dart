import 'package:flutter/material.dart';

class Course {
  final String name;
  final List<String> modules;
  final IconData icon;

  Course({required this.name, required this.modules, required this.icon});
}

class AceCourseScreen extends StatefulWidget {
  const AceCourseScreen({super.key});

  @override
  _AceCourseScreenState createState() => _AceCourseScreenState();
}

class _AceCourseScreenState extends State<AceCourseScreen> {
  // List of finance-related courses with modules
  final List<Course> _courses = [
    Course(
        name: 'Investment Strategies',
        modules: [
          'Introduction to Investment',
          'Stock Market Basics',
          'Bonds and Fixed Income',
          'Real Estate Investment',
          'Portfolio Diversification',
        ],
        icon: Icons.assessment),
    Course(
        name: 'Financial Planning',
        modules: [
          'Personal Budgeting',
          'Saving for Retirement',
          'Insurance and Risk Management',
          'Tax Planning',
          'Estate Planning',
        ],
        icon: Icons.account_balance_wallet),
    Course(
        name: 'Cryptocurrency',
        modules: [
          'Introduction to Blockchain',
          'Understanding Cryptocurrencies',
          'Crypto Wallets and Security',
          'Decentralized Finance (DeFi)',
          'Regulations and Future Trends',
        ],
        icon: Icons.security),
    Course(
        name: 'Corporate Finance',
        modules: [
          'Capital Budgeting',
          'Risk Management in Corporates',
          'Financial Statement Analysis',
          'Mergers and Acquisitions',
          'Corporate Governance',
        ],
        icon: Icons.business),
    Course(
        name: 'Behavioral Finance',
        modules: [
          'Psychology of Investing',
          'Investor Behavior and Biases',
          'Market Efficiency',
          'Behavioral Portfolio Theory',
          'Risk Perception and Decision Making',
        ],
        icon: Icons.psychology),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              title: Row(
                children: [
                  Icon(course.icon, color: Colors.deepPurple),
                  const SizedBox(width: 10),
                  Text(
                    course.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              children: course.modules
                  .map((module) => ListTile(
                        title: Text(
                          module,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ))
                  .toList(),
              iconColor: Colors.deepPurple,
              collapsedIconColor: Colors.deepPurpleAccent,
            ),
          );
        },
      ),
    );
  }
}
