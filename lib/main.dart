import 'package:flutter/material.dart';
import 'package:learn_english_words/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Учим английские слова',
      // theme: ThemeData(
      //     primarySwatch: Colors.indigo,
      //     canvasColor: Colors.transparent
      // ),
      home: HomePage(title: 'Мой словарь'),
    );
  }
}