import 'package:flutter/material.dart';

import 'widgets/open_classes_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                const Icon(Icons.school, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  'EdTech',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.dark_mode_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Open Classes Section goes RIGHT at the top
                const OpenClassesSection(),
                
                const SizedBox(height: 32),
                
                // Placeholder for other sections (Tutors, Categories, etc.)
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
                
                const SizedBox(height: 64), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
