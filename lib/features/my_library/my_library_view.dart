import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyLibraryView extends StatelessWidget {
  const MyLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My'),
        actions: [
          IconButton(
            onPressed: () => context.push('/my/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: const Center(child: Text('My Library placeholder')),
    );
  }
}
