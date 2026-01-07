import 'package:flutter/material.dart';
import '../data/books_data.dart';
import 'book_detail_page.dart';
import 'all_characters_page.dart';

class AuthorBooksPage extends StatelessWidget {
  final String authorName;

  const AuthorBooksPage({super.key, required this.authorName});

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((b) => b.author == authorName).toList();

    return Scaffold(
      appBar: AppBar(title: Text(authorName)),
      body: Column(
        children: [
          if (authorName == 'George R.R. Martin') 
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllCharactersPage())),
                  icon: Icon(Icons.groups),
                  label: Text('Ver Todos los Personajes'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.6, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: filteredBooks.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: filteredBooks[i].apiId != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailPage(bookId: filteredBooks[i].apiId!, bookTitle: filteredBooks[i].title, bookImage: filteredBooks[i].image))) : null,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(image: AssetImage(filteredBooks[i].image), fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}