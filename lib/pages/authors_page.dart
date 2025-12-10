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
      itemBuilder: (context, index) {
        String currentAuthor = authorNames[index];
        String currentImage = authorImages[index];
        
        int bookCount = books.where((book) => book.author == currentAuthor).length;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthorBooksPage(authorName: currentAuthor),
              ),
            );
          },
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
                  backgroundImage: AssetImage(currentImage),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentAuthor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('$bookCount libros', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}