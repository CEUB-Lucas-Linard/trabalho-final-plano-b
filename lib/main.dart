import 'package:app_estudos/viewmodels/deck_view_model.dart';
import 'package:app_estudos/viewmodels/user_view_model.dart';
import 'package:app_estudos/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => DeckViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flashcard Quiz',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LoginView(),
      ),
    );
  }
}
