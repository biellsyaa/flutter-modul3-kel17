import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/favorites.dart';
import '../models/country.dart';

class NavigationPage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const NavigationPage({super.key, required this.onToggleTheme});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  List<Country> favorites = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleFavorite(Country c) {
    setState(() {
      if (favorites.contains(c)) {
        favorites.remove(c);
      } else {
        favorites.add(c);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(favorites: favorites, onToggleFavorite: _toggleFavorite),
      FavoritesPage(favorites: favorites),
      ProfilePage(
        onHomeTap: () => _onTabTapped(0),
        onToggleTheme: widget.onToggleTheme,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
