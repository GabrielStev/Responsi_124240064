import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailBookView extends StatelessWidget {
  final Book book;

  const DetailBookView({super.key, required this.book});

  String formatValue(dynamic value) {
    if (value == null) {
      return '-';
    }

    if (value is Map || value is List) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Book'),
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (book.cover.isNotEmpty)
            Center(
              child: Image.network(
                book.cover,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 120);
                },
              ),
            ),

          const SizedBox(height: 20),

          Text(
            book.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          const Text(
            'Book Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...book.data.entries.map((entry) {
            if (entry.key == 'image') {
              return const SizedBox.shrink();
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 6),

                    SelectableText(formatValue(entry.value)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
