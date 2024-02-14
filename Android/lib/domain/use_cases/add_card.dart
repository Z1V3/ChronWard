import 'package:ws/services/card_service.dart';

class AddCard {
  final CardService _cardService;

  AddCard(this._cardService);

  Future<int> execute(int userID, String cardValue) async {
    return await _cardService.sendAddNewCard(userID, cardValue);
  }
}
