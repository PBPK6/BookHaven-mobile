import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookhaven_mobile/screens/home.dart';
import 'package:bookhaven_mobile/screens/top.dart';
import 'package:bookhaven_mobile/screens/library.dart';
import 'package:bookhaven_mobile/screens/booklist.dart';
import 'package:bookhaven_mobile/screens/reviews.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () =>  NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            const NavigationDestination(icon: Icon(Icons.recommend), label: 'Top'),
            const NavigationDestination(icon: Icon(Icons.library_books_rounded), label: 'Library'),
            const NavigationDestination(icon: Icon(Icons.list), label: 'Booklist'),
            const NavigationDestination(icon: Icon(Icons.reviews), label: 'Reviews')
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomePage(),
    const TopPage(),
    const LibraryPage(),
    const BookListPage(),
    const ReviewsPage(),
    ];
}