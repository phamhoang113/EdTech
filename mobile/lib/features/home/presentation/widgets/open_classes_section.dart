import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../classes/presentation/bloc/open_class_bloc.dart';
import '../../../classes/presentation/bloc/open_class_event.dart';
import '../../../classes/presentation/bloc/open_class_state.dart';
import '../../../classes/presentation/widgets/class_details_dialog.dart';
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
                  child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red))),
                );
              } else if (state is OpenClassLoaded) {
                if (state.classes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('Hiện tại chưa có lớp học nào trống.')),
                  );
                }
                
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 240, // Tăng chiều cao để không bị overflow 4 dòng thông tin
                        ),
                        itemCount: state.classes.length > 6 ? 6 : state.classes.length,
                        itemBuilder: (context, index) {
                          final classItem = state.classes[index];
                          return OpenClassCard(
                            classItem: classItem,
                            onTap: () {
                              ClassDetailsDialog.show(context, classItem);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Button Xem tất cả nằm ở dưới cùng
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/classes');
                        },
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
