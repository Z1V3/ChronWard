import 'package:ws/services/wallet_service.dart';

class FetchWallet {
  final WalletService _walletService;

  FetchWallet(this._walletService);

  Future<double> execute(int userID) async {
    return await _walletService.fetchWallet(userID);
  }
}