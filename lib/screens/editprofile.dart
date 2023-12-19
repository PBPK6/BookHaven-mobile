import 'dart:convert';
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
  late TextEditingController _newEmailController;
  late TextEditingController _newFullnameController;

  @override
  void initState() {
    super.initState();
    _newUsernameController =
        TextEditingController(text: widget.currentUsername);
    _newEmailController = TextEditingController();
    _newFullnameController = TextEditingController();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    String Divider = "------";
    final request = context.read<CookieRequest>();
    final response =
        await request.get("http://127.0.0.1:8000/auth/get_user_details/");
    print('Response: $response');
    print(Divider);
    String jsonString = json.encode(response);
    print(jsonString);
    print(Divider);
    final Map<String, dynamic> data = json.decode(jsonString);
    print("First Name: ${data['first_name']}");
    setState(() {
      _newUsernameController.text = data['username'];
      _newEmailController.text = data['email'];
      _newFullnameController.text = data['first_name'];
    });
    print(Divider);
  }

  void _updateTextControllers(Map<String, dynamic> userData) {
    print('Printing userData:');
    userData.forEach((key, value) {
      print('$key: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double maxWidth = MediaQuery.of(context).size.width - 50.0;
    maxWidth = maxWidth > 650.0 ? 650.0 : maxWidth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        color: Color(0xFFFFF0CE),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 400),
            child: Card(
              color: Color(0xFFFFC436),
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: _newUsernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: _newEmailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: _newFullnameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: ElevatedButton(
                        onPressed: () async {
                          String newUsername = _newUsernameController.text;
                          String newEmail = _newEmailController.text;
                          String newFullname = _newFullnameController.text;

                          final response = await request.postJson(
                            "http://127.0.0.1:8000/auth/update_username/",
                            jsonEncode(<String, String>{
                              'new_username': newUsername,
                              'new_email': newEmail,
                              'new_fullname': newFullname,
                            }),
                          );

                          if (response['status'] == true) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Username updated successfully.'),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
