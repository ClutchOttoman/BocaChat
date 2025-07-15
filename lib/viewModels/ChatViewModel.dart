import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ConversationModel.dart';

const String INITIAL_TEXT = 'Initial Text';

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

//View model for chat conversations
//exposes a sink for view elements to add messages to a conversation and streams see if data is loading or present and to read the current state of the conversation
class ChatViewModel {
  final _conversationController = StreamController<Conversation>.broadcast();
  final _loadingController = StreamController<bool>.broadcast();

  late Conversation _conversation;

  ChatViewModel() {
    _conversation = Conversation(interactionList: [], newTopic: "");
  }

  Stream<Conversation> get conversationStream => _conversationController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  static Future<ChatViewModel> createChatViewModel() async {
    var modelView = ChatViewModel();
    modelView._conversation = await Conversation.getConversation(
      userId: "userId",
      conversationId: "conversationId",
    );
    return modelView;
  }

  void dispose() {
    _conversationController.close();
    _loadingController.close();
  }

  //send a message to server for chatbot response
  //puts response in stream for view to read from
  Future<void> sendPrompt(prompt) async {
    _loadingController.sink.add(true);
    _conversation.addPrompt(
      ConversationInteraction(
        newPrompt: prompt,
        newResponse: "",
        id: "id-$prompt",
      ),
    );
    _conversationController.sink.add(_conversation);
    try {
      final response = await http.post(
        Uri.parse('$siteUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _conversation.addResponseToLast(data['response']);
        Conversation list = Conversation(
          interactionList: List.from(_conversation.conversation),
          newTopic: _conversation.topic,
        );
        _conversationController.sink.add(list);
      } else {
        if (kDebugMode) print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    } finally {
      _loadingController.sink.add(false);
    }
  }

  //loads a conversation based on user information and desired conversation
  //puts conversation in stream for view to read from
  void loadConversation({
    required String userId,
    required String conversationId,
  }) async {
    try {
      Conversation fetchedConversation = await Conversation.getConversation(
        userId: "userId",
        conversationId: "conversationId",
      );
      _conversationController.sink.add(fetchedConversation);
      _conversation = fetchedConversation;
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    }
  }
}
