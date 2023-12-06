import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
    const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
                title: const Text('Profile'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer(), 
      body: ListView(
        children: const [
          Text(
            'Username: <user>\n'
            'Books saved: <int>\n'
            'Reviews made: <int>\n'
            )
        ],
      )
    );
  }
}