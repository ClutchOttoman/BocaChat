import 'package:flutter/cupertino.dart';

//Models for Conversation and individual ConversationMessages
class Conversation {
  //late List<ConversationMessage> conversation;
  late List<ConversationInteraction> conversation;
  late String topic;

  //default constructor
  Conversation({
    required List<ConversationInteraction> interactionList,
    required String newTopic,
  }) {
    conversation = List<ConversationInteraction>.empty(
      growable: true,
    ); //List<ConversationMessage>.empty(growable: true);
    conversation.addAll(interactionList);
    topic = newTopic;
  }

  //private constructor for use when making a conversation fetched from API
  Conversation._create() {
    conversation = List<ConversationInteraction>.empty(growable: true);
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
        (i) => ConversationInteraction(
          id: "id-$i",
          newPrompt: "message $i",
          newResponse: "response $i",
        ),
      ),
    );

    return conversation;
  }

  //setter method for adding message to a conversation.
  void addPrompt(ConversationInteraction interaction) {
    conversation.add(interaction);
  }

  void addResponseToLast(String response) {
    conversation.last.response = response;
  }
}

//class for individual conversation message
/*class ConversationMessage {
  String message = "";

  //denotes if message is from user or sent to user
  //used when differentiating between message types in ui
  bool userMessage = true;

  ConversationMessage({required String newMessage, required bool isUser}) {
    message += newMessage;
    userMessage = isUser;
  }
}*/

class ConversationInteraction {
  String prompt = "";
  String response = "";
  String id = "";

  ConversationInteraction({
    required String id,
    required String newPrompt,
    required String newResponse,
  }) {
    prompt += newPrompt;
    response += newResponse;
  }
}
