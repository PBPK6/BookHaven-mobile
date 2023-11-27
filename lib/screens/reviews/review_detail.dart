import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/models/review.dart';

class ReviewDetailPage extends StatelessWidget {
  final Review review;

  const ReviewDetailPage({Key? key, required this.review}) : super(key: key);

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
            Text(
              '${review.fields.book}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to item list page
              },
              child: const Text('Back to Reviews'),
            ),
          ],
        ),
      ),
    );
  }
}