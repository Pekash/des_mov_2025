import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HousesPage extends StatefulWidget {
  final List<String> povUrls;
  final String bookTitle;

  const HousesPage({super.key, required this.povUrls, required this.bookTitle});

  @override
  State<HousesPage> createState() => _HousesPageState();
}

class _HousesPageState extends State<HousesPage> {
  bool isLoading = true;
  List<dynamic> houses = [];

  final houseIDs = ['362', '229', '17', '378', '169', '395', '7', '285', '198', '141', '34', '398'];
  final houseNames = ['stark', 'lannister', 'baratheon', 'targaryen', 'greyjoy', 'tully', 'arryn', 'martell', 'hightower', 'frey', 'bolton', 'tyrell'];

  @override
  void initState() {
    super.initState();
    loadHouses();
  }

  void loadHouses() async {
    try {
      final results = await Future.wait(houseIDs.map((id) async {
        final res = await http.get(Uri.parse('https://anapioficeandfire.com/api/houses/$id'));
        return res.statusCode == 200 ? json.decode(res.body) : null;
      }));

      setState(() {
        houses = results.where((h) => h != null && houseNames.any((n) => h['name'].toString().toLowerCase().contains(n))).toList();
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  String getHouseImage(String name) {
    final n = name.toLowerCase();
    final houseMap = {
      'stark': 'House_Stark', 'lannister': 'House_Lannister', 'targaryen': 'House_Targaryen',
      'baratheon': 'House_Baratheon', 'greyjoy': 'House_Greyjoy', 'tyrell': 'House_Tyrell',
      'martell': 'House_Martell', 'arryn': 'House_Arryn', 'frey': 'House_Frey',
      'bolton': 'House_Bolton', 'tully': 'House_Tully', 'hightower': 'House_Hightower'
    };
    return 'assets/houses/${houseMap.entries.firstWhere((e) => n.contains(e.key), orElse: () => MapEntry('', 'House_Stark')).value}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Houses of Westeros')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: houses.length,
              itemBuilder: (context, i) {
                final h = houses[i];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(getHouseImage(h['name']), height: 40, width: 40),
                          SizedBox(width: 12),
                          Expanded(child: Text(h['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Words: "${h['words'] ?? 'No words'}"', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('Region: ${h['region'] ?? 'Unknown'}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}