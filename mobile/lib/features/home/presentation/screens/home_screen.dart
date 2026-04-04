import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/open_classes_section.dart';

/// HomeScreen — Tab 1 content. AppBar is handled by MainShell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        // Open Classes Section
        const OpenClassesSection(),

        const SizedBox(height: 32),

        // Placeholder for other sections
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Gia Sư Tiêu Biểu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'Tutor cards will go here',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
      ],
    );
  }
}
