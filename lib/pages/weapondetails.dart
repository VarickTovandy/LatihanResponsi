import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WeaponDetails extends StatefulWidget {
  final String weaponName;

  const WeaponDetails({Key? key, required this.weaponName}) : super(key: key);

  @override
  _WeaponDetailsState createState() => _WeaponDetailsState();
}

class _WeaponDetailsState extends State<WeaponDetails> {
  Map<String, dynamic>? weaponData;

  @override
  void initState() {
    super.initState();
    fetchWeaponDetails();
  }

  Future<void> fetchWeaponDetails() async {
    final response = await http.get(Uri.parse("https://api.genshin.dev/weapons/${widget.weaponName}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weaponData = data;
        saveLastAccessedWeapon(widget.weaponName, "https://api.genshin.dev/weapons/${widget.weaponName}/icon");
      });
    } else {
      throw Exception('Failed to fetch weapon details');
    }
  }

  Future<void> saveLastAccessedWeapon(String weaponName, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastItemName', weaponName);
    await prefs.setString('lastItemImageUrl', imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final iconUrl = "https://api.genshin.dev/weapons/${widget.weaponName}/icon";
    final imageUrls = weaponData?['images'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weaponName),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(iconUrl),
              SizedBox(height: 20),
              if (weaponData != null)
                Text(
                  weaponData!['name'],
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              if (weaponData != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    weaponData!['rarity'],
                        (index) => Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
