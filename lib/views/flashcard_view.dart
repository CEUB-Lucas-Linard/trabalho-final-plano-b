import 'package:app_estudos/models/deck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../viewmodels/deck_view_model.dart';

class FlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  final Deck deck;

  FlashcardView({required this.flashcard, required this.deck});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.flashcard.question);
    _answerController = TextEditingController(text: widget.flashcard.answer);
    _isEditing = widget.flashcard.id == null;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _save() async {
    final deckViewModel = Provider.of<DeckViewModel>(context, listen: false);
    if (widget.flashcard.id == null) {
      await deckViewModel.addFlashcard(
        widget.deck.id!,
        _questionController.text,
        _answerController.text,
      );
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard criado!'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    } else {
      await deckViewModel.updateFlashcard(
        widget.flashcard.id!,
        widget.deck.id!,
        _questionController.text,
        _answerController.text,
      );
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard atualizado!'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  void _delete() async {
    final deckViewModel = Provider.of<DeckViewModel>(context, listen: false);
    await deckViewModel.deleteFlashcard(widget.flashcard.id!);
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Flashcard excluído!'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _save();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
          if (widget.flashcard.id != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _delete,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Pergunta'),
              enabled: _isEditing,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Resposta'),
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }
}