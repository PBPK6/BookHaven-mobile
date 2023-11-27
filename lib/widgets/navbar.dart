import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/screens/home.dart';
import 'package:bookhaven_mobile/screens/library.dart';
import 'package:bookhaven_mobile/screens/booklist.dart';
import 'package:bookhaven_mobile/screens/reviews/reviews.dart';


class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
  const NavigationMenu({super.key});
}
class _NavigationMenuState extends State<NavigationMenu> {
  int index = 0;
  final screens = [
    const HomePage(),
    const LibraryPage(),
    const BookListPage(),
    const ReviewsPage(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor:Colors.blue.shade100, 
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          animationDuration: const Duration(milliseconds: 500),
          onDestinationSelected: (index) =>
            setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'
              ),
            NavigationDestination(
              icon: Icon(Icons.library_books_outlined), 
              selectedIcon: Icon(Icons.library_books),
              label: 'Library'
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined), 
              selectedIcon: Icon(Icons.book),
              label: 'Booklist'
            ),
            NavigationDestination(
              icon: Icon(Icons.reviews_outlined), 
              selectedIcon: Icon(Icons.reviews),
              label: 'Reviews'
            )
          ],
        ),
      ),
    );
  }
}