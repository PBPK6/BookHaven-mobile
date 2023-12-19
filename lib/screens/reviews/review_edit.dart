import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bookhaven_mobile/models/review.dart';


class ReviewEditFormPage extends StatefulWidget {
  final Future<void> Function() onSubmittedReview;

  const ReviewEditFormPage({Key? key, required this.review, required this.onSubmittedReview}) : super(key: key);
  final Review review;

  @override
  State<ReviewEditFormPage> createState() => _ReviewEditFormPageState();
}

class _ReviewEditFormPageState extends State<ReviewEditFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _book = "";
  int _rate = 0;
  String _review = "";
  final _dateAdded = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,
            child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Book Name",
                  labelText: "Book Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _book = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.15,
            child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Rating",
                  labelText: "Rating",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _rate = int.parse(value!);
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Rating cannot be empty!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Rating must be a number!";
                  }
                  if (_rate > 10) {
                    return "Rating cannot be greater than ten!";
                  }
                  return null;
                },
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Review",
                  labelText: "Review",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _review = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Review cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
          ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04
            ),

            Stack(
                  children: [
                Align(alignment: Alignment.centerRight, child:
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/edit-flutter-review/${widget.review.pk}",
                        jsonEncode(<String, String>{
                          'book': _book,
                          'rate': _rate.toString(),
                          'review': _review,
                          'date': _dateAdded.toString(),
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Review edited successfully!"),
                          ),
                        );
                        await widget.onSubmittedReview();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong, please try again."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ),
                Align(
                  alignment: Alignment.centerLeft, 
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                    child: const Text('Delete', style: TextStyle(color:Colors.white)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure you sure?'),
                          content: const Text('This review will be deleted.'),
                          actions: [
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                final response = await request.postJson(
                                "http://127.0.0.1:8000/delete-flutter-review/${widget.review.pk}",
                                jsonEncode(<String, String>{}),
                              );
                              if (response['status'] == 'success') {
                                await widget.onSubmittedReview();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Review deleted successfully!"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Something went wrong, please try again."),
                                  ),
                                );
                              }
                              },
                            ),
                          ],
                        ),
                      );
                  },
              ),
              ),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
