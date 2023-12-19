import 'package:bookhaven_mobile/models/Book.dart';
import 'package:bookhaven_mobile/screens/library/book_detail_page.dart';
import 'package:flutter/material.dart';

class BookSearch extends SearchDelegate<String> {
  final List<Book> bookList;

  BookSearch(this.bookList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? []
        : bookList.where((book) =>
            book.fields.title.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildBookCards(searchResults, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : bookList.where((book) =>
            book.fields.title.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildBookCards(suggestionList, context);
  }

Widget _buildBookCards(List<dynamic> books, BuildContext context) {
  if (books.isEmpty) {
    return Center(
      child: Text(
        "No results found.",
        style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
      ),
    );
  }

  return ListView.builder(
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                book: book,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Hero(
                  tag: "book-${book.fields.isbn}",
                  child: Image.network(
                    "${book.fields.imageL}",
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${book.fields.title}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${book.fields.author}",
                      ),
                      const SizedBox(height: 5), 
                      Text(
                        "${book.fields.year}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}