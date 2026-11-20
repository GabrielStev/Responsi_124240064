import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell.dart';

class FavoriteSpellsView extends StatelessWidget {
  const FavoriteSpellsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Box favoritesBox = Hive.box('favorites');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spells'),
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
      ),

      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Belum ada spell favorit'),
                ],
              ),
            );
          }

          final favoriteSpells = box.values.map((item) {
            return Spell.fromMap(Map<dynamic, dynamic>.from(item));
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoriteSpells.length,
            itemBuilder: (context, index) {
              final spell = favoriteSpells[index];

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.auto_awesome)),

                  title: Text(
                    spell.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(spell.use),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () {
                      favoritesBox.delete(spell.key);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${spell.name} berhasil dihapus dari favorit',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
