/*import 'package:flutter/cupertino.dart';
import 'ChatView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('BocaChat')),
        child: textColumn(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

import 'package:boca_raton_gpt/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final String url = "http://10.0.2.2:4001";
final HttpLink httpLink = HttpLink(url);
final ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore())),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const CupertinoApp(
        home: MainTabs(),
        debugShowCheckedModeBanner: false,
        title: 'Boca Chat',
      ),
    );
  }
}

class MainTabs extends StatelessWidget {
  const MainTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
