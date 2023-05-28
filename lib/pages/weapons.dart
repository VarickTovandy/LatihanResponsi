import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:genshinapp/pages/weapondetails.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({Key? key}) : super(key: key);

  @override
  _WeaponsPageState createState() => _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> {
  List<dynamic> weaponList = [];

  @override
  void initState() {
    super.initState();
    fetchWeaponData();
  }

  Future<void> fetchWeaponData() async {
    final response = await http.get(Uri.parse("https://api.genshin.dev/weapons"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weaponList = data;
      });
    }
  }

  void openWeaponDetailsPage(BuildContext context, String weaponName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeaponDetails(weaponName: weaponName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapons Page'),
      ),
      body: ListView.builder(
        itemCount: weaponList.length,
        itemBuilder: (context, index) {
          final weapon = weaponList[index];
          return ListTile(
            leading: Image.network("https://api.genshin.dev/weapons/$weapon/icon"),
            title: Text(weapon),
            onTap: () {
              openWeaponDetailsPage(context, weapon);
            },
          );
        },
      ),
    );
  }
}
