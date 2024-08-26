import 'package:flutter/material.dart';
import 'package:core/handlers/nfc_handler.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
import '../domain/controllers/wallet_controller.dart';
import 'dart:async';

class ChargeModePaymentPage extends StatefulWidget {
  final double amount;
  const ChargeModePaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  _ChargeModePaymentPageState createState() => _ChargeModePaymentPageState();
}

class _ChargeModePaymentPageState extends State<ChargeModePaymentPage>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late WalletController _walletController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _walletController = WalletController();
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _startCardScanning() {
    setState(() {
      _isScanning = true;
    });
    _controller.forward();

    _walletController = WalletController();

    NFCHandler.startNFCReading(
          (hexIdentifier) async {
        NFCHandler.stopNFCReading();
        setState(() {
          _isScanning = false;
        });

        if (!context.mounted) return;
        _showSnackbar(context, "Paid successfully!");
        Navigator.pushReplacementNamed(context, 'chargeModePageRoute');
      },
          (errorMessage) {
        setState(() {
          _isScanning = false;
        });
        _showSnackbar(context, 'Card was not read successfully!');
        debugPrint(
            "Error occurred while reading NFC: $errorMessage");
      },
    );

    _timer = Timer(Duration(seconds: 15), () {
      setState(() {
        _isScanning = false;
      });
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _startCardScanning();
              },
              child: Text('Pay with Card'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int userId = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;
                double wallet = await _walletController.fetchWallet(userId);
                if(wallet > widget.amount){
                  wallet -= widget.amount;
                  _walletController.updateWallet(userId, wallet);
                  _showSnackbar(context, "Paid successfully!");
                  Navigator.pushReplacementNamed(context, 'chargeModePageRoute');
                }else{
                  _showSnackbar(context, "Not enough money in wallet!");
                }
              },
              child: Text('Pay with Wallet'),
            ),
            Spacer(),
            if (_isScanning)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: _animation.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please scan your card...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
