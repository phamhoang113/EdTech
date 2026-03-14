import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import 'open_class_card.dart';

// Mock Data
const _mockClasses = [
  OpenClass(
    id: 'c1',
    title: 'Tìm Gia Sư Dạy Toán Lớp 10 Bồi Dưỡng Học Sinh Giỏi',
    subject: 'Toán',
    grade: 'Lớp 10',
    location: 'Quận Cầu Giấy, Hà Nội (Học online)',
    schedule: '2 buổi / tuần (Tối T3, T5)',
    fee: 2000000,
    timeFrame: 'Bắt đầu tuần tới',
  ),
  OpenClass(
    id: 'c2',
    title: 'Giao Tiếp Tiếng Anh Cơ Bản Luyện Speaking',
    subject: 'Tiếng Anh',
    grade: 'Sinh Viên',
    location: 'Quận 1, TP. HCM (Tại nhà)',
    schedule: '3 buổi / tuần (Linh hoạt)',
    fee: 3500000,
    timeFrame: 'Gấp',
  ),
  OpenClass(
    id: 'c3',
    title: 'Ôn Thi Đại Học Môn Vật Lý Khối A',
    subject: 'Vật Lý',
    grade: 'Lớp 12',
    location: 'Học Trực Tuyến',
    schedule: '2 buổi / tuần',
    fee: 2500000,
    timeFrame: 'Trong tháng này',
  ),
];

class OpenClassesSection extends StatelessWidget {
  const OpenClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                              color: Theme.of(context).colorScheme.primary, // Using primary as highlight
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
              TextButton(
                onPressed: () {
                  // Navigate to full list
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Horizontal List View
        SizedBox(
          height: 320, // Give fixed height for cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _mockClasses.length,
            itemBuilder: (context, index) {
              final classItem = _mockClasses[index];
              return OpenClassCard(
                classItem: classItem,
                onApplyClass: () {
                  showAuthGuard(
                    context,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã nhận lớp thành công!')),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
