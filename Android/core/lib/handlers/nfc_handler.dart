import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter/material.dart';

class NFCHandler {
  static bool _isScanning = false;

  static void startNFCReading(void Function(String hexIdentifier) onNFCDiscovered, void Function(String errorMessage) onError) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        _isScanning = true;
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            debugPrint('NFC Tag Detected: ${tag.data}');
            List<int> identifierBytes = tag.data['nfca']['identifier'];
            String hexIdentifier = identifierBytes
                .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
                .join('');
            print("NFC Identifier (Hex): $hexIdentifier");

            onNFCDiscovered(hexIdentifier);
          },
        );
      } else {
        print('NFC not available.');
        onError('NFC not available.');
      }
    } catch (e) {
      print('Error reading NFC: $e');
      onError('Error reading NFC: $e');
    }
  }

  static void stopNFCReading() {
    if (_isScanning) {
      NfcManager.instance.stopSession();
      _isScanning = false;
    }
  }
}
