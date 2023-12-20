import 'package:bookhaven_mobile/widgets/Booklist_search.dart';
import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bookhaven_mobile/models/Book.dart';
import 'package:bookhaven_mobile/screens/library/book_detail_page.dart'; // Import the detail page

class BooklistPage extends StatefulWidget {
  const BooklistPage({Key? key}) : super(key: key);

  @override
  _BooklistPageState createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
  late Future<List<Book>> _futureBookList;
  late List<Book> _bookList = [];

  @override
  void initState() {
    _futureBookList = fetchBook();
    super.initState();
  }

  Future<List<Book>> fetchBook() async {
    final request = context.read<CookieRequest>();
    final response = await request
        .get('https://bookhaven-k6-tk.pbp.cs.ui.ac.id/get_user_books_flutter/');

    List<Book> listBook = [];
    for (var d in response) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    _bookList = listBook; // Store the original book list
    return listBook;
  }

  void _refreshList() {
    setState(() {
      _futureBookList = fetchBook(); // Refresh the book list
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _bookList = _bookList
          .where((book) =>
              book.fields.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booklist'),
        actions: [
          IconButton(
            onPressed: () async {
              final String? result = await showSearch<String>(
                context: context,
                delegate: BookSearch(_bookList),
              );
              if (result != null && result.isNotEmpty) {
                _filterBooks(result);
              }
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      backgroundColor: Color(0xFFFFF0CE),
      body: FutureBuilder(
        future: _futureBookList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || _bookList.isEmpty) {
            return const Center(
              child: Text(
                "No book data available.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: _bookList.length,
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(
                        book: _bookList[index],
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
                          tag: "book-${snapshot.data![index].fields.isbn}",
                          child: Image.network(
                            "${snapshot.data![index].fields.imageL}",
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
                                "${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.author}"),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.year}")
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final response = await request.postJson(
                              "https://bookhaven-k6-tk.pbp.cs.ui.ac.id/del_from_list_fl/",
                              jsonEncode(<String, dynamic>{
                                'isbn': "${snapshot.data![index].fields.isbn}",
                              }),
                            );
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Book removed successfully!"),
                              ));

                              // Refresh the list after successful deletion
                              _refreshList();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Something went wrong, please try again."),
                              ));
                            }
                          },
                          child: Text('Remove'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
