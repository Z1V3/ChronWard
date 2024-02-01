import '../use_cases/add_card.dart';
import 'dart:async';

class CardController {
  final AddCard _addCard;

  CardController(this._addCard);

  Future<void> sendAddNewCard(String cardValue) async {
    await _addCard.execute(cardValue);
  }
}
