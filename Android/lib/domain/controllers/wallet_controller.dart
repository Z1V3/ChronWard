import 'package:android/domain/use_cases/fetch_wallet.dart';
import 'package:android/domain/use_cases/update_wallet.dart';
import 'package:ws/services/wallet_service.dart';
import 'dart:async';

class WalletController {
  late final FetchWallet _fetchWallet;
  late final UpdateWallet _updateWallet;

  WalletController(){
    _fetchWallet = FetchWallet(WalletService());
    _updateWallet = UpdateWallet(WalletService());
  }
  Future<double> fetchWallet(int userId) async {
    return await _fetchWallet.execute(userId);
  }

  Future<void> updateWallet(int userId, double amount) async {
    return await _updateWallet.execute(userId, amount);
  }

}
