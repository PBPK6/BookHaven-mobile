import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ReviewFormPage extends StatefulWidget {
  final Function onReviewSubmitted;

  const ReviewFormPage({Key? key, required this.onReviewSubmitted}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _book = "";
  int _rate = 0;
  String _review = "";
  final _dateAdded = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
           // SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/create-flutter-review/",
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
                            content: Text("New review has saved successfully!"),
                          ),
                        );
                        widget.onReviewSubmitted();
                        Navigator.pop(context);
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
            ),
          ],
        ),
      ),
    );
  }
}
