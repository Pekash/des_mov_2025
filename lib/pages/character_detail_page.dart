import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final Map<String, dynamic> character;
  final String imagePath;

  const CharacterDetailPage({super.key, required this.character, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final name = character['name'].isEmpty ? 'Unknown' : character['name'];
    final culture = character['culture'].isEmpty ? 'Unknown' : character['culture'];
    final born = character['born'].isEmpty ? 'Unknown' : character['born'];
    final died = character['died'].isEmpty ? 'Alive' : character['died'];
    List<dynamic> titles = character['titles'] ?? [];
    List<dynamic> aliases = character['aliases'] ?? [];

    titles = titles.where((title) => title.isNotEmpty).toList();
    aliases = aliases.where((alias) => alias.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(title: Text(name, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Icon(Icons.public, color: Colors.amber, size: 20), SizedBox(width: 8), Expanded(child: Text('Culture: $culture', style: TextStyle(fontSize: 16)))]),
                        SizedBox(height: 12),
                        Row(children: [Icon(Icons.cake, color: Colors.amber, size: 20), SizedBox(width: 8), Expanded(child: Text('Born: $born', style: TextStyle(fontSize: 16)))]),
                        SizedBox(height: 12),
                        Row(children: [Icon(died == 'Alive' ? Icons.favorite : Icons.close, color: died == 'Alive' ? Colors.green : Colors.red, size: 20), SizedBox(width: 8), Expanded(child: Text('Status: $died', style: TextStyle(fontSize: 16)))]),
                      ],
                    ),
                  ),
                  if (aliases.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text('Aliases', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: aliases.map((alias) => Padding(padding: EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('• ', style: TextStyle(fontSize: 18, color: Colors.amber)), Expanded(child: Text(alias, style: TextStyle(fontSize: 16)))]))).toList()),
                    ),
                  ],
                  if (titles.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text('Titles', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: titles.map((title) => Padding(padding: EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.military_tech, color: Colors.amber, size: 18), SizedBox(width: 8), Expanded(child: Text(title, style: TextStyle(fontSize: 16)))]))).toList()),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}