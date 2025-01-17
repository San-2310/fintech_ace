import 'dart:async';
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
  List<dynamic> _queuedTransactions = [];
  bool _isOffline = false;
  bool _isLoading = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
    _loadAllTransactions();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  bool _checkIfOffline(List<ConnectivityResult> connectivityResults) {
    return !(connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi));
  }

  // Initialize connectivity listener
  void _initializeConnectivity() async {
    // Initial connectivity check
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      bool wasOffline = _isOffline;
      setState(() {
        _isOffline = _checkIfOffline(results);
      });

      // If we just came back online
      if (wasOffline && !_isOffline) {
        await _loadTransactionsFromApi();
        await _syncQueuedTransactions();
      }
    });
  }

  // Check if the device is online or offline
  Future<void> _checkConnectivity() async {
    var connectivityResults = await (Connectivity().checkConnectivity());
    setState(() {
      _isOffline = _checkIfOffline(connectivityResults);
    });
  }

  // Load both regular and queued transactions
  Future<void> _loadAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    // Load regular transactions
    final transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      setState(() {
        _transactions = List.from(json.decode(transactionsJson));
      });
    }

    // Load queued transactions
    final queuedTransactionsJson = prefs.getString('queued_transactions');
    if (queuedTransactionsJson != null) {
      setState(() {
        _queuedTransactions = List.from(json.decode(queuedTransactionsJson));
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Fetch transactions from mock API and store them in SharedPreferences
  Future<void> _loadTransactionsFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.100:3000/transactions'));

      if (response.statusCode == 200) {
        final List<dynamic> transactions = json.decode(response.body);
        _saveTransactions(transactions);

        setState(() {
          _transactions = transactions;
        });
      } else {
        _showError('Failed to load transactions');
      }
    } catch (e) {
      _showError('Network error: Unable to fetch transactions');
    }
  }

  // Save regular transactions to SharedPreferences
  Future<void> _saveTransactions(List<dynamic> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactions', json.encode(transactions));
  }

  // Save queued transactions to SharedPreferences
  Future<void> _saveQueuedTransactions(List<dynamic> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('queued_transactions', json.encode(transactions));
  }

  // Add new transaction
  Future<void> _addTransaction() async {
    final amount = _amountController.text;
    final recipient = _recipientController.text;
    final title = _titleController.text;

    if (amount.isEmpty || recipient.isEmpty || title.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    final newTransaction = {
      'amount': int.parse(amount),
      'recipient': recipient,
      'title': title,
      'userId': "test",
      'status': _isOffline ? 'pending' : 'success',
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isOffline) {
      // Add to queued transactions
      setState(() {
        _queuedTransactions.add(newTransaction);
      });
      _saveQueuedTransactions(_queuedTransactions);
      _showSuccess('Transaction queued: $title');
    } else {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.100:3000/transactions'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newTransaction),
        );

        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          setState(() {
            _transactions.insert(0, responseData);
          });
          _saveTransactions(_transactions);
          _showSuccess('Transaction added: $title');
        } else {
          _showError('Failed to add transaction');
        }
      } catch (e) {
        _showError('Network error: Unable to add transaction');
      }
    }

    // Clear input fields
    _amountController.clear();
    _recipientController.clear();
    _titleController.clear();
  }

  // Sync queued transactions when online
  Future<void> _syncQueuedTransactions() async {
    if (_isOffline || _queuedTransactions.isEmpty) return;

    List<dynamic> successfullySync = [];
    List<dynamic> failedToSync = [];

    for (var transaction in _queuedTransactions) {
      try {
        // Update status to success before sending
        transaction['status'] = 'success';

        final response = await http.post(
          Uri.parse('http://192.168.0.100:3000/transactions'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaction),
        );

        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          successfullySync.add(responseData);

          // Add to regular transactions
          setState(() {
            _transactions.insert(0, responseData);
          });
        } else {
          // Revert status if failed
          transaction['status'] = 'pending';
          failedToSync.add(transaction);
        }
      } catch (e) {
        // Revert status if failed
        transaction['status'] = 'pending';
        failedToSync.add(transaction);
      }
    }

    // Update regular transactions in SharedPreferences
    await _saveTransactions(_transactions);

    // Update queued transactions with only failed ones
    setState(() {
      _queuedTransactions = failedToSync;
    });
    await _saveQueuedTransactions(failedToSync);

    if (successfullySync.isNotEmpty) {
      _showSuccess('Synced ${successfullySync.length} transactions');
    }
    if (failedToSync.isNotEmpty) {
      _showError('Failed to sync ${failedToSync.length} transactions');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
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
                Navigator.pop(context);
                _addTransaction();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTransactions = [..._transactions, ..._queuedTransactions];

    return Scaffold(
      backgroundColor: const Color(0xFFDDE0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDE0F5),
        title: const Text('Transactions'),
        actions: [
          if (_isOffline)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.wifi_off, color: Colors.red),
            )
        ],
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
                  if (_queuedTransactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_queuedTransactions.length} transactions pending sync',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = allTransactions[index];
                        final isPending = transaction['status'] == 'pending';

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(transaction['title']),
                            subtitle: Text(
                              '₹${transaction['amount']} to ${transaction['recipient']}',
                            ),
                            trailing: isPending
                                ? const Icon(Icons.pending,
                                    color: Colors.orange)
                                : const Icon(Icons.check_circle,
                                    color: Colors.green),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Visibility(
        visible: !_isOffline && _queuedTransactions.isNotEmpty,
        child: FloatingActionButton(
          onPressed: _syncQueuedTransactions,
          child: const Icon(Icons.sync),
        ),
      ),
    );
  }
}
