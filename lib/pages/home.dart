import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genshinapp/pages/characters.dart';
import 'package:genshinapp/pages/weapons.dart';

class MyHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  String? lastItemName;
  String? lastItemImageUrl;

  @override
  void initState() {
    super.initState();
    getLastAccessedItem();
  }

  Future<void> getLastAccessedItem() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastItemName = prefs.getString('lastItemName');
      lastItemImageUrl = prefs.getString('lastItemImageUrl');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Add the following lines
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getLastAccessedItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://4.bp.blogspot.com/-iz7Z_jLPL6E/XQ8eHVZTlnI/AAAAAAAAHtA/rDn9sYH174ovD4rbxsC8RSBeanFvfy75QCKgBGAs/w1440-h2560-c/genshin-impact-characters-uhdpaper.com-4K-2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lastItemImageUrl != null && lastItemName != null)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Image.network(
                        lastItemImageUrl!,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Last Item: $lastItemName',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              if (lastItemImageUrl == null && lastItemName == null)
                Text(
                  'No item accessed yet',
                  style: TextStyle(fontSize: 24),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CharacterPage()),
                  );
                },
                child: Text('Karakter'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeaponsPage()),
                  );
                },
                child: Text('Weapons'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
