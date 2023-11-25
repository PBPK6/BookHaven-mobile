import 'package:flutter/material.dart';
import 'package:bookhaven_mobile/screens/home.dart';
import 'package:bookhaven_mobile/screens/top.dart';
import 'package:bookhaven_mobile/screens/library.dart';
import 'package:bookhaven_mobile/screens/booklist.dart';
import 'package:bookhaven_mobile/screens/reviews.dart';


class NavigationMenu extends StatefulWidget {
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
  const NavigationMenu({super.key});
}
class _NavigationMenuState extends State<NavigationMenu> {
  int index = 0;
  final screens = [
    const HomePage(),
    const TopPage(),
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
          height: 60,
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          animationDuration: const Duration(milliseconds: 500),
          onDestinationSelected: (index) =>
            setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home_filled),
              label: 'Home'
              ),
            NavigationDestination(
              icon: Icon(Icons.recommend),
              selectedIcon: Icon(Icons.recommend),
              label: 'Top'
              ),
            NavigationDestination(
              icon: Icon(Icons.library_books_rounded), 
              selectedIcon: Icon(Icons.library_books_rounded),
              label: 'Library'
            ),
            NavigationDestination(
              icon: Icon(Icons.list), 
              selectedIcon: Icon(Icons.list),
              label: 'Booklist'
            ),
            NavigationDestination(
              icon: Icon(Icons.reviews), 
              selectedIcon: Icon(Icons.reviews),
              label: 'Reviews'
            )
          ],
        ),
      ),
    );
  }
}