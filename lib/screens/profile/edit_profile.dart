import 'package:bookhaven_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
    const EditProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
                title: const Text('Edit Profile'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
      drawer: const LeftDrawer(), 
      body: ListView(
        children: const [
          Text(
            'Username: <user>\n'
            'Password: <hidden password>\n'
            '[button "Edit"]'
            )
        ],
      )
    );
  }
}