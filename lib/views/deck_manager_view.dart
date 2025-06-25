import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/deck.dart';
import '../viewmodels/deck_view_model.dart';

class DeckManagerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deckViewModel = Provider.of<DeckViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar Decks',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
      ),
      body: FutureBuilder(
        future: deckViewModel.loadDecks(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: deckViewModel.decks.length,
            itemBuilder: (context, index) {
              final deck = deckViewModel.decks[index];
              return ListTile(
                title: Text(deck.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, deck, deckViewModel);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDeleteDeck(context, deckViewModel, deck.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Deck deck, DeckViewModel deckViewModel) {
    final controller = TextEditingController(text: deck.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar Deck'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Título do Deck'),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            child: Text('Salvar'),
            onPressed: () async {
              await deckViewModel.updateDeck(deck.id!, controller.text);
              Navigator.pop(context);
              deckViewModel.loadDecks();
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteDeck(BuildContext context, DeckViewModel deckViewModel, int deckId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Deck'),
        content: Text('Tem certeza que deseja excluir este deck? Esta ação não pode ser desfeita.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            child: Text('Excluir'),
            onPressed: () async {
              await deckViewModel.deleteDeck(deckId);
              Navigator.pop(context);
              deckViewModel.loadDecks();
            },
          ),
        ],
      ),
    );
  }
}