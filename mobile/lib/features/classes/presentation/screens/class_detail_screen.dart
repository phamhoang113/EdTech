import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_bloc.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_state.dart';
import '../../domain/entities/open_class_entity.dart';

class ClassDetailScreen extends StatelessWidget {
  final OpenClassEntity classItem;

  const ClassDetailScreen({super.key, required this.classItem});

  @override
  Widget build(BuildContext context) {
    final tutorFeeMin = CurrencyFormatter.formatVND(classItem.minTutorFee);
    final tutorFeeMax = CurrencyFormatter.formatVND(classItem.maxTutorFee);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi tiết lớp học'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Card
                  _buildTitleCard(context),
                  const SizedBox(height: 20),

                  // Basic Info
                  _buildSectionCard(
                    context,
                    title: 'Thông tin cơ bản',
                    icon: Icons.info_outline_rounded,
                    children: [
                      _buildInfoRow(context, 'Mã lớp', classItem.classCode),
                      _buildInfoRow(context, 'Môn học', classItem.subject),
                      _buildInfoRow(context, 'Trình độ', classItem.grade),
                      _buildInfoRow(context, 'Số học viên', '${classItem.studentCount} học viên'),
                      _buildLocationRow(context, classItem.location),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Schedule
                  _buildSectionCard(
                    context,
                    title: 'Thời gian học',
                    icon: Icons.schedule_rounded,
                    children: [
                      _buildInfoRow(context, 'Thời lượng', '${classItem.sessionDurationMin} phút / buổi'),
                      _buildInfoRow(context, 'Số buổi', '${classItem.sessionsPerWeek} buổi / tuần'),
                      _buildInfoRow(
                        context,
                        'Lịch học',
                        classItem.schedule.isEmpty || classItem.schedule == '[]'
                            ? 'Chưa rõ (Chưa xếp lịch)'
                            : classItem.schedule,
                      ),
                      _buildInfoRow(context, 'Dự kiến bắt đầu', classItem.timeFrame ?? 'Chưa cập nhật'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tutor Requirements
                  _buildSectionCard(
                    context,
                    title: 'Yêu cầu gia sư',
                    icon: Icons.person_search_rounded,
                    children: [
                      _buildInfoRow(context, 'Giới tính', classItem.genderRequirement),
                      _buildInfoRow(context, 'Cấp bậc', classItem.tutorLevelRequirement.join(', ')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Income
                  _buildSectionCard(
                    context,
                    title: 'Mức thu nhập dự kiến',
                    icon: Icons.payments_outlined,
                    children: [
                      _buildIncomeSection(context, tutorFeeMin, tutorFeeMax),
                    ],
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              showAuthGuard(
                context,
                onSuccess: () {
                  // Trigger Apply logic
                },
              );
            },
            child: const Text(
              'Nhận Lớp Ngay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    final isRange = classItem.minTutorFee != classItem.maxTutorFee;
    final feeDisplay = isRange
        ? '${CurrencyFormatter.formatVND(classItem.minTutorFee)} - ${CurrencyFormatter.formatVND(classItem.maxTutorFee)}'
        : CurrencyFormatter.formatVND(classItem.minTutorFee);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classItem.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${feeDisplay}đ / tháng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
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
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Địa chỉ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
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
      return _buildFeeContent(context, [
        _buildFeeRow(context, 'Thu nhập Tối thiểu', '$fallbackMin ₫'),
        const SizedBox(height: 8),
        _buildFeeRow(context, 'Thu nhập Tối đa', '$fallbackMax ₫'),
      ]);
    }

    // Read tutor level from BLoC state (already loaded) instead of
    // firing a new API call via FutureBuilder on every rebuild.
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
            // TutorProfileBloc not in tree — show all levels equally
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
    return _buildFeeContent(context, widgets);
  }

  Widget _buildFeeContent(BuildContext context, List<Widget> children) {
    return Column(
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
