import 'package:flutter/material.dart';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../domain/controllers/wallet_controller.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<double> walletBalance = Future.value(0);
  late WalletController _walletController;

  @override
  void initState() {
    super.initState();
    _walletController = WalletController();
    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    if (userId != null) {
      assignBalance(userId);
    }
  }

  void assignBalance(int userId) {
    setState(() {
      walletBalance = _walletController.fetchWallet(userId);
    });
  }

  void _showAddMoneyPrompt(BuildContext context) {
    TextEditingController _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Add Money'),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                double? amount = double.tryParse(_amountController.text);
                if (amount != null && amount > 0) {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(
                    context,
                    'paymentPageRoute',
                    arguments: {'amount': amount, 'description' : 'Deposit into wallet', 'itemName': 'Wallet deposit', 'quantity' : '1', 'currency' : 'USD'},
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'userModePageRoute');
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15.0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: FutureBuilder<double>(
                  future: walletBalance,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Display error
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          const Text(
                            'Your Balance',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '\$${snapshot.data!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('No balance available');
                    }
                  },
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  _showAddMoneyPrompt(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.blueAccent,
                  elevation: 5.0,
                ),
                child: const Text(
                  'Add Money',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
