class Conversation {
  List<ConversationMessage> conversation = [];
  String topic = "No Topic";

  Conversation({
    required List<ConversationMessage> messageList,
    required String newTopic,
  }) {
    conversation.addAll(messageList);
    topic = newTopic;
  }

  void addMessage(ConversationMessage message) {
    conversation.add(message);
  }
}

class ConversationMessage {
  String message = "";
  bool userMessage = true;

  ConversationMessage({required String newMessage, required bool isUser}) {
    message += newMessage;
    userMessage = isUser;
  }
}
