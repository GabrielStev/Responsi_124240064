import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/spell.dart';

class ApiService {
  // URL API BOOK
  static const String bookUrl =
      'https://potterapi-fedeperin.vercel.app/en/books?';

  // URL API SPELL
  static const String spellUrl =
      'https://potterapi-fedeperin.vercel.app/en/spells';

  // Mengambil data buku
  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(bookUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) {
        return Book.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } else {
      throw Exception('Gagal mengambil data buku');
    }
  }

  // Mengambil data spell
  static Future<List<Spell>> getSpells() async {
    final response = await http.get(Uri.parse(spellUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) {
        return Spell.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } else {
      throw Exception('Gagal mengambil data spell');
    }
  }
}
