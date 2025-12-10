import 'package:flutter/material.dart';
import '../data/books_data.dart';

class AuthorBooksPage extends StatelessWidget {
  final String authorName;

  const AuthorBooksPage({super.key, required this.authorName});

  @override
  Widget build(BuildContext context) {
    List<Book> filteredBooks = books.where((book) => book.author == authorName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(authorName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(filteredBooks[index].image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}