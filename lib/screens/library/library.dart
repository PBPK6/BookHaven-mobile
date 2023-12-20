import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
    var url = Uri.parse('https://bookhaven-k6-tk.pbp.cs.ui.ac.id/api/books');
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
    final response =
        await request.get('https://bookhaven-k6-tk.pbp.cs.ui.ac.id/check_su/');
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
                      _launchManageBooksURL();
                    },
                    child: Text('Manage Books'),
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

  void _launchManageBooksURL() async {
    const url = 'https://bookhaven-k6-tk.pbp.cs.ui.ac.id/admin/main/book/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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
}
