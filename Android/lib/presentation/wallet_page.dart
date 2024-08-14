import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ws/privateAddress.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double walletBalance = 12.0;

  @override
  void initState() {
    super.initState();
    fetchWallet(); // Call fetchWallet here
  }

  void fetchWallet() async {
    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    print('Fetching wallet');
    final url = 'http://${returnAddress()}:8080/api/user/getWalletByUserId/$userId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      walletBalance = json;
    });
    print(walletBalance);
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
              // Card-like container for wallet balance
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
                child: Column(
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
                      '\$${walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),
              // Add Money Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, 'paymentPageRoute');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.blueAccent, // Button background color
                  elevation: 5.0, // Adds shadow to the button
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
      backgroundColor: Colors.blue[50], // Light blue background for contrast
    );
  }
}
