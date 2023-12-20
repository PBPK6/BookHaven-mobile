import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double maxWidth = MediaQuery.of(context).size.width - 50.0;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        backgroundColor: Color(0xFFFFF0CE),
        body: Column(children: [
          FutureBuilder(
            future: request.get(
                'https://bookhaven-k6-tk.pbp.cs.ui.ac.id/get_user_books_count/'),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final bookCount = snapshot.data['book_count'];
                return Center(
                  child: Align(
                    alignment: Alignment(0, -0.9),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Card(
                        color: Color(0xFFFFC436),
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Hello! You currently have',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Colors.black,
                                      size:
                                          48, // You can adjust the size as needed
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$bookCount books!',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bookCount == 0
                                      ? "Why do you have 0 books :( Add some now! :)"
                                      : "Insert more books to your list now!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
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
            },
          ),
          Center(
            child: Align(
              alignment: Alignment(0, -0.9),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  child: Card(
                    color: Color(0xFFFFC436),
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About Us: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 42,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            // Your long text here...
                            "In BookHaven, you can check out books from our extensive library! Like a book? Give it a rating to make sure other people would want to read! Browse, Search, Explore, and Comment! Welcome to BookHaven!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
