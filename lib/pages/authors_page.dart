import 'package:flutter/material.dart';
import '../data/books_data.dart';
import 'author_books_page.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: authorNames.length,
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorBooksPage(authorName: authorNames[i]))),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: AssetImage(authorImages[i])),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorNames[i], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${books.where((b) => b.author == authorNames[i]).length} libros', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}