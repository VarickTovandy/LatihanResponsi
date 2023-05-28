import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterDetails extends StatefulWidget {
  final String characterName;

  const CharacterDetails({Key? key, required this.characterName}) : super(key: key);

  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  Map<String, dynamic>? characterData;
  String? nation;
  String? vision;

  @override
  void initState() {
    super.initState();
    fetchCharacterDetails();
  }

  Future<void> fetchCharacterDetails() async {
    final response = await http.get(Uri.parse("https://api.genshin.dev/characters/${widget.characterName}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        characterData = data;
        fetchNation();
        fetchVision();
        saveLastAccessedCharacter(widget.characterName, "https://api.genshin.dev/characters/${widget.characterName}/icon-big");
      });
    } else {
      throw Exception('Failed to fetch character details');
    }
  }

  void fetchNation() {
    if (characterData != null) {
      nation = characterData!['nation']?.toLowerCase();
    }
  }

  void fetchVision() {
    if (characterData != null) {
      vision = characterData!['vision']?.toLowerCase();
    }
  }

  Future<void> saveLastAccessedCharacter(String characterName, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastItemName', characterName);
    await prefs.setString('lastItemImageUrl', imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final iconUrl = "https://api.genshin.dev/characters/${widget.characterName}/gacha-splash";
    final nationUrl = nation != null ? "https://api.genshin.dev/nations/$nation/icon" : '';
    final visionUrl = vision != null ? "https://api.genshin.dev/elements/$vision/icon" : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.characterName),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(iconUrl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (nationUrl.isNotEmpty)
                  Image.network(
                    nationUrl,
                    width: 80,
                    height: 80,
                  ),
                if (visionUrl.isNotEmpty)
                  Image.network(
                    visionUrl,
                    width: 80,
                    height: 80,
                  ),
                if (characterData != null)
                  Text(
                    characterData!['name'],
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                SizedBox(width: 10),
              ],
            ),
            if (characterData != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < characterData!['rarity']; i++)
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                ],
              ),
            if (characterData != null)
              Text(
                characterData!['affiliation'],
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            SizedBox(height: 20),
            if (characterData != null)
              Text(
                characterData!['description'],
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            SizedBox(height: 20),
            ListTile(
              leading: Image.network("https://api.genshin.dev/characters/${widget.characterName}/talent-na"),
              title: Text(
                characterData!['skillTalents'][0]['unlock'].toString(),
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                characterData!['skillTalents'][0]['description'].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Image.network("https://api.genshin.dev/characters/${widget.characterName}/talent-passive-0"),
              title: Text(
                characterData!['skillTalents'][1]['unlock'].toString(),
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                characterData!['skillTalents'][1]['description'].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Image.network("https://api.genshin.dev/characters/${widget.characterName}/talent-passive-1"),
              title: Text(
                characterData!['skillTalents'][2]['unlock'].toString(),
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                characterData!['skillTalents'][2]['description'].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
