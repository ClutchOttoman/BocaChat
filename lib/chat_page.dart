import 'package:flutter/cupertino.dart';
import 'textColumn.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Chat'),
      ),
      child: textColumn(),
    );
  }
}
