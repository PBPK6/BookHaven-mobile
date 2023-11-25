import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class BookListPage extends StatelessWidget {
    const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text('Booklist'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer()
    );
  }
}