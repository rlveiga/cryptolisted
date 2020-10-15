import 'package:flutter/material.dart';

import './src/screens/home.dart';
import './src/theme/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptolisted',
      theme: appTheme(),
      home: HomePage(title: 'Cryptolisted'),
    );
  }
}
