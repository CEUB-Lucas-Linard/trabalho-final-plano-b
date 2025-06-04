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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Novo Deck',
            onPressed: () {
              _showCreateDialog(context, deckViewModel);
            },
          ),
        ],
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
                      onPressed: () async {
                        await deckViewModel.deleteDeck(deck.id!);
                        deckViewModel.loadDecks();
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

  void _showCreateDialog(BuildContext context, DeckViewModel deckViewModel) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Novo Deck'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Título do Deck'),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Criar'),
            onPressed: () async {
              await deckViewModel.createDeck(controller.text);
              Navigator.pop(context);
              deckViewModel.loadDecks();
            },
          ),
        ],
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
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
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
}