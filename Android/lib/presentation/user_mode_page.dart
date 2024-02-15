import 'package:flutter/material.dart';
import 'package:core/services/authentication/google_sign_out_auth.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:android/presentation/rfid_cards_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModePage extends StatefulWidget {
  @override
  _UserModePageState createState() => _UserModePageState();
}

class _UserModePageState extends State<UserModePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    loadSavedUserName();
  }

  Future<void> loadSavedUserName() async {
    String? userName = await SharedHandlerUtil.getSavedUserName();
    setState(() {
      username = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color myColor = Colors.white70;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/electrical_vehicle.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'EVCharge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignOutService.signOutWithGoogle(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                'startMenuRoute',
                    (route) => false, // Remove all routes until the startMenuRoute
              );
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Container(
        color: myColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        '$username',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/autich.png'),
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 100.0,
              decoration: const BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -9),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Container(
                color: myColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'chargeHistoryPageRoute');
                          },
                          icon: const Icon(Icons.history,
                              size: 30, color: Colors.black),
                        ),
                        const Text(
                          'Charging History',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RfidCardsPage()),
                            );
                          },
                          icon: const Icon(Icons.credit_card,
                              size: 30, color: Colors.black87),
                        ),
                        const Text(
                          'My Cards',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'addCardPageRoute');
                          },
                          icon: const Icon(Icons.add,
                              size: 30, color: Colors.black87),
                        ),
                        const Text(
                          'Add Card',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
