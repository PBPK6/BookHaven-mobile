import 'package:bookhaven/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
    const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text('Home Page'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer()
    );
  }
}