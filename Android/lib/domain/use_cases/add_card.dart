import 'package:ws/services/card_service.dart';

class AddCard {
  final CardService _cardService;

  AddCard(this._cardService);

  Future<void> execute(int userID, String cardValue) async {
    await _cardService.sendAddNewCard(userID, cardValue);
  }
}
