import 'package:flutter/material.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  InsurancePageState createState() => InsurancePageState();
}

class InsurancePageState extends State<InsurancePage> {
  double baseValue = 1000;
  double monthlyPremium = 50;
  List<bool> selectedAddons = [false, false, false, false];
  final _formKey = GlobalKey<FormState>();

  // Personal Information
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Health Information
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  bool hasPreExistingConditions = false;
  bool isSmoker = false;
  String exerciseFrequency = 'Rarely';

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // Future<void> _createStripeCustomer() async {
  //   final url = Uri.parse('https://api.stripe.com/v1/customers');
  //   final apiKey =
  //       'sk_test_51PnS1LRrPd3YsHcx31PFAe9bnACEeVcAb2bkNKxnr5U38faxO0plBohooJnwtFFF7WvMgJL0WLVFbVx1pM58MoU600youJ2Mdf'; // Use your Stripe secret key

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $apiKey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: {
  //         'email': 'customer@example.com', // You would get this from user input
  //         'name': _nameController.text,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       print('Customer created: ${data['id']}');

  //       // Navigate back to home on success
  //       if (mounted) {
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //           (route) => false,
  //         );
  //       }
  //     } else {
  //       print('Failed to create customer: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  void updatePremium() {
    double newPremium = baseValue / 20;

    // Add 20% for each selected addon
    for (var selected in selectedAddons) {
      if (selected) {
        newPremium += (baseValue / 20) * 0.2;
      }
    }

    // Adjust for health factors
    if (isSmoker) newPremium *= 1.5;
    if (exerciseFrequency == 'Frequently') newPremium *= 0.9;

    setState(() {
      monthlyPremium = newPremium;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
          backgroundColor: const Color(0xFFDDE0F5),
          title: const Text('Insurance Application')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Base Coverage Section
                Text(
                  'Choose Base Coverage',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('₹${baseValue.toStringAsFixed(0)}'),
                Slider(
                  min: 1000,
                  max: 100000,
                  value: baseValue,
                  onChanged: (value) {
                    setState(() {
                      baseValue = value;
                      updatePremium();
                    });
                  },
                ),
                Text(
                  'Monthly Premium: ₹${monthlyPremium.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),

                // Add-ons Section
                Text(
                  'Add-on Coverage',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                CheckboxListTile(
                  title: const Text('Diagnostic Coverage'),
                  value: selectedAddons[0],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAddons[0] = value!;
                      updatePremium();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Preventive Care'),
                  value: selectedAddons[1],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAddons[1] = value!;
                      updatePremium();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Emergency Care'),
                  value: selectedAddons[2],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAddons[2] = value!;
                      updatePremium();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Prescription Coverage'),
                  value: selectedAddons[3],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAddons[3] = value!;
                      updatePremium();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Personal Information Section
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Health Information Section
                Text(
                  'Health Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                CheckboxListTile(
                  title: const Text('Pre-existing Conditions'),
                  value: hasPreExistingConditions,
                  onChanged: (bool? value) {
                    setState(() {
                      hasPreExistingConditions = value!;
                      updatePremium();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Smoker'),
                  value: isSmoker,
                  onChanged: (bool? value) {
                    setState(() {
                      isSmoker = value!;
                      updatePremium();
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: exerciseFrequency,
                  decoration: const InputDecoration(
                    labelText: 'Exercise Frequency',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Rarely', child: Text('Rarely')),
                    DropdownMenuItem(
                        value: 'Sometimes', child: Text('Sometimes')),
                    DropdownMenuItem(
                        value: 'Frequently', child: Text('Frequently')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      exerciseFrequency = newValue!;
                      updatePremium();
                    });
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigate to confirmation page or process form
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmationPage(
                              totalCost: monthlyPremium,
                              personalInfo: {
                                'name': nameController.text,
                                'age': ageController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'address': addressController.text,
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit Application'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final double totalCost;
  final Map<String, String> personalInfo;

  const ConfirmationPage({
    super.key,
    required this.totalCost,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Application')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Summary',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Name: ${personalInfo['name']}'),
            Text('Age: ${personalInfo['age']}'),
            Text('Email: ${personalInfo['email']}'),
            Text('Phone: ${personalInfo['phone']}'),
            const SizedBox(height: 20),
            Text(
              'Monthly Premium: ₹${totalCost.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Edit Application'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submission
                    // You would typically send this to your backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Application submitted successfully!'),
                      ),
                    );
                  },
                  child: const Text('Confirm & Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
