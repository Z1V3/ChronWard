import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter/material.dart';

class NFCHandler {
  static Future<void> startNFCReading() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        NfcManager.instance.startSession(
            onDiscovered: (NfcTag tag) async {
              debugPrint('NFC Tag Detected: ${tag.data}');
              List<int> identifierBytes = tag.data['nfca']['identifier'];
              String hexIdentifier = identifierBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
              print("NFC Identifier (Hex): $hexIdentifier");
          },
        );
      } else {
        print('NFC not available.');
      }
    } catch (e) {
      print('Error reading NFC: $e');
    }
  }
}
