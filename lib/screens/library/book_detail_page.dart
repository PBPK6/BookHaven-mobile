import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/models/Book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${book.fields.title}'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16.0), // Add margin as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Hero(
                  tag: "book-${book.fields.isbn}",
                  child: Image.network(
                    book.fields.imageL,
                    height: 700, // Increase the height as needed
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${book.fields.title}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${book.fields.isbn}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 8),
                  Text('${book.fields.author} - ${book.fields.year}'),
                  SizedBox(height: 8),
                  Text('Publisher: ${book.fields.publisher}'),
                  // Add more details as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
