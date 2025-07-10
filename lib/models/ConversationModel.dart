import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

//Models for Conversation and individual ConversationMessages
class Conversation {
  late List<ConversationMessage> conversation;
  late String topic;

  //default constructor
  Conversation({
    required List<ConversationMessage> messageList,
    required String newTopic,
  }) {
    conversation = List<ConversationMessage>.empty(growable: true);
    conversation.addAll(messageList);
    topic = newTopic;
  }

  //private constructor for use when making a conversation fetched from API
  Conversation._create() {
    conversation = List<ConversationMessage>.empty(growable: true);
    topic = "";
  }

  //exposed method to use to make a conversation using dat fetched from API
  static Future<Conversation> getConversation({
    required String userId,
    required String conversationId,
  }) async {
    var conversation = Conversation._create();

    //do API fetch to get conversation from db

    //TEMP random gen
    conversation.conversation.addAll(
      List.generate(
        10,
        (i) => ConversationMessage(
          newMessage: "message $i",
          isUser: (i % 2 == 0 ? true : false),
        ),
      ),
    );

    return conversation;
  }

  //setter method for adding message to a conversation.
  void addMessage(ConversationMessage message) {
    conversation.add(message);
  }
}

//class for individual conversation message
class ConversationMessage {
  String message = "";

  //denotes if message is from user or sent to user
  //used when differentiating between message types in ui
  bool userMessage = true;

  ConversationMessage({required String newMessage, required bool isUser}) {
    message += newMessage;
    userMessage = isUser;
  }
}
