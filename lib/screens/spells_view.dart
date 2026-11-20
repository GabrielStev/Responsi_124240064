import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_keys.dart';
import 'favorite_spell_view.dart';
import 'login_view.dart';
import 'profil_view.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  late Future<List<Spell>> spellsFuture;

  final Box favoritesBox = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    spellsFuture = ApiService.getSpells();
  }

  void toggleFavorite(Spell spell) {
    final key = spell.key;

    if (favoritesBox.containsKey(key)) {
      favoritesBox.delete(key);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${spell.name} dihapus dari favorit')),
      );
    } else {
      favoritesBox.put(key, spell.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${spell.name} ditambahkan ke favorit'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> handleLogout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Berhasil logout!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells'),
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorite Spells',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteSpellsView(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(username: AuthService.currentUser?.username ?? '')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: handleLogout,
          ),
        ],
      ),

      body: FutureBuilder<List<Spell>>(
        future: spellsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        spellsFuture = ApiService.getSpells();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final spells = snapshot.data ?? [];

          if (spells.isEmpty) {
            return const Center(child: Text('Tidak ada data spell'));
          }

          return ValueListenableBuilder(
            valueListenable: favoritesBox.listenable(),
            builder: (context, box, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: spells.length,
                itemBuilder: (context, index) {
                  final spell = spells[index];

                  final isFavorite = box.containsKey(spell.key);

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.auto_awesome),
                      ),

                      title: Text(
                        spell.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(spell.use),

                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          toggleFavorite(spell);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
