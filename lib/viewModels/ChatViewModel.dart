// text_column.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/ConversationModel.dart';

const String INITIAL_TEXT = 'Initial Text';

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

class ChatViewModel {
  final _messagesController = StreamController<Conversation>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();

  final Conversation _messages = Conversation(messageList: [], newTopic: "");

  Stream<Conversation> get messagesStream => _messagesController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  void dispose() {
    _messagesController.close();
    _loadingController.close();
  }

  Future<void> sendMessage(message) async {
    _loadingController.sink.add(true);
    try {
      final response = await http.post(
        Uri.parse('$siteUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _messages.addMessage(
          ConversationMessage(newMessage: data['response'], isUser: false),
        );
        Conversation list = Conversation(
          messageList: List.from(_messages.conversation),
          newTopic: _messages.topic,
        );
        _messagesController.sink.add(list);
      } else {
        if (kDebugMode) print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    } finally {
      _loadingController.sink.add(false);
    }
  }
}
