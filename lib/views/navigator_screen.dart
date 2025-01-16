import 'package:fintech_ace/views/course_screen/ace_courses.dart';
import 'package:fintech_ace/views/currency_converter/currency_converter.dart';
import 'package:fintech_ace/views/faq_screen/faq_screen.dart';
import 'package:fintech_ace/views/first_time_user/onboarding_screen.dart';
import 'package:fintech_ace/views/home_screen/home_Screen.dart';
import 'package:fintech_ace/views/insurance_screen/insurance_screen.dart';
import 'package:fintech_ace/views/loan_screens/loan_bot.dart';
import 'package:fintech_ace/views/loan_screens/loans_screen.dart';
import 'package:fintech_ace/views/payment_simulator/payment_simulator.dart';
import 'package:fintech_ace/views/profile_screen/profile_screen.dart';
import 'package:fintech_ace/views/quizes_screen/quizes_screen.dart';
import 'package:fintech_ace/views/stock_trading/stock_trading.dart';
import 'package:fintech_ace/views/tax_calculator/tax_calculator.dart';
import 'package:fintech_ace/views/transactions_screen/transaction_screen.dart';
import 'package:fintech_ace/views/voice_assistant/home_page.dart';
import 'package:flutter/material.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;

  // List of pages for each BottomNavigationBar item
  final List<Widget> _pages = [
    HomeScreen(),
    LoanCreditScreen(),
    InsuranceScreen(),
    TransactionScreen(),
    ProfileScreen(),
  ];

  // Function to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
        title: const Text('FinMate'),
        backgroundColor: const Color(0xFFDDE0F5),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header with a gradient background and rounded corners
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'FinMate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // List of items with custom styling
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildListTile(
                    context,
                    Icons.heat_pump_rounded,
                    'Onboard',
                    0,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingScreen())),
                  ),
                  _buildListTile(
                    context,
                    Icons.home,
                    'Home',
                    1,
                    () {
                      Navigator.pop(context);
                      _onItemTapped(0);
                    },
                  ),
                  _buildListTile(
                    context,
                    Icons.quiz,
                    'Quizes',
                    2,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QuizzesPage())),
                  ),
                  _buildListTile(
                    context,
                    Icons.chat,
                    'Loan Bot',
                    3,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoanAssistantPage())),
                  ),
                  _buildListTile(
                    context,
                    Icons.question_answer,
                    'FAQs',
                    4,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FAQPage())),
                  ),
                  _buildListTile(
                    context,
                    Icons.currency_exchange,
                    'Currency Converter',
                    5,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrossBorderPayment())),
                  ),
                  _buildListTile(
                    context,
                    Icons.voice_chat,
                    'Voice Assistant',
                    6,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VoiceAssistantHome())),
                  ),
                  _buildListTile(
                    context,
                    Icons.payment,
                    'Payment Simulator',
                    7,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSimulator())),
                  ),
                  _buildListTile(
                    context,
                    Icons.currency_bitcoin,
                    'Stock Trading ',
                    8,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockTradingDemo())),
                  ),
                  _buildListTile(
                    context,
                    Icons.calculate,
                    'Tax Calculator ',
                    9,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaxCalculator())),
                  ),
                  _buildListTile(
                    context,
                    Icons.book,
                    'Courses',
                    10,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AceCourseScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Display the current page
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            elevation: 8.0,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: const Color.fromRGBO(55, 27, 52, 1),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.monetization_on), label: 'Loans'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shield), label: 'Insurance'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.wallet), label: 'Transaction'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create each ListTile with custom styling
  Widget _buildListTile(BuildContext context, IconData icon, String title,
      int index, Function()? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
      selectedTileColor: Colors.blue[100], // Selected item highlight
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      horizontalTitleGap: 10,
    );
  }
}
