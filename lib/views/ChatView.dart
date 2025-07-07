import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../viewModels/ChatViewModel.dart';
import '../models/ConversationModel.dart';

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

const String INITIAL_TEXT = 'Initial Text';
const Widget sendButtonIcon = Icon(CupertinoIcons.arrow_up_circle_fill);
const Widget loadingAnim = CupertinoActivityIndicator(color: Colors.blueAccent);

// View for chat interface with message list and message input.
// TODO -- include interfacing for userID and conversationID to initialize with desired conversation
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  //ViewModel to handle conversation information and conversation logic
  final ChatViewModel _viewModel = ChatViewModel();
  List<ConversationMessage> initialMessageList =
      List<ConversationMessage>.empty(growable: true);
  final TextEditingController _inputController = TextEditingController(
    text: INITIAL_TEXT,
  );
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //fetch conversation based on desired conversation info
    _viewModel.loadConversation(
      userId: "userId",
      conversationId: "conversationId",
    );
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<Conversation>(
              stream: _viewModel.messagesStream,
              initialData: Conversation(messageList: [], newTopic: ""),
              builder: (context, snapshot) {
                final messages = snapshot.data!.conversation;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                    );
                  }
                });

                return CupertinoScrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      if (messages[index].userMessage) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 80,
                              right: 20,
                              top: 5,
                              bottom: 5,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${messages[index].message}: $index",
                              style: textStyle,
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 20,
                              right: 80,
                              top: 5,
                              bottom: 5,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${messages[index].message}: $index",
                              style: textStyle,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _viewModel.loadingStream,
            initialData: false,
            builder: (context, snapshot) {
              final isLoading = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CupertinoTextField(
                    controller: _inputController,
                    style: textStyle,
                    suffixMode: OverlayVisibilityMode.always,
                    maxLines: 4,
                    minLines: 1,
                    suffix: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                _viewModel.sendMessage(_inputController.text);
                                _inputController.text = INITIAL_TEXT;
                              },
                      child:
                          isLoading
                              ? const CupertinoActivityIndicator(
                                color: Colors.blueAccent,
                              )
                              : const Icon(CupertinoIcons.arrow_up_circle_fill),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
