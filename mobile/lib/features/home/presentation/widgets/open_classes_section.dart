import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../classes/presentation/bloc/open_class_bloc.dart';
import '../../../classes/presentation/bloc/open_class_event.dart';
import '../../../classes/presentation/bloc/open_class_state.dart';
import 'open_class_card.dart';

class OpenClassesSection extends StatelessWidget {
  const OpenClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OpenClassBloc>()..add(FetchOpenClassesRequested()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          children: [
                            const TextSpan(text: 'Lớp Học '),
                            TextSpan(
                              text: 'Mới Nhất',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Các lớp học đang tìm kiếm gia sư phù hợp ngay hôm nay.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          BlocBuilder<OpenClassBloc, OpenClassState>(
            builder: (context, state) {
              if (state is OpenClassLoading || state is OpenClassInitial) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is OpenClassError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  ),
                );
              } else if (state is OpenClassLoaded) {
                if (state.classes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('Hiện tại chưa có lớp học nào trống.')),
                  );
                }

                final displayClasses = state.classes.length > 6
                    ? state.classes.sublist(0, 6)
                    : state.classes;

                return Column(
                  children: [
                    // Vertical list — mỗi card 1 dòng
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayClasses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final classItem = displayClasses[index];
                          return OpenClassCard(
                            classItem: classItem,
                            onTap: () {
                              context.push('/class-detail', extra: classItem);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // "Xem tất cả" button
                    Center(
                      child: OutlinedButton(
                        onPressed: () => context.push('/classes'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Xem Tất Cả Lớp Học',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
