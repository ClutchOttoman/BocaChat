import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> sendRequest() async {
  final url = Uri.parse(
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1/tips',
  );

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response from server: ${data['tip']}');
    } else {
      print('Server error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}

class BocaInfoPage extends StatelessWidget {
  const BocaInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Boca Info')),
        child: Center(
          child: IconButton(
            onPressed: sendRequest,
            icon: Icon(CupertinoIcons.ant_circle),
          ),
        ),
      ),
    ));
  }
}
