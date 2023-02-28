import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  Future<List<String>> fetchQuote(String name) async {
    final names = name.split(' ');
    final authorName = names.join('+');
    final response = await http.get(
        Uri.parse('https://breakingbadapi.com/api/quote?author=$authorName'));
    if (response.statusCode == 200) {
      final quoteData = jsonDecode(response.body);
      List<String> quotes = [];
      for (var quote in quoteData) {
        quotes.add(quote['quote']);
      }
      if (quotes.isNotEmpty) {
        return quotes;
      } else {
        quotes.add('There were no quotes found for $name');
        return quotes;
      }
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name Quote'),
      ),
      body: FutureBuilder(
          future: fetchQuote(name),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 25),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        snapshot.data?[index],
                        style: const TextStyle(
                          fontSize: 36,
                          backgroundColor: Color(0xFFFAFAFA),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          }),
    );
  }
}
