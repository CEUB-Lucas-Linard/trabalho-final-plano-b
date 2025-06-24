import 'package:app_estudos/views/deck_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/deck_view_model.dart';
import '../viewmodels/user_view_model.dart';
import 'deck_view.dart';
import 'login_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deckViewModel = Provider.of<DeckViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            final user = userViewModel.currentUser;
            return Text(
              user != null ? 'Bem-vindo, ${user.name}' : 'Bem-vindo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<UserViewModel>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginView()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meus Decks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: 'Gerenciar Decks',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DeckManagerView()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: FutureBuilder(
                future: deckViewModel.loadDecks(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: deckViewModel.decks.length,
                    itemBuilder: (context, index) {
                      final deck = deckViewModel.decks[index];
                      return ListTile(
                        title: Text(deck.title),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeckView(deck: deck),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}