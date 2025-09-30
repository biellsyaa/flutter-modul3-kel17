import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'detail.dart';
import '../models/country.dart';

class HomePage extends StatefulWidget {
  final List<Country> favorites;
  final void Function(Country) onToggleFavorite;

  const HomePage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  String searchQuery = "";
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonData = jsonDecode(respBody);
      final list = jsonData.map((j) => Country.fromJson(j)).toList();
      allCountries = list;
      filteredCountries = list;
      return list;
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  void _filterCountries(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredCountries = allCountries
          .where((c) => c.name.toLowerCase().contains(searchQuery))
          .toList();
      _applySorting();
    });
  }

  void _applySorting() {
    filteredCountries.sort(
      (a, b) =>
          _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
    );
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      _applySorting();
    });
  }

  void _onToggleFavorite(Country country) {
    widget.onToggleFavorite(country); // delegasi ke parent (NavigationPage)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          // tombol sorting
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            onPressed: _toggleSort,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterCountries,
              decoration: const InputDecoration(
                hintText: "Search country...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Country>>(
        future: countries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          }

          return ListView.builder(
            itemCount: filteredCountries.length,
            itemBuilder: (context, i) {
              final country = filteredCountries[i];
              final isFav = widget.favorites.contains(country);
              return Card(
                child: ListTile(
                  leading: country.flagsPng != null
                      ? Image.network(country.flagsPng!, width: 50)
                      : const SizedBox(width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () => _onToggleFavorite(country),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(country: country),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
