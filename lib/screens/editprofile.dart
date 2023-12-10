import 'dart:convert';
import 'package:bookhaven_mobile/screens/login.dart';
import 'package:bookhaven_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUsername;

  const EditProfilePage({Key? key, required this.currentUsername})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _newUsernameController;

  @override
  void initState() {
    super.initState();
    _newUsernameController =
        TextEditingController(text: widget.currentUsername);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newUsernameController,
              decoration: InputDecoration(
                labelText: 'New Username',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _newUsernameController.text;

                final response = await request.postJson(
                  "http://127.0.0.1:8000/auth/update_username/",
                  jsonEncode(<String, String>{
                    'new_username': newUsername,
                  }),
                );

                if (response['status'] == true) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Username updated successfully.'),
                      ),
                    );
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Failed to update username.'),
                      ),
                    );
                }
              },
              child: Text('Update Username'),
            ),
          ],
        ),
      ),
    );
  }
}
