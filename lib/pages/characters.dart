import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genshinapp/pages/charactersdetail.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  List<dynamic> characterList = [];

  @override
  void initState() {
    super.initState();
    fetchCharacterData();
  }

  Future<void> fetchCharacterData() async {
    final response = await http.get(Uri.parse("https://api.genshin.dev/characters"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        characterList = data;
      });
    }
  }

  void openCharacterDetailsPage(BuildContext context, String characterName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CharacterDetails(characterName: characterName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Page'),
      ),
      body: ListView.builder(
        itemCount: characterList.length,
        itemBuilder: (context, index) {
          final character = characterList[index];
          return ListTile(
            leading: Image.network("https://api.genshin.dev/characters/$character/icon-big"),
            title: Text(character),
            onTap: () {
              openCharacterDetailsPage(context, character);
            },
          );
        },
      ),
    );
  }
}
