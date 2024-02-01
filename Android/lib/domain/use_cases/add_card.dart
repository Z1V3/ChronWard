import 'package:ws/services/card_service.dart';

class AddCard {
  final CardService _cardService;

  AddCard(this._cardService);

  Future<void> execute(String cardValue) async {
    await _cardService.sendAddNewCard(cardValue);
  }
}
