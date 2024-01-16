import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:android/privateAddress.dart';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _ChargeModePageState();
}


class _ChargeModePageState extends State<AddCardPage>{

  NFCTag? _tag;
  String _result = "";
  bool _readCard = false;
  int _resultStart = 1;

  @override
  void initState(){
    super.initState();

    startNFC();
    if(_resultStart == 0){
      readNFC();
      if(_readCard == true){
        sendAddNewCard(_result);
      }
    }
  }

  void startNFC() async {
    print('Please scan your card!');
    bool errorChecker = false;

    try {
      final NFCTag tag = await FlutterNfcKit.poll();
      setState(() {
        _tag = tag;
      });

      if (tag.type == NFCTagType.iso18092) {
        String result1 =
            await FlutterNfcKit.transceive("060080080100");
        setState(() {
          _result = '1: $result1\n';
        });
      } else if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        setState(() {
          _result = ndefString;
        });
      } else if (tag.type == NFCTagType.webusb) {
        await FlutterNfcKit.transceive(
            "00A4040006D27600012401");
      }

    } catch (e) {
      setState(() {
        _result = 'error: $e';
        errorChecker = true;
      });
    }
    if(errorChecker == true){
      _resultStart = 1;
    }else{
      _resultStart = 0;
    }
  }

  void readNFC() async{
    var ndefRecords = await FlutterNfcKit.readNDEFRecords();
    var ndefString = '';
    for (int i = 0; i < ndefRecords.length; i++) {
      ndefString += '${i + 1}: ${ndefRecords[i]}\n';
    }
    setState(() {
      _readCard = true;
      _result = ndefString;
    });

    await Navigator.pushReplacementNamed(context, 'userModePageRoute');
  }

  Future<void> sendAddNewCard(String cardValue) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/card/addNewCard');

    int userID = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'UserID': userID,
        'Value': cardValue,
      }));

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'startMenuRoute');
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge Mode'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.black87,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Please scan you card...',
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
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onClick;

  const CircleButton({super.key, required this.label, this.onClick});

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