import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

const String INITIAL_TEXT = 'Initial Text';
const Widget sendButtonIcon = Icon(CupertinoIcons.arrow_up_circle_fill);
const Widget loadingAnim = CupertinoActivityIndicator(color: Colors.blueAccent);

class textColumn extends StatefulWidget {
  const textColumn({super.key});

  @override
  _textColumn createState() => _textColumn();
}

class _textColumn extends State<textColumn> {
  final List<String> inputs = List.empty(growable: true);
  late ScrollController _scrollController;
  late TextEditingController _inputTextController;
  Widget textInputButton = sendButtonIcon;
  bool isLoading = false;

  void setLoading(bool state) {
    setState(() {
      isLoading = state;
      if (state) {
        textInputButton = loadingAnim;
      } else {
        textInputButton = sendButtonIcon;
      }
    });
  }

  Future<void> inputRequest(String message) async {
    try {
      setLoading(true);
      await sendRequest(message);
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendRequest(String message) async {
    final url = Uri.parse('$siteUrl/chat');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Response from server: ${data['response']}');
        }
        setState(() {
          _inputTextController.text = INITIAL_TEXT;
          inputs.add(data['response']);
        });
      } else {
        if (kDebugMode) {
          print('Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _inputTextController = TextEditingController(text: INITIAL_TEXT);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputTextController.dispose();
    inputs.removeRange(0, inputs.length - 1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Run below function after widget is rebuilt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });

    var messageFontSize = Theme.of(context).textTheme.bodyMedium!;

    return (SafeArea(
      child: Column(
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
                  //Message Reply Box
                  return (Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                      padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${inputs[index]}: $index",
                        style: messageFontSize,
                      ),
                    ),
                  ));
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CupertinoTextField(
                  controller: _inputTextController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  suffixMode: OverlayVisibilityMode.always,
                  maxLines: 4,
                  minLines: 1,
                  suffix: CupertinoButton(
                    borderRadius: BorderRadius.circular(0.5),
                    onPressed:
                        isLoading
                            ? null
                            : () => inputRequest(_inputTextController.text),
                    sizeStyle: CupertinoButtonSize.medium,
                    child: textInputButton,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _scrollListener() {
    //print("Scroll Position: ${_scrollController.position.pixels}");
  }
}
