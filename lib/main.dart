import 'package:flutter/material.dart';
import 'screens/dang_ky.dart';

void main() {
  runApp(ChicktionaryApp());
}

class ChicktionaryApp extends StatelessWidget {
  const ChicktionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicktionary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Itim',
        scaffoldBackgroundColor: Color(0xFFFFFDE5),
      ),
      home: DangKy(),
    );
  }
}
