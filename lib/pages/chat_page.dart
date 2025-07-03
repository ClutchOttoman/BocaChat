import 'package:flutter/cupertino.dart';
import '../views/TextColumn.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Chat')),
      child: TextColumn(),
    );
  }
}
