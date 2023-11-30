import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhaven_mobile/models/Book.dart';
import 'package:bookhaven_mobile/screens/library/book_detail_page.dart'; // Import the detail page

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                "No book data available.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(
                        book: snapshot.data![index],
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
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content:
                                      Text("feature not yet implemented :(")));
                          },
                          child: Text('Add'),
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
