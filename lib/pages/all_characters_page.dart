import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'character_detail_page.dart';

class AllCharactersPage extends StatefulWidget {
  const AllCharactersPage({super.key});

  @override
  State<AllCharactersPage> createState() => _AllCharactersPageState();
}

class _AllCharactersPageState extends State<AllCharactersPage> {
  List<dynamic> currentBatch = [];
  List<dynamic> searchResults = [];
  bool isLoading = false;
  bool isSearchLoading = false;
  int currentAPIPage = 1;
  bool hasMorePages = true;
  final int charactersPerAPIPage = 50;
  
  // Controlador para el campo de búsqueda
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isSearchMode = false;

  final charImages = {
    'Eddard Stark': 'Eddard_Stark', 'Catelyn Stark': 'Catelyn_Stark', 'Jon Snow': 'Jon_Snow',
    'Arya Stark': 'Arya_Stark', 'Brandon Stark': 'Bran_Stark', 'Sansa Stark': 'Sansa_Stark',
    'Tyrion Lannister': 'Tyrion_Lannister', 'Daenerys Targaryen': 'Daenerys_Targaryen',
    'Theon Greyjoy': 'Theon_Greyjoy', 'Davos Seaworth': 'Davos_Seaworth', 'Jaime Lannister': 'Jaime_Lannister',
    'Samwell Tarly': 'Samwell_Tarly', 'Cersei Lannister': 'Cersei_Lannister', 'Brienne of Tarth': 'Brienne_Tarth',
  };

  @override
  void initState() {
    super.initState();
    loadCharacters();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    setState(() {
      searchQuery = query;
    });
    
    if (query.isEmpty) {
      setState(() {
        isSearchMode = false;
      });
    } else {
      // Validación RegExp: solo letras, espacios y apóstrofes
      final validCharactersRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s']+$");
      
      if (validCharactersRegex.hasMatch(query) && query.trim().length >= 2) {
        _searchCharactersInAPI(query);
      }
    }
  }

  Future<void> _searchCharactersInAPI(String query) async {
    if (isSearchLoading) return;
    
    setState(() {
      isSearchLoading = true;
      isSearchMode = true;
    });

    try {
      List<dynamic> allResults = [];
      int page = 1;
      bool hasMore = true;
      
      // Buscar en todas las páginas de la API (máximo 10 páginas para evitar sobrecargas)
      while (hasMore && page <= 10) {
        final response = await http.get(
          Uri.parse('https://anapioficeandfire.com/api/characters?page=$page&pageSize=$charactersPerAPIPage')
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> chars = json.decode(response.body);
          final namedChars = chars.where((c) => c['name'].isNotEmpty).toList();
          
          // Filtrar los que coincidan con la búsqueda
          final searchPattern = RegExp(query.trim(), caseSensitive: false);
          final queryLower = query.toLowerCase();
          
          final matches = namedChars.where((char) {
            final name = char['name'].toString().toLowerCase();
            final culture = char['culture'].toString().toLowerCase();
            
            return searchPattern.hasMatch(name) || 
                   searchPattern.hasMatch(culture) ||
                   name.contains(queryLower) ||
                   culture.contains(queryLower);
          }).toList();
          
          allResults.addAll(matches);
          
          // Si la página devuelve menos caracteres, no hay más páginas
          hasMore = chars.length == charactersPerAPIPage;
          page++;
        } else {
          break;
        }
      }
      
      setState(() {
        searchResults = allResults;
        isSearchLoading = false;
      });
      
    } catch (e) {
      setState(() {
        isSearchLoading = false;
        searchResults = [];
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar personajes')),
        );
      }
    }
  }

  Future<void> loadCharacters() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://anapioficeandfire.com/api/characters?page=$currentAPIPage&pageSize=$charactersPerAPIPage')
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> chars = json.decode(response.body);
        final namedChars = chars.where((c) => c['name'].isNotEmpty).toList();
        setState(() {
          currentBatch = namedChars;
          hasMorePages = chars.length == charactersPerAPIPage;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  List<dynamic> getCurrentPageCharacters() {
    return isSearchMode ? searchResults : currentBatch;
  }

  void nextPage() {
    if (isSearchMode) return; // No hay paginación en modo búsqueda
    
    if (hasMorePages && !isLoading) {
      setState(() {
        currentAPIPage++;
      });
      loadCharacters();
    }
  }

  void previousPage() async {
    if (isSearchMode) return; // No hay paginación en modo búsqueda
    
    if (currentAPIPage > 1 && !isLoading) {
      setState(() {
        currentAPIPage--;
      });
      await loadCharacters();
    }
  }

  bool get canGoBack => !isSearchMode && currentAPIPage > 1 && !isLoading;
  bool get canGoForward => !isSearchMode && hasMorePages && !isLoading;

  String getCharacterImage(String name) {
    return 'assets/characters/${charImages[name] ?? 'placeholder'}.jpg';
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      searchQuery = '';
      isSearchMode = false;
      searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && currentBatch.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('All Characters')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentChars = getCurrentPageCharacters();
    final validCharactersRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s']+$");
    final hasInvalidCharacters = searchQuery.isNotEmpty && 
                                  !validCharactersRegex.hasMatch(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Characters'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar personajes en toda la API...',
                prefixIcon: isSearchLoading 
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                errorText: hasInvalidCharacters 
                    ? 'Solo se permiten letras y espacios'
                    : (searchQuery.isNotEmpty && searchQuery.trim().length < 2)
                        ? 'Mínimo 2 caracteres'
                        : null,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Información de resultados de búsqueda
          if (isSearchMode && !isSearchLoading)
            Container(
              padding: EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Encontrados: ${searchResults.length} personajes',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isSearchLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Buscando en todas las páginas...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : currentChars.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  isSearchMode 
                                      ? 'No se encontraron personajes'
                                      : 'No hay personajes disponibles',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                if (isSearchMode)
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: ElevatedButton.icon(
                                      onPressed: _clearSearch,
                                      icon: Icon(Icons.clear),
                                      label: Text('Limpiar búsqueda'),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: currentChars.length,
                            itemBuilder: (context, i) {
                              final char = currentChars[i];
                              final name = char['name'];

                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CharacterDetailPage(
                                      character: char,
                                      imagePath: getCharacterImage(name),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: charImages.containsKey(name)
                                            ? AssetImage(getCharacterImage(name))
                                            : null,
                                        child: charImages.containsKey(name)
                                            ? null
                                            : Icon(Icons.person, size: 30),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (char['culture'].isNotEmpty)
                                              Text(
                                                char['culture'],
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 16),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          if (!isSearchMode)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: canGoBack ? previousPage : null,
                  ),
                  Text(
                    'Página de API: $currentAPIPage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: canGoForward ? nextPage : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}