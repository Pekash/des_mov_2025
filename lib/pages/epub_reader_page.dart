import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';

class EpubReaderPage extends StatefulWidget {
  final String bookTitle;
  final String epubPath;

  const EpubReaderPage({super.key, required this.bookTitle, required this.epubPath});

  @override
  State<EpubReaderPage> createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late EpubController _controller;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _controller = EpubController(document: EpubDocument.openAsset(widget.epubPath));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: EpubViewActualChapter(controller: _controller, builder: (ch) => Text(ch?.chapter?.Title?.trim() ?? widget.bookTitle, overflow: TextOverflow.ellipsis)),
          actions: [IconButton(icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode), onPressed: () => setState(() => isDarkMode = !isDarkMode))],
        ),
        drawer: Drawer(child: EpubViewTableOfContents(controller: _controller)),
        body: EpubView(controller: _controller),
      ),
    );
  }
}