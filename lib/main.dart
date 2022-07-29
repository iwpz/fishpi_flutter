import 'package:fishpi_flutter/pages/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '摸鱼派',
      home: SplashPage(),
      // initialRoute: 'splash_page',
      routes: {
        'splash_page': (context) => const SplashPage(),
      },
    );
  }
}
