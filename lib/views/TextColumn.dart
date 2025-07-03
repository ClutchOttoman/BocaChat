import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../viewModels/ChatViewModel.dart';
import '../models/ConversationModel.dart';

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

const String INITIAL_TEXT = 'Initial Text';
const Widget sendButtonIcon = Icon(CupertinoIcons.arrow_up_circle_fill);
const Widget loadingAnim = CupertinoActivityIndicator(color: Colors.blueAccent);

class TextColumn extends StatefulWidget {
  const TextColumn({super.key});

  @override
  State<TextColumn> createState() => _TextColumnState();
}

class _TextColumnState extends State<TextColumn> {
  final ChatViewModel _viewModel = ChatViewModel();
  final TextEditingController _inputController = TextEditingController(
    text: INITIAL_TEXT,
  );
  final ScrollController _scrollController = ScrollController();

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
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
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
