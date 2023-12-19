import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/models/review.dart';
import 'package:bookhaven_mobile/screens/reviews/review_edit.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewDetailPage extends StatelessWidget {
  final Review review;
  final Future<void> Function() onSubmittedReview;

  const ReviewDetailPage({
    Key? key,
    required this.review,
    required this.onSubmittedReview,
  }) : super(key: key);

  Future<bool> isAdmin(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/check_su/');
    return response['is_superuser'];
  }

  Future<bool> isAuthor(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/get_username/');
    return (response['username'] == review.fields.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Detail'),
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
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      bool isAdminResult = await isAdmin(context);
                      bool isAuthorResult = await isAuthor(context);
                      bool verdict = (isAdminResult || isAuthorResult);
                      if (!verdict) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You cannot edit this review.'),
                          ),
                        );
                      } else {
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
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Edit Review',
                                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                                    Expanded(
                                      child: ReviewEditFormPage(review: review, onSubmittedReview: onSubmittedReview),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
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
