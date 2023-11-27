import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/models/review.dart';
import 'package:bookhaven_mobile/screens/reviews/review_edit.dart';

class ReviewDetailAdminPage extends StatelessWidget {
  final Review review;
  final Future<void> Function() onSubmittedReview;

  const ReviewDetailAdminPage({Key? key, required this.review, required this.onSubmittedReview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Detail'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child:
                              IconButton(
                                icon: const Icon(Icons.edit),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Navigate back when the button is pressed
                                },
                              ),
                            ),
                          const Align(
                            alignment: Alignment.center,
                            child:
                              Text(
                                'Edit Review',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Expanded(
                        child:
                      ReviewEditFormPage(review: review, onSubmittedReview: onSubmittedReview),
                      )
                    ],
                  )
                ),
              );
            },
          );
                                }

                              ),
                            ),
                          Text(
                            '${review.fields.book}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
            const SizedBox(height: 8),
            Text('${review.fields.rate}/10⭐️'),
            const SizedBox(height: 8),
            Text('${review.fields.review}'),
            const SizedBox(height: 8),
            Text('Author: ${review.fields.username}'),
            const SizedBox(height: 8),
            Text('${review.fields.date}'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
