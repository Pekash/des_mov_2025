import 'package:flutter/material.dart';
import '../data/books_data.dart';
import 'book_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.6, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: books.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: books[i].apiId != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailPage(bookId: books[i].apiId!, bookTitle: books[i].title, bookImage: books[i].image))) : null,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(image: AssetImage(books[i].image), fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}