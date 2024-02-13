import 'package:ws/services/card_service.dart';

import '../use_cases/add_card.dart';
import 'dart:async';

import '../use_cases/authenticate_card.dart';

class CardController {
  late final AddCard _addCard;
  late final AuthenticateCard _authenticateCard;

  CardController(){
    _addCard = AddCard(CardService());
    _authenticateCard = AuthenticateCard(CardService());
  }

  Future<void> sendAddNewCard(int userID, String cardValue) async {
    await _addCard.execute(userID, cardValue);
  }

  Future<bool> sendAuthenticateCard(String cardValue) async {
    return await _authenticateCard.execute(cardValue);
  }
}
