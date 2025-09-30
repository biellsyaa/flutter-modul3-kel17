// lib/models/country.dart
class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<String>? languages;
  final List<String>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<String>? langs;
    if (json['languages'] != null && json['languages'] is List) {
      langs = (json['languages'] as List).map((l) {
        if (l is Map && l['name'] != null) return l['name'].toString();
        return l.toString();
      }).toList();
    }

    List<String>? cur;
    if (json['currencies'] != null && json['currencies'] is List) {
      cur = (json['currencies'] as List).map((c) {
        if (c is Map && c['name'] != null) return c['name'].toString();
        return c.toString();
      }).toList();
    }

    String? png;
    if (json['flags'] != null &&
        json['flags'] is Map &&
        json['flags']['png'] != null) {
      png = json['flags']['png'].toString();
    }

    return Country(
      name: (json['name'] ?? 'N/A').toString(),
      region: (json['region'] ?? 'N/A').toString(),
      population: json['population'] is int
          ? json['population'] as int
          : int.tryParse((json['population'] ?? '0').toString()) ?? 0,
      capital: json['capital']?.toString(),
      flagsPng: png,
      languages: langs,
      currencies: cur,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
