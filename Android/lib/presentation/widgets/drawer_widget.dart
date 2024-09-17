import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color myColor = Color(0xFFADD8E6);
    final String role = Provider.of<UserProvider>(context, listen: false).user?.role ?? "";
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: myColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'userModePageRoute');
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('My Cards'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'rfidCardsPage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Card'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'addCardPageRoute');
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('Wallet'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'walletPageRoute');
            },
          ),
          if (role == "admin")
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'statisticsPageRoute');
              },
            ),
        ],
      ),
    );
  }
}
