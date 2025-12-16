import 'package:flutter/material.dart';
import '../data/api_service.dart';
import 'character_detail_page.dart';

class CharactersPage extends StatefulWidget {
  final List<String> povUrls;
  final String bookTitle;

  const CharactersPage({
    super.key,
    required this.povUrls,
    required this.bookTitle,
  });

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  ApiService apiService = ApiService();
  List<dynamic> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  void loadCharacters() async {
    try {
      var data = await apiService.getPOVCharacters(widget.povUrls);
      setState(() {
        characters = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getCharacterImage(String name) {
    String cleanName = name.replaceAll(' (Prologue)', '').replaceAll(' (Epilogue)', '');
    
    Map<String, String> characterImages = {
      'Eddard Stark': 'assets/characters/Eddard_Stark.jpg',
      'Catelyn Stark': 'assets/characters/Catelyn_Stark.jpg',
      'Jon Snow': 'assets/characters/Jon_Snow.jpg',
      'Arya Stark': 'assets/characters/Arya_Stark.jpg',
      'Brandon Stark': 'assets/characters/Bran_Stark.jpg',
      'Sansa Stark': 'assets/characters/Sansa_Stark.jpg',
      'Tyrion Lannister': 'assets/characters/Tyrion_Lannister.jpg',
      'Daenerys Targaryen': 'assets/characters/Daenerys_Targaryen.jpg',
      'Theon Greyjoy': 'assets/characters/Theon_Greyjoy.jpg',
      'Davos Seaworth': 'assets/characters/Davos_Seaworth.jpg',
      'Jaime Lannister': 'assets/characters/Jaime_Lannister.jpg',
      'Samwell Tarly': 'assets/characters/Samwell_Tarly.jpg',
      'Cersei Lannister': 'assets/characters/Cersei_Lannister.jpg',
      'Brienne of Tarth': 'assets/characters/Brienne_Tarth.jpg',
      'Areo Hotah': 'assets/characters/Areo_Hotah.jpg',
      'Arianne Martell': 'assets/characters/Arianne_Martell.jpg',
      'Asha Greyjoy': 'assets/characters/Asha_Greyjoy.jpg',
      'Victarion Greyjoy': 'assets/characters/Victarion_Greyjoy.jpg',
      'Aeron Greyjoy': 'assets/characters/Aeron_Greyjoy.jpg',
      'Quentyn Martell': 'assets/characters/Quentyn_Martell.jpg',
      'Jon Connington': 'assets/characters/Jon_Connington.jpg',
      'Barristan Selmy': 'assets/characters/Barristan_Selmy.jpg',
      'Melisandre': 'assets/characters/Melisandre.jpg',
      'Merrett Frey': 'assets/characters/Merrett_Frey.jpg',
      'Varamyr': 'assets/characters/Varamyr.jpg',
      'Kevan Lannister': 'assets/characters/Kevan_Lannister.jpg',
      'Arys Oakheart': 'assets/characters/Arys_Oakheart.jpg',
      'Chett': 'assets/characters/Chett.jpg',
      'Will': 'assets/characters/Will_(Prologue).jpg',
      'Cressen': 'assets/characters/Cressen_(Prologue).jpg',
      'Pate': 'assets/characters/Pate_(Prologue).jpg',
    };
    return characterImages[cleanName] ?? characterImages[name] ?? 'assets/characters/${cleanName.replaceAll(' ', '_')}.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POV Characters - ${widget.bookTitle}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : characters.isEmpty
              ? Center(child: Text('No POV characters found'))
              : GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    var character = characters[index];
                    String name = character['name'].isEmpty ? 'Unknown' : character['name'];
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailPage(
                              character: character,
                              imagePath: getCharacterImage(name),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(getCharacterImage(name)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}