import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhaven_mobile/models/Book.dart';
import 'package:bookhaven_mobile/screens/library/book_detail_page.dart';

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

    print(response);
    return response['is_superuser'];
  }

  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: Future.wait([fetchBook(), isAdmin()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
            return const Center(
              child: Text(
                "No book data available.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            List<Book> books = snapshot.data![0];
            bool isAdmin = snapshot.data![1];

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
                          tag: "book-${books[index].fields.isbn}",
                          child: Image.network(
                            "${books[index].fields.imageL}",
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
                                "${books[index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${books[index].fields.author}"),
                              const SizedBox(height: 10),
                              Text("${books[index].fields.year}")
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final response = await request.postJson(
                                "http://127.0.0.1:8000/add_to_list_fl/",
                                jsonEncode(<String, dynamic>{
                                  'isbn': "${books[index].fields.isbn}",
                                }));
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Book added successfully!"),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Something went wrong, please try again."),
                              ));
                            }
                          },
                          child: Text('Add'),
                        ),
                        if (isAdmin)
                          ElevatedButton(
                            onPressed: () async {
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/del_from_library_fl/",
                                jsonEncode(<String, dynamic>{
                                  'isbn': "${books[index].fields.isbn}",
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
