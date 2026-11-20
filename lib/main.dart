import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/login_view.dart';
import 'screens/book_view.dart';
import 'services/auth_service.dart';
import 'utils/app_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Membuka penyimpanan favorit
  await Hive.openBox('favorites');

  // Memeriksa sesi login
  final loggedIn = await AuthService.isLoggedIn();

  runApp(HarryPotterApp(isLoggedIn: loggedIn));
}

class HarryPotterApp extends StatelessWidget {
  final bool isLoggedIn;

  const HarryPotterApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harry Potter App',
      debugShowCheckedModeBanner: false,

      scaffoldMessengerKey: scaffoldMessengerKey,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 47, 47, 47)),
      ),

      home: isLoggedIn ? const BookView() : const LoginView(),
    );
  }
}
