import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:convert';
import 'package:bookhaven_mobile/models/Book.dart';
import 'package:bookhaven_mobile/screens/library/book_detail_page.dart';
import 'package:bookhaven_mobile/widgets/book_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List<Book>> fetchBook() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }

  Future<bool> isAdmin() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/check_su/');
    return response['is_superuser'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: Color(0xFFFFF0CE),
      body: FutureBuilder(
        future: Future.wait([fetchBook(), isAdmin()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Book> books = snapshot.data![0];
            bool isAdmin = snapshot.data![1];
            print(isAdmin);

            if (isAdmin) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openLinkInBrowser(
                          'http://127.0.0.1:8000/admin/main/book/');
                    },
                    child: Text('Edit'),
                  ),
                  Expanded(
                    child: _buildBookList(books),
                  ),
                ],
              );
            }

            return _buildBookList(books);
          }
        },
      ),
    );
  }

  Widget _buildBookList(List<Book> books) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          "No book data available.",
          style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (_, index) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                book: books[index],
              ),
            ),
          );
        },
        child: BookCard(books[index]),
      ),
    );
  }

  void _openLinkInBrowser(String url) {
    html.window.open(url, 'new_tab');
  }
}
