import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/authors_page.dart';
import 'pages/splash_screen.dart';

void main() => runApp(const MyApp());

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
        colorScheme: ColorScheme.light(primary: Color(0xFF8B4513), secondary: Color(0xFFDEB887)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF8B4513),
        scaffoldBackgroundColor: Color(0xFF2C1810),
        colorScheme: ColorScheme.dark(primary: Color(0xFF8B4513), secondary: Color(0xFF3E2723)),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDarkMode: isDarkMode, onThemeChanged: () => setState(() => isDarkMode = !isDarkMode)),
    );
  }
}

class LibraryHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const LibraryHome({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<LibraryHome> createState() => _LibraryHomeState();
}

class _LibraryHomeState extends State<LibraryHome> {
  int currentIndex = 0;
  PageController pageController = PageController();
  final pages = [HomePage(), AuthorsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KindleKash'),
        actions: [IconButton(icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode), onPressed: widget.onThemeChanged)],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/bookstore_drawer.jpg'), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/book.gif', height: 60),
                  SizedBox(height: 10),
                  Text('KindleKash', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Inicio'), onTap: () { pageController.jumpToPage(0); Navigator.pop(context); }),
            ListTile(leading: Icon(Icons.person), title: Text('Autores'), onTap: () { pageController.jumpToPage(1); Navigator.pop(context); }),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (i) => setState(() => currentIndex = i),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => pageController.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.ease),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Libros'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Autores'),
        ],
      ),
    );
  }
}