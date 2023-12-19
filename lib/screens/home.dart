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
      body: FutureBuilder(
        future: request.get('http://127.0.0.1:8000/get_user_books_count/'),
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
                      child: SingleChildScrollView(child: 
                      Column(
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
                                size: 48, // You can adjust the size as needed
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
                          Text(
                            "\nAbout Us:\nIn a world driven by technology, the art of storytelling should be easily accessible to all. This is the vision that sparked the creation of 'Book Haven.' The founders, a diverse group of readers, writers, and tech enthusiasts, shared a common passion for literature. They envisioned a platform where writers could freely share their stories, and readers could explore a vast collection of books tailored to their tastes. Thus, 'Book Haven' was born."

"'Book Haven' isn't just a platform; it's a sanctuary for bibliophiles. Writers can showcase their literary creations, providing detailed descriptions to entice potential readers. Users, on the other hand, can easily find books that match their preferred genres, thanks to the innovative genre recommendation system."

"Reviews, although a challenge, were deemed essential to ensure quality content and provide constructive feedback to authors. The team was up for the task, determined to implement this feature in a way that would enrich the reading experience for all. As the development progressed, the team introduced a range of features aimed at enhancing user engagement. From the 'Book Haven’s recommended Books' to the 'About Us' page, every element of the app was designed to foster a sense of community and appreciation for literature."

"To cater to different roles within the platform, the team established three distinct user types: Administrators and readers. Administrators would oversee the entire operation, ensuring a safe and enriching environment for all. Readers would have the power to explore and engage with the content."

"'Book Haven' wasn't just an assignment; it was a passion project. The team's dedication to promoting literacy and storytelling was evident in every line of code and every design choice. They believed that in a world inundated with information, a platform dedicated to the art of storytelling was not only necessary but vital."

"And so, 'Book Haven' was ready to embark on its journey, inviting writers, readers, and enthusiasts from all walks of life to join them in their literary haven. Together, they would create a space where stories thrived, and the love for books knew no bounds."
                          )
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
    );
  }
}
