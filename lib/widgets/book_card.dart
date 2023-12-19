import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookhaven_mobile/models/Book.dart';
import 'dart:convert';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Card(
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
                  Text("${book.fields.author}"),
                  const SizedBox(height: 10),
                  Text("${book.fields.year}")
                ],
              ),
            ),
            const SizedBox(width: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/add_to_list_fl/",
                        jsonEncode(<String, dynamic>{
                          'isbn': "${book.fields.isbn}",
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Book added successfully!"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Something went wrong, please try again."),
                        ));
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
