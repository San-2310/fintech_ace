import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher.dart';

class LoanAssistantPage extends StatefulWidget {
  const LoanAssistantPage({super.key});

  @override
  State<LoanAssistantPage> createState() => _LoanAssistantPageState();
}

class _LoanAssistantPageState extends State<LoanAssistantPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<LoanScheme> _schemes = [];

  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _incomeController = TextEditingController();
  final _occupationController = TextEditingController();
  final _purposeController = TextEditingController();
  final _locationController = TextEditingController();

  // Gemini model instance
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAsIWg2xV5Dv-2-IR4pZBZOKwg4wbfI6So',
  );

  Future<void> _getLoanSuggestions() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _schemes = [];
    });

    try {
      final prompt = '''
        Suggest 5 suitable loan schemes in India based on these details:
        Name: ${_nameController.text}
        Age: ${_ageController.text}
        Monthly Income: ₹${_incomeController.text}
        Occupation: ${_occupationController.text}
        Loan Purpose: ${_purposeController.text}
        Location: ${_locationController.text}

        For each scheme, provide:
        1. Scheme name
        2. Provider
        3. Why it's suitable
        4. Key benefits
        Format as: NAME|||PROVIDER|||SUITABILITY|||BENEFITS
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text ?? '';

      final schemes = responseText
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((scheme) {
            final parts = scheme.split('|||');
            if (parts.length == 4) {
              return LoanScheme(
                name: parts[0].trim(),
                provider: parts[1].trim(),
                suitability: parts[2].trim(),
                benefits: parts[3].trim(),
              );
            }
            return null;
          })
          .whereType<LoanScheme>()
          .toList();

      setState(() {
        _schemes = schemes;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to get loan suggestions. Please try again.')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
        title: const Text('Loan Assistant'),
        backgroundColor: const Color(0xFFDDE0F5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Find the Perfect Loan for You',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _incomeController,
                          label: 'Monthly Income (₹)',
                          icon: Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _occupationController,
                          label: 'Occupation',
                          icon: Icons.work,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _purposeController,
                          label: 'Loan Purpose',
                          icon: Icons.assignment,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _locationController,
                          label: 'City',
                          icon: Icons.location_city,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _getLoanSuggestions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Find Suitable Loans',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_schemes.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Recommended Loan Schemes',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ..._schemes.map((scheme) => _buildSchemeCard(scheme)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildSchemeCard(LoanScheme scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scheme.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provider: ${scheme.provider}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text('Why it\'s suitable: ${scheme.suitability}'),
            const SizedBox(height: 8),
            Text('Benefits: ${scheme.benefits}'),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _launchUrl(scheme),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Know More'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(LoanScheme scheme) async {
    final url = Uri.parse(
      'https://www.google.com/search?q=${Uri.encodeComponent("${scheme.name} ${scheme.provider} loan scheme india")}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class LoanScheme {
  final String name;
  final String provider;
  final String suitability;
  final String benefits;

  LoanScheme({
    required this.name,
    required this.provider,
    required this.suitability,
    required this.benefits,
  });
}
