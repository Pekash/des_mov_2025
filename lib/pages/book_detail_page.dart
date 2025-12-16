import 'package:flutter/material.dart';
import '../data/api_service.dart';
import 'characters_page.dart';
import 'houses_page.dart';
import 'epub_reader_page.dart';

class BookDetailPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final String bookImage;

  const BookDetailPage({super.key, required this.bookId, required this.bookTitle, required this.bookImage});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final apiService = ApiService();
  Map<String, dynamic>? bookData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadBookData();
  }

  void loadBookData() async {
    try {
      final data = await apiService.getBook(widget.bookId);
      if (mounted) setState(() { bookData = data; isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { isLoading = false; hasError = true; });
    }
  }

  String formatDate(String date) {
    if (date.isEmpty) return 'Unknown';
    try {
      final dt = DateTime.parse(date);
      final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookTitle)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(height: 300, width: 200, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: AssetImage(widget.bookImage), fit: BoxFit.cover), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]))),
            SizedBox(height: 20),
            Center(child: Text(widget.bookTitle, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            SizedBox(height: 30),
            if (widget.bookId == 1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EpubReaderPage(bookTitle: widget.bookTitle, epubPath: 'assets/books/agameofthrones.epub'))),
                  icon: Icon(Icons.menu_book),
                  label: Text('Leer'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16), backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                ),
              ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 10),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (hasError || bookData == null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [Icon(Icons.wifi_off, color: Colors.grey), SizedBox(width: 10), Expanded(child: Text('No hay conexión. Información detallada no disponible.'))]),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Author: ${bookData!['authors'].join(', ')}', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pages: ${bookData!['numberOfPages']} pages', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Released: ${formatDate(bookData!['released'])}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Publisher: ${bookData!['publisher']}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CharactersPage(povUrls: List<String>.from(bookData!['povCharacters']), bookTitle: widget.bookTitle))), icon: Icon(Icons.person), label: Text('Ver Personajes'))),
                      SizedBox(width: 10),
                      Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HousesPage(povUrls: List<String>.from(bookData!['povCharacters']), bookTitle: widget.bookTitle))), icon: Icon(Icons.shield), label: Text('Ver Casas'))),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}