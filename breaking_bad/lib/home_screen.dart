import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'character_tile.dart';
import 'quotes_screen.dart';
import 'dart:convert';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<List<Character>> fetchBbCharacters() async {
    final response =
        await http.get(Uri.parse('https://breakingbadapi.com/api/characters'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((character) => Character.fromJson(character)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breaking Bad Quotes'),
      ),
      body: FutureBuilder<List<Character>>(
       future: fetchBbCharacters(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CharacterTile(
                  character: snapshot.data?[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Error!'),
              ),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
