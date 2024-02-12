import 'package:flutter/material.dart';
import 'package:core/handlers/nfc_handler.dart';
import 'package:android/domain/controllers/card_controller.dart';
import 'package:ws/services/card_service.dart';
import 'package:android/domain/use_cases/add_card.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  late CardController _cardController;
  bool _isLoading = true; // Set initial loading state to true

  @override
  void initState() {
    super.initState();
    _cardController = CardController(AddCard(CardService()));
    NFCHandler.startNFCReading(
          (hexIdentifier) {
        setState(() {
          _isLoading = false; // Update loading state when NFC reading is complete
        });
        debugPrint("Received NFC Identifier (Hex): $hexIdentifier");
        int userID = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;
        _cardController.sendAddNewCard(userID, hexIdentifier);
        // Show Snackbar when the card is added successfully
        _showSnackbar(context, 'Card added successfully');
        Navigator.pushReplacementNamed(context, 'userModePageRoute');
      },
          (errorMessage) {
        setState(() {
          _isLoading = false; // Update loading state when NFC reading encounters an error
        });
        debugPrint("Error occurred while reading NFC: $errorMessage");
        // Handle the error
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge Mode'),
        backgroundColor: Colors.lightBlue[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'userModePageRoute');
          },
        ),
      ),
      drawer: const DrawerWidget(),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator() // Show loading indicator if isLoading is true
              else
                const SizedBox(height: 40), // Empty SizedBox if not loading
              const Text(
                'Please scan your card...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onClick;

  const CircleButton({Key? key, required this.label, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
        backgroundColor: Colors.blue,
        minimumSize: const Size(200, 200),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
