import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_bloc.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_state.dart';
import '../../domain/entities/open_class_entity.dart';

class ClassDetailsDialog extends StatelessWidget {
  final OpenClassEntity classItem;

  const ClassDetailsDialog({super.key, required this.classItem});

  static Future<void> show(BuildContext context, OpenClassEntity classItem) {
    return showDialog(
      context: context,
      builder: (context) => ClassDetailsDialog(classItem: classItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tutorFeeMin = CurrencyFormatter.formatVND(classItem.minTutorFee);

    final tutorFeeMax = CurrencyFormatter.formatVND(classItem.maxTutorFee);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and close button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    classItem.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Content Scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Thông tin cơ bản'),
                    const SizedBox(height: 8),
                    _buildInfoRow(context, 'Mã lớp', classItem.classCode),
                    _buildInfoRow(context, 'Môn học', classItem.subject),
                    _buildInfoRow(context, 'Trình độ', classItem.grade),
                    _buildInfoRow(context, 'Số lượng học viên', '${classItem.studentCount} học viên'),
                    _buildLocationRow(context, classItem.location),
                    _buildSectionTitle(context, 'Thời gian học'),
                    const SizedBox(height: 8),
                    _buildInfoRow(context, 'Thời lượng', '${classItem.sessionDurationMin} phút / buổi'),
                    _buildInfoRow(context, 'Số buổi', '${classItem.sessionsPerWeek} buổi / tuần'),
                    _buildInfoRow(context, 'Lịch học', classItem.schedule.isEmpty || classItem.schedule == '[]' ? 'Chưa rõ (Chưa xếp lịch)' : classItem.schedule),
                    _buildInfoRow(context, 'Dự kiến bắt đầu', classItem.timeFrame ?? 'Chưa cập nhật'),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Yêu cầu gia sư'),
                    const SizedBox(height: 8),
                    _buildInfoRow(context, 'Giới tính', classItem.genderRequirement),
                    _buildInfoRow(context, 'Cấp bậc', classItem.tutorLevelRequirement.join(', ')),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'Mức thu nhập dự kiến'),
                    const SizedBox(height: 8),
                    _buildIncomeSection(context, tutorFeeMin, tutorFeeMax),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            // Action Button
             SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog first
                  showAuthGuard(
                    context,
                    onSuccess: () {
                      // Trigger Apply logic
                    },
                  );
                },
                child: const Text('Nhận Lớp Ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context, String? location) {
    if (location == null) return _buildInfoRow(context, 'Hình thức', 'Chưa cập nhật');
    if (location == 'Online') return _buildInfoRow(context, 'Hình thức', 'Online (Trực tuyến)');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              'Địa chỉ',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                final query = Uri.encodeComponent(location);
                final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeSection(BuildContext context, String fallbackMin, String fallbackMax) {
    List<Map<String, dynamic>> fees = [];
    if (classItem.levelFees != null && classItem.levelFees!.startsWith('[')) {
      try {
        final List<dynamic> parsed = jsonDecode(classItem.levelFees!);
        for (var e in parsed) {
          if (e is Map<String, dynamic>) fees.add(e);
        }
      } catch (_) {
        // ignore
      }
    }

    if (fees.isEmpty) {
      // Fallback if no valid JSON
      return _buildFeeBox(context, [
        _buildFeeRow(context, 'Thu nhập Tối thiểu', '$fallbackMin ₫'),
        const SizedBox(height: 8),
        _buildFeeRow(context, 'Thu nhập Tối đa', '$fallbackMax ₫'),
      ]);
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String? userLevel;
        if (authState is AuthAuthenticated && authState.user.role == 'TUTOR') {
          try {
            final tutorState = context.read<TutorProfileBloc>().state;
            if (tutorState is TutorDashboardLoaded) {
              userLevel = tutorState.profile.level;
            } else if (tutorState is TutorProfileLoaded) {
              userLevel = tutorState.profile.level;
            }
          } catch (_) {
            // TutorProfileBloc not in tree
          }
        }
        return _buildFeeList(context, fees, userLevel);
      },
    );
  }

  Widget _buildFeeList(BuildContext context, List<Map<String, dynamic>> fees, String? highlightLevel) {
    final widgets = <Widget>[];
    for (int i = 0; i < fees.length; i++) {
      final feeObj = fees[i];
      final level = feeObj['level']?.toString() ?? 'Khác';
      final feeNum = feeObj['fee'] is num ? feeObj['fee'] as num : 0;
      final feeStr = CurrencyFormatter.formatVND(feeNum);
          
      // Ngắn gọn: Nếu highlightLevel != null, tức là User ĐÃ LOGIN và LÀ TUTOR
      // => Cần làm sáng level của họ và mờ đi các level khác.
      // Ngược lại (chưa login) => Sáng tất cả.
      final isHighlighted = highlightLevel == null || highlightLevel == level;
      final opacity = isHighlighted ? 1.0 : 0.4;

      widgets.add(
        Opacity(
          opacity: opacity,
          child: _buildFeeRow(context, level, '$feeStr ₫', isBold: isHighlighted),
        ),
      );
      if (i < fees.length - 1) {
        widgets.add(Opacity(opacity: opacity, child: const SizedBox(height: 8)));
      }
    }

    return _buildFeeBox(context, widgets);
  }

  Widget _buildFeeBox(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Phí nhận lớp', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${classItem.feePercentage}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFeeRow(BuildContext context, String label, String value, {bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
