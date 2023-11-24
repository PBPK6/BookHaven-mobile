import 'package:bookhaven/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
    const ReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text('Reviews'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer()
    );
  }
}