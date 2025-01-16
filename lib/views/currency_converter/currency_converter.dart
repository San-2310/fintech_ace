import 'package:flutter/material.dart';

class CrossBorderPayment extends StatefulWidget {
  @override
  _CrossBorderPaymentState createState() => _CrossBorderPaymentState();
}

class _CrossBorderPaymentState extends State<CrossBorderPayment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  String selectedFromCurrency = 'United States Dollar (USD)';
  String selectedToCurrency = 'Indian Rupee (INR)';
  double convertedAmount = 0.0;
  bool isLoading = false;

  // Mock exchange rates - in production, use real forex API
  final Map<String, double> exchangeRates = {
    'USD-INR': 82.5,
    'USD-EUR': 0.91,
    'USD-GBP': 0.78,
    'USD-JPY': 109.5,
    'USD-CAD': 1.34,
    'USD-AUD': 1.54,
    'USD-CHF': 0.89,
    'USD-SGD': 1.33,
    'USD-ZAR': 19.1,
    'USD-CNY': 7.23,
    'INR-USD': 0.012,
    'INR-EUR': 0.011,
    'INR-GBP': 0.0096,
    'INR-JPY': 1.80,
    'INR-CAD': 0.0162,
    'INR-AUD': 0.0187,
    'INR-CHF': 0.0108,
    'INR-SGD': 0.0161,
    'INR-ZAR': 0.231,
    'INR-CNY': 0.0876,
    'EUR-USD': 1.1,
    'EUR-INR': 90.5,
    'EUR-GBP': 0.85,
    'EUR-JPY': 120.4,
    'EUR-CAD': 1.47,
    'EUR-AUD': 1.68,
    'EUR-CHF': 0.97,
    'EUR-SGD': 1.46,
    'EUR-ZAR': 20.5,
    'EUR-CNY': 7.9,
    'GBP-USD': 1.28,
    'GBP-INR': 105.2,
    'GBP-EUR': 1.18,
    'GBP-JPY': 142.5,
    'GBP-CAD': 1.72,
    'GBP-AUD': 1.98,
    'GBP-CHF': 1.14,
    'GBP-SGD': 1.71,
    'GBP-ZAR': 24.2,
    'GBP-CNY': 8.6,
    'JPY-USD': 0.0091,
    'JPY-INR': 0.56,
    'JPY-EUR': 0.0083,
    'JPY-GBP': 0.007,
    'JPY-CAD': 0.0125,
    'JPY-AUD': 0.0143,
    'JPY-CHF': 0.0082,
    'JPY-SGD': 0.0122,
    'JPY-ZAR': 0.175,
    'JPY-CNY': 0.066,
    'CAD-USD': 0.75,
    'CAD-INR': 61.2,
    'CAD-EUR': 0.68,
    'CAD-GBP': 0.58,
    'CAD-JPY': 80.0,
    'CAD-AUD': 1.15,
    'CAD-CHF': 0.65,
    'CAD-SGD': 0.99,
    'CAD-ZAR': 14.1,
    'CAD-CNY': 5.4,
    'AUD-USD': 0.65,
    'AUD-INR': 54.2,
    'AUD-EUR': 0.59,
    'AUD-GBP': 0.51,
    'AUD-JPY': 69.6,
    'AUD-CAD': 0.87,
    'AUD-CHF': 0.56,
    'AUD-SGD': 0.86,
    'AUD-ZAR': 12.3,
    'AUD-CNY': 4.8,
    'CHF-USD': 1.12,
    'CHF-INR': 92.4,
    'CHF-EUR': 1.03,
    'CHF-GBP': 0.88,
    'CHF-JPY': 125.0,
    'CHF-CAD': 1.53,
    'CHF-AUD': 1.79,
    'CHF-SGD': 1.52,
    'CHF-ZAR': 21.8,
    'CHF-CNY': 8.3,
    'SGD-USD': 0.75,
    'SGD-INR': 61.1,
    'SGD-EUR': 0.68,
    'SGD-GBP': 0.58,
    'SGD-JPY': 80.0,
    'SGD-CAD': 1.01,
    'SGD-AUD': 1.15,
    'SGD-CHF': 0.66,
    'SGD-ZAR': 14.0,
    'SGD-CNY': 5.35,
    'ZAR-USD': 0.052,
    'ZAR-INR': 4.3,
    'ZAR-EUR': 0.049,
    'ZAR-GBP': 0.041,
    'ZAR-JPY': 5.7,
    'ZAR-CAD': 0.071,
    'ZAR-AUD': 0.081,
    'ZAR-CHF': 0.045,
    'ZAR-SGD': 0.071,
    'ZAR-CNY': 0.38,
    'CNY-USD': 0.14,
    'CNY-INR': 11.5,
    'CNY-EUR': 0.13,
    'CNY-GBP': 0.12,
    'CNY-JPY': 15.3,
    'CNY-CAD': 0.18,
    'CNY-AUD': 0.21,
    'CNY-CHF': 0.12,
    'CNY-SGD': 0.19,
    'CNY-ZAR': 2.62
  };

  final List<Map<String, String>> currencies = [
    {'code': 'AUD', 'name': 'Australian Dollar'},
    {'code': 'CAD', 'name': 'Canadian Dollar'},
    {'code': 'CHF', 'name': 'Swiss Franc'},
    {'code': 'CNY', 'name': 'Chinese Yuan'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'British Pound'},
    {'code': 'HKD', 'name': 'Hong Kong Dollar'},
    {'code': 'INR', 'name': 'Indian Rupee'},
    {'code': 'JPY', 'name': 'Japanese Yen'},
    {'code': 'KRW', 'name': 'South Korean Won'},
    {'code': 'MXN', 'name': 'Mexican Peso'},
    {'code': 'NZD', 'name': 'New Zealand Dollar'},
    {'code': 'RUB', 'name': 'Russian Ruble'},
    {'code': 'SAR', 'name': 'Saudi Riyal'},
    {'code': 'SGD', 'name': 'Singapore Dollar'},
    {'code': 'THB', 'name': 'Thai Baht'},
    {'code': 'TRY', 'name': 'Turkish Lira'},
    {'code': 'USD', 'name': 'United States Dollar'},
    {'code': 'ZAR', 'name': 'South African Rand'},
    {'code': 'AED', 'name': 'United Arab Emirates Dirham'},
  ];

  List<String> getCurrencyDropdownOptions() {
    return currencies
        .map((currency) => '${currency['name']} (${currency['code']})')
        .toList()
      ..sort();
  }

  Future<void> convertCurrency() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));

      double amount = double.parse(amountController.text);
      String fromCurrencyCode =
          selectedFromCurrency.split('(').last.split(')').first;
      String toCurrencyCode =
          selectedToCurrency.split('(').last.split(')').first;
      String pair = '$fromCurrencyCode-$toCurrencyCode';

      double rate = exchangeRates[pair] ?? 1.0;

      setState(() {
        convertedAmount = amount * rate;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownOptions = getCurrencyDropdownOptions();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cross-Border Transfer',
          style: TextStyle(
            backgroundColor: const Color(0xFFDDE0F5),
            //  color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFDDE0F5),
      ),
      backgroundColor: const Color(
          0xFFE8EAF6), // Set the background color for the entire Scaffold
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Send Money Internationally',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money,
                              color: const Color.fromARGB(232, 117, 70, 153)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(232, 117, 70, 153)),
                          ),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(232, 117, 70, 153)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return constraints.maxWidth > 400
                              ? _buildWideDropdowns(dropdownOptions)
                              : _buildStackedDropdowns(dropdownOptions);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (convertedAmount > 0)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Converted Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${convertedAmount.toStringAsFixed(2)} ${selectedToCurrency.split('(').last.split(')').first}',
                          style: TextStyle(
                            fontSize: 24,
                            color: const Color.fromARGB(232, 117, 70, 153),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : convertCurrency,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(232, 117, 70, 153),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Convert & Send',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              SizedBox(height: 20),
              Text(
                'Compliance Notice: International transfers are subject to relevant regulations and KYC requirements.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideDropdowns(List<String> dropdownOptions) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown('From', selectedFromCurrency, dropdownOptions),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _buildDropdown('To', selectedToCurrency, dropdownOptions),
        ),
      ],
    );
  }

  Widget _buildStackedDropdowns(List<String> dropdownOptions) {
    return Column(
      children: [
        _buildDropdown('From', selectedFromCurrency, dropdownOptions),
        SizedBox(height: 20),
        _buildDropdown('To', selectedToCurrency, dropdownOptions),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(232, 117, 70, 153)),
        ),
        labelStyle: TextStyle(color: const Color.fromARGB(232, 117, 70, 153)),
      ),
      items: options.map((String currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(
            currency,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          if (label == 'From') {
            selectedFromCurrency = newValue!;
          } else {
            selectedToCurrency = newValue!;
          }
        });
      },
    );
  }
}
