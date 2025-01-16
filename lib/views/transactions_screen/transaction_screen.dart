import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<dynamic> _transactions = [];
  bool _isOffline = false;
  bool _isLoading = true;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadTransactions();
  }

  // Check if the device is online or offline
  void _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });

    if (!_isOffline) {
      // Load transactions from API if online
      _loadTransactionsFromApi();
    }
  }

  // Fetch transactions from mock API and store them in SharedPreferences
  Future<void> _loadTransactionsFromApi() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.100:3000/transactions'));

    if (response.statusCode == 200) {
      final List<dynamic> transactions = json.decode(response.body);

      // Store transactions in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('transactions', json.encode(transactions));

      setState(() {
        _transactions = transactions;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load transactions')),
      );
    }
  }

  // Load transactions from SharedPreferences (used when the app starts or when offline)
  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions');

    if (transactionsJson != null) {
      setState(() {
        _transactions = List.from(json.decode(transactionsJson));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save transactions to SharedPreferences
  void _saveTransactions(List<dynamic> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactions', json.encode(transactions));
  }

  // Add new transaction (offline or online)
  Future<void> _addTransaction() async {
    final amount = _amountController.text;
    final recipient = _recipientController.text;
    final title = _titleController.text;

    if (amount.isEmpty || recipient.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newTransaction = {
      'amount': int.parse(amount),
      'recipient': recipient,
      'title': title,
      'userId': "test",
      'status': _isOffline ? 'pending' : 'success',
    };

    if (_isOffline) {
      _transactions.insert(0, newTransaction);
      _saveTransactions(_transactions);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction queued: $title')),
      );
    } else {
      final response = await http.post(
        Uri.parse('http://192.168.0.100:3000/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newTransaction),
      );

      if (response.statusCode == 201) {
        setState(() {
          _transactions.insert(0, json.decode(response.body));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction added: $title')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add transaction')),
        );
      }

      _saveTransactions(_transactions);
    }
  }

  // Sync queued transactions when the device is online
  Future<void> _syncTransactions() async {
    if (!_isOffline && _transactions.isNotEmpty) {
      // Loop through queued transactions and sync with the API
      for (var queuedTransaction in _transactions) {
        final response = await http.post(
          Uri.parse('http://192.168.0.100:3000/transactions'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(queuedTransaction),
        );

        if (response.statusCode == 201) {
          // Remove the synced transaction from the list
          _transactions.removeAt(0);
        }
      }
      _saveTransactions(_transactions);
    }
  }

  // Show dialog to add a transaction
  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: 'Recipient'),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTransaction();
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
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
        title: const Text('Transactions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showAddTransactionDialog,
                    child: const Text('Add New Transaction'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(transaction['title']),
                            subtitle: Text(
                                '₹${transaction['amount']} to ${transaction['recipient']}'),
                            trailing: Text(transaction['status']),
                            leading: CircleAvatar(
                              child: Text(transaction['id'] ?? 'ID'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Visibility(
        visible: !_isOffline,
        child: FloatingActionButton(
          onPressed: _syncTransactions,
          child: const Icon(Icons.sync),
        ),
      ),
    );
  }
}
