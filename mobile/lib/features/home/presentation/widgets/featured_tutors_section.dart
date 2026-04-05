import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../tutor_profile/presentation/bloc/public_tutor_bloc.dart';
import '../../../tutor_profile/presentation/bloc/public_tutor_event.dart';
import '../../../tutor_profile/presentation/bloc/public_tutor_state.dart';
import 'featured_tutor_card.dart';

/// Section "Gia Sư Tiêu Biểu" trên Home screen.
/// Hiển thị grid 3 cột × 3 hàng = tối đa 9 gia sư.
class FeaturedTutorsSection extends StatelessWidget {
  const FeaturedTutorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PublicTutorBloc>()..add(FetchPublicTutorsRequested()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      const TextSpan(text: 'Gia Sư '),
                      TextSpan(
                        text: 'Tiêu Biểu',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Những gia sư được đánh giá cao nhất trên nền tảng.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          BlocBuilder<PublicTutorBloc, PublicTutorState>(
            builder: (context, state) {
              if (state is PublicTutorLoading || state is PublicTutorInitial) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is PublicTutorError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (state is PublicTutorLoaded) {
                if (state.tutors.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Chưa có gia sư nào.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                final displayCount = state.tutors.length > 6 ? 6 : state.tutors.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 170,
                    ),
                    itemCount: displayCount,
                    itemBuilder: (context, index) {
                      return FeaturedTutorCard(tutor: state.tutors[index]);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
