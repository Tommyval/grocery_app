import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:grocery_app/screens/categories.dart';
import 'package:grocery_app/screens/home_screens.dart';
import 'package:grocery_app/screens/user.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';
import '../widgets/text_widgets.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> pages = [
    {
      'page': const HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': const CategoriesScreen(),
      'title': 'Categories Screen',
    },
    {
      'page': const CartScreen(),
      'title': 'Cart Screen',
    },
    {
      'page': const UserScreen(),
      'title': 'user Screen',
    },
  ];
  void selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     pages[_selectedIndex]['title'],
        //   ),
        // ),
        body: pages[_selectedIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor:
                isDark ? Theme.of(context).cardColor : Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: selectedPage,
            unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
            selectedItemColor: isDark ? Colors.lightBlue[200] : Colors.black87,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                      _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 1
                      ? IconlyBold.category
                      : IconlyLight.category),
                  label: 'Categories'),
              BottomNavigationBarItem(
                  icon: badge.Badge(
                    
                    badgeAnimation: const badge.BadgeAnimation.slide(),
                    badgeStyle: badge.BadgeStyle(
                      
                      shape: badge.BadgeShape.circle,
                      badgeColor: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    position: badge.BadgePosition.topEnd(top: -7, end: -7),
                    badgeContent: FittedBox(
                        child: TextWidget(
                            text: cartProvider.getCarItems.length.toString(),
                            colors: Colors.white,
                            fontsize: 15)),
                    child: Icon(
                        _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                  ),
                  label: 'Cart'),
              BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 3
                      ? IconlyBold.user2
                      : IconlyLight.user2),
                  label: 'User'),
            ]));
  }
}
