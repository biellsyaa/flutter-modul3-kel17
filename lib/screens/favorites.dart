import 'package:flutter/material.dart';
import '../models/country.dart';

class FavoritesPage extends StatelessWidget {
  final List<Country> favorites;
  const FavoritesPage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favorites.isEmpty
          ? const Center(child: Text("Belum ada negara favorit"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                final country = favorites[i];
                return Card(
                  child: ListTile(
                    leading: country.flagsPng != null
                        ? Image.network(country.flagsPng!, width: 50)
                        : const SizedBox(width: 50),
                    title: Text(country.name),
                    subtitle: Text(country.region),
                  ),
                );
              },
            ),
    );
  }
}
