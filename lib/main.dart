import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'textColumn.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('BocaChat')),
        child: textColumn(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
