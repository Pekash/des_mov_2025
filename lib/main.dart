import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(title: const Text('Mi App')),
          body: const TabBarView(
            children: [SettingsPage(), ProfilePage()],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(width: 120, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/13be95147b920e7c4ee958ff30db7a11.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
              Container(width: 120, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/free-video-2235844.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
              Container(width: 120, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/istockphoto-1235367885-612x612.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
              Container(width: 120, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/pexels-oleksandr-kobuta-152146753-33746598.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(height: 200, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/sunlight-eyes-7680x4320-v0-ks41i.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
              Container(height: 200, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Screenshot_1.png'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
              Container(height: 200, margin: EdgeInsets.all(4), decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/GdkVrIbXEAAz86i.jpg'), fit: BoxFit.cover), borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/images/kenny.jpg')),
          SizedBox(height: 20),
          Text('Kenny', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}