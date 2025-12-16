import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const SplashScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LibraryHome(isDarkMode: isDarkMode, onThemeChanged: onThemeChanged)));
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bookstore_splash.jpg', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/book.gif', height: 150),
                SizedBox(height: 20),
                Text('KindleKash', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}