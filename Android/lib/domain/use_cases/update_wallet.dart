import 'package:ws/services/wallet_service.dart';

class UpdateWallet {
  final WalletService _walletService;

  UpdateWallet(this._walletService);

  Future<void> execute(int userID, double amount) async {
    return await _walletService.updateWalletValue(userID, amount);
  }
}