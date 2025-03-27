import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       color: Colors.blue,
  //       child: Padding(
  //         padding: const EdgeInsets.only(left: 16, top: 32),
  //         child: Text("Hello, Flutter!"),
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Icon(Icons.home),
              Icon(Icons.favorite),
              Icon(Icons.settings)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text("Item 1"),
            Text("Item 2222"),
            Text("Item 333333"),
          ],),
          Stack(
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.network("https://cataas.com/cat"),
              ),
              Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Text("Promoção", style: TextStyle(
                  fontSize: 30
                ),),
              )
            ],
          )
        ],
        ),
      );
  }

  const MyHomePage({super.key, required this.title});
}
