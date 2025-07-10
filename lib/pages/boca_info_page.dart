import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

Future<void> sendRequest() async {
  final url = Uri.parse(
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1/tips',
  );

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('Response from server: ${data['tip']}');
      }
    } else {
      if (kDebugMode) {
        print('Server error: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}

class BocaInfoPage extends StatelessWidget {
  final String readProducts = """
      query Products{
        products{
          id
          name
          description
        }
      }
    """;

  const BocaInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Boca Info')),
        child: Center(
          child: Query(
            options: QueryOptions(
              document: gql(
                readProducts,
              ), // this is the query string you just created
            ),
            builder: (
              QueryResult result, {
              VoidCallback? refetch,
              FetchMore? fetchMore,
            }) {
              if (result.hasException) {
                if (kDebugMode) {
                  print(result.exception.toString());
                }
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Text('Loading');
              }

              List? products = result.data?['products'];

              if (products == null) {
                return const Text('No products');
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Text(product['name'] ?? '');
                },
              );
            },
          ),
        ),
      ),
    ));
  }
}
