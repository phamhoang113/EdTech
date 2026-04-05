import 'package:flutter/material.dart';

import '../widgets/open_classes_section.dart';
import '../widgets/featured_tutors_section.dart';

/// HomeScreen — Tab 1 content. AppBar is handled by MainShell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: const [
        // Open Classes Section
        OpenClassesSection(),

        SizedBox(height: 32),

        // Featured Tutors Section
        FeaturedTutorsSection(),
      ],
    );
  }
}
