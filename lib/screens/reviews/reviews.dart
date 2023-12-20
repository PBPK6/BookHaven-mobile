import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookhaven_mobile/models/review.dart';
import 'package:bookhaven_mobile/screens/reviews/review_form.dart';
import 'package:bookhaven_mobile/screens/reviews/review_detail.dart';
import 'package:bookhaven_mobile/widgets/left_drawer.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  Future<List<Review>> fetchItem() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('https://bookhaven-k6-tk.pbp.cs.ui.ac.id/json/');

    List<Review> list_item = [];
    for (var d in response) {
      if (d != null) {
        list_item.add(Review.fromJson(d));
      }
    }
    return list_item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: Color(0xFFFFF0CE),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Navigate back when the button is pressed
                                },
                              ),
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Write Review',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Expanded(
                          child: ReviewFormPage(
                            onReviewSubmitted: refreshItems,
                          ),
                        )
                      ],
                    )),
              );
            },
          );
        },
      ),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "No item data available.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewDetailPage(
                              review: snapshot.data![index],
                              onSubmittedReview: refreshItems),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${snapshot.data![index].fields.book}"),
                                      Text(
                                          "${snapshot.data![index].fields.rate}/10⭐\n"
                                          "${snapshot.data![index].fields.review != null && snapshot.data![index].fields.review.isNotEmpty ? _getTruncatedReview(snapshot.data![index].fields.review) : 'No review available'}\n"
                                          "Author: ${snapshot.data![index].fields.username}"),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            )))),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> refreshItems() async {
    setState(() {
      fetchItem();
    });
  }
}

String _getTruncatedReview(String review) {
  if (review.length > 20) {
    return '${review.substring(0, 20)}...';
  } else {
    return review;
  }
}
