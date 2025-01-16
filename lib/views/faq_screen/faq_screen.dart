import 'package:flutter/material.dart';

import 'chatbot_page.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'How do I start investing in mutual funds?',
      'answer':
          'To start investing in mutual funds in India: 1) Complete your KYC, 2) Choose between direct or regular plans, 3) Select funds based on your goals and risk appetite, 4) Start with SIP or lump sum investment through official apps or websites.'
    },
    {
      'question': 'What documents are needed to open a bank account?',
      'answer':
          'To open a bank account in India, you typically need: 1) PAN Card, 2) Aadhaar Card, 3) Proof of address (utility bill/passport), 4) Passport size photographs, 5) Income proof (optional for basic accounts).'
    },
    {
      'question': 'How can I improve my credit score?',
      'answer':
          'To improve your credit score: 1) Pay bills on time, 2) Keep credit utilization below 30%, 3) Maintain a good mix of credit, 4) Regularly check your credit report, 5) Don\'t apply for multiple loans/cards in short period.'
    },
    {
      'question': 'What are the tax-saving investment options in India?',
      'answer':
          'Popular tax-saving investments include: 1) PPF (Public Provident Fund), 2) ELSS Mutual Funds, 3) Tax-saving FDs, 4) National Pension System (NPS), 5) Life Insurance Premiums, 6) Section 80C investments up to ₹1.5 lakhs.'
    },
    {
      'question': 'How to start financial planning for retirement?',
      'answer':
          'For retirement planning: 1) Start early, 2) Calculate retirement corpus needed, 3) Invest in mix of equity and debt, 4) Consider inflation, 5) Include EPF, PPF, NPS, 6) Get adequate health insurance, 7) Review and rebalance portfolio periodically.'
    },
    {
      'question': 'What is the importance of emergency fund?',
      'answer':
          'Emergency fund is crucial because: 1) Provides financial security during unexpected events, 2) Recommended to have 6-12 months of expenses, 3) Helps avoid debt during emergencies, 4) Should be easily accessible in liquid investments.'
    },
    {
      'question': 'How to protect against financial fraud?',
      'answer':
          'To protect against financial fraud: 1) Never share OTP/PIN, 2) Use strong passwords, 3) Enable 2FA, 4) Verify sources before investing, 5) Regular monitor accounts, 6) Report suspicious activities immediately, 7) Be cautious of unsolicited offers.'
    },
    {
      'question': 'What is the process for filing ITR?',
      'answer':
          'To file ITR: 1) Collect all income documents, 2) Choose correct ITR form, 3) Calculate total income and deductions, 4) File return on income tax portal, 5) Verify return using Aadhaar OTP/other methods, 6) Keep acknowledgment safe.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
        title: const Text('Financial FAQs'),
        backgroundColor: const Color(0xFFDDE0F5),
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                faqList[index]['question']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotPage(
                      initialQuestion: faqList[index]['question']!,
                      initialAnswer: faqList[index]['answer']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
