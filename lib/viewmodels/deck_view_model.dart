
import 'package:flutter/material.dart';
import '../models/deck.dart';
import '../models/database_helper.dart';

class DeckViewModel extends ChangeNotifier {
  List<Deck> _decks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Deck> get decks => _decks;

  Future<void> loadDecks() async {
    _decks = await _dbHelper.getDecks();
    notifyListeners();
  }

  Future<void> createDeck(String title) async {
    final newDeck = Deck(title: title);
    await _dbHelper.insertDeck(newDeck);
    await loadDecks();
  }

  Future<void> updateDeck(int i, title) async {
    final deck = Deck(id:i, title: title);
    await _dbHelper.updateDeck(deck);
    await loadDecks();
  }

  Future<void> deleteDeck(int id) async {
    await _dbHelper.deleteDeckById(id);
    await loadDecks();
  }

}
