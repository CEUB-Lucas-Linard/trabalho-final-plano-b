import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../viewmodels/deck_view_model.dart';
import 'flashcard_view.dart';

class DeckView extends StatefulWidget {
  final Deck deck;

  DeckView({required this.deck});

  @override
  _DeckViewState createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  late Future<List<Flashcard>> _flashcardsFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final deckViewModel = Provider.of<DeckViewModel>(context, listen: false);
    _flashcardsFuture = deckViewModel.loadDeck(widget.deck.id!);
  }

  Future<void> _refreshFlashcards() async {
    final deckViewModel = Provider.of<DeckViewModel>(context, listen: false);
    setState(() {
      _flashcardsFuture = deckViewModel.loadDeck(widget.deck.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.deck.title)),
      body: Stack(
        children: [
          FutureBuilder<List<Flashcard>>(
            future: _flashcardsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar flashcards.'));
              }
              final flashcards = snapshot.data ?? [];
              if (flashcards.isEmpty) {
                return Center(child: Text('Nenhum flashcard neste deck.'));
              }
              return Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    final card = flashcards[index];
                    return ListTile(
                      title: Text(card.question),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlashcardView(flashcard: card, deck: widget.deck),
                          ),
                        );
                        if (result == true) {
                          _refreshFlashcards();
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    label: Text('Adicionar Flashcard'),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardView(
                            flashcard: Flashcard(
                              id: null,
                              deckId: widget.deck.id!,
                              question: '',
                              answer: '',
                            ),
                            deck: widget.deck,
                          ),
                        ),
                      );
                      if (result == true) {
                        _refreshFlashcards();
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.quiz),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                    ),
                    label: Text('Começar Quiz'),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}