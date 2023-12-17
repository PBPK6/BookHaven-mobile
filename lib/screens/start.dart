import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/screens/register.dart';
import 'package:bookhaven_mobile/screens/login.dart';

void main() {
  runApp(StartPage());
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC436),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to BookHaven',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black, // Adjust text color as needed
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Adjust spacing between text and buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginPage(), // Import and use your SearchBook widget here
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                primary: Colors.green, // Green color, change as needed
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10), // Adjust spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Add your register button logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterApp(), // Import and use your SearchBook widget here
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                primary: Colors.blue, // Blue color, change as needed
              ),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
