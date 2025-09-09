import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  final query = ''.obs;

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => query.value = v,
              decoration: InputDecoration(
                hintText: "Type to search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text("You typed: ${query.value}")),
          ],
        ),
      ),
    );
  }
}
