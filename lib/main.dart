import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/authors_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF8B4513),
        scaffoldBackgroundColor: Color(0xFFFFF8DC),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF8B4513),
          secondary: Color(0xFFDEB887),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF8B4513),
        scaffoldBackgroundColor: Color(0xFF2C1810),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF8B4513),
          secondary: Color(0xFF3E2723),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LibraryHome(
        isDarkMode: isDarkMode,
        onThemeChanged: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class LibraryHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const LibraryHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LibraryHome> createState() => _LibraryHomeState();
}

class _LibraryHomeState extends State<LibraryHome> {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  final List<Widget> pages = [HomePage(), AuthorsPage()];

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onNavigationTap(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Librería'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Librería',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                onNavigationTap(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Autores'),
              onTap: () {
                onNavigationTap(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Libros'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Autores'),
        ],
      ),
    );
  }
}
