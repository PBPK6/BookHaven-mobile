import 'package:bookhaven/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
    const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text('Top'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer()
    );
  }
}