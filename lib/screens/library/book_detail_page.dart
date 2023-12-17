import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/models/Book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 40;
    double maxWidth = cardWidth < 600.0 ? cardWidth : 600.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('${book.fields.title}'),
      ),
      body: Container(
        color: Color(0xFFFFFFC436),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              // Set the maximum width
              child: Card(
                color: Color(0xFFFFF0CE),
                child: ListView(
                  shrinkWrap:
                      true, // Allows the ListView to take only the space it needs
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Hero(
                          tag: "book-${book.fields.isbn}",
                          child: Image.network(
                            book.fields.imageL,
                            fit: BoxFit.contain,
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
            ),
          ),
        ),
      ),
    );
  }
}
