import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const String INITIAL_TEXT = 'Initial Text';

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
        navigationBar: CupertinoNavigationBar(middle: Text('Home')),
        child: textColumn(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class textColumn extends StatefulWidget {
  const textColumn({super.key});

  _textColumn createState() => _textColumn();
}

class _textColumn extends State<textColumn> {
  final List<String> inputs = List.empty(growable: true);
  late ScrollController _scrollController;
  late TextEditingController _inputTextController;
  late TextEditingController _exampleTextController;

  void inputText(String text) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 20,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
    setState(() {
      _inputTextController.text = INITIAL_TEXT;
      _exampleTextController.text = text;
      inputs.add(text);
    });
  }

  @override
  void initState() {
    super.initState();
    _exampleTextController = TextEditingController(text: '');
    _scrollController = ScrollController()..addListener(_scrollListener);
    _inputTextController = TextEditingController(text: INITIAL_TEXT);
  }

  @override
  void dispose() {
    _exampleTextController.dispose();
    _scrollController.dispose();
    _inputTextController.dispose();
    inputs.removeRange(0, inputs.length - 1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Expanded(
          child: CupertinoScrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: inputs.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return (CupertinoListTile(
                  title: Text("${inputs[index]}: $index"),
                ));
              },
            ),
          ),
        ),
        CupertinoTextField(
          controller: _inputTextController,
          onSubmitted: inputText,
        ),
      ],
    ));
  }

  void _scrollListener() {
    print("Scroll Position: ${_scrollController.position}");
  }
}
