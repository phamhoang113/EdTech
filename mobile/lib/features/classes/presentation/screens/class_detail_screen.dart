import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/open_class_entity.dart';

class ClassDetailScreen extends StatefulWidget {
  final OpenClassEntity classItem;

  const ClassDetailScreen({super.key, required this.classItem});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  String? _tutorType;
  bool _isApplied = false;
  bool _isApplying = false;
  bool _isCheckingApplication = true;

  OpenClassEntity get classItem => widget.classItem;

  bool get _isTutor {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated && authState.user.role == 'TUTOR';
  }

  /// GS eligible nếu tutorType nằm trong tutorLevelRequirement của lớp.
  bool get _isEligible {
    if (_tutorType == null) return false;
    if (classItem.tutorLevelRequirement.isEmpty) return true;
    return classItem.tutorLevelRequirement.contains(_tutorType);
  }

  @override
  void initState() {
    super.initState();
    _loadTutorData();
  }

  /// Load tutorType + kiểm tra đã apply chưa.
  Future<void> _loadTutorData() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated || authState.user.role != 'TUTOR') {
      if (mounted) setState(() => _isCheckingApplication = false);
      return;
    }

    final dioClient = getIt<DioClient>();

    // Load profile (tutorType) + check my-applications song song
    try {
      final results = await Future.wait([
        dioClient.dio.get('/api/v1/tutors/profile/me'),
        dioClient.dio.get('/api/v1/classes/my-applications'),
      ]);

      if (!mounted) return;

      // Parse tutorType
      final profileData = results[0].data['data'];
      final tutorType = profileData?['tutorType'] as String?;

      // Check if already applied for this class
      final applicationsList = results[1].data['data'] as List? ?? [];
      final alreadyApplied = applicationsList.any(
        (app) => app['classId'] == classItem.id,
      );

      setState(() {
        _tutorType = tutorType;
        _isApplied = alreadyApplied;
        _isCheckingApplication = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isCheckingApplication = false);
    }
  }

  /// Show dialog nhập ghi chú rồi gọi API apply.
  Future<void> _handleApply() async {
    final note = await _showApplyNoteDialog();
    if (note == null) return; // User cancelled

    setState(() => _isApplying = true);

    try {
      final dioClient = getIt<DioClient>();
      await dioClient.dio.post(
        '/api/v1/classes/${classItem.id}/apply',
        data: {'note': note},
      );

      if (!mounted) return;
      setState(() {
        _isApplied = true;
        _isApplying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Đăng ký nhận lớp thành công! Admin sẽ xem xét sớm.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isApplying = false);

      final message = _extractErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  String _extractErrorMessage(dynamic error) {
    try {
      if (error is DioException) {
        return error.response?.data?['message'] as String? ?? 'Đăng ký thất bại';
      }
    } catch (_) {}
    return 'Đăng ký thất bại, vui lòng thử lại!';
  }

  /// Dialog nhập ghi chú trước khi apply (giống textarea trên web).
  Future<String?> _showApplyNoteDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📝 Ghi chú cho Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nhập lời giới thiệu bản thân hoặc ghi chú (không bắt buộc)',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'VD: Em từng dạy IELTS 3 năm, có chứng chỉ 7.5...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Gửi Đăng Ký'),
          ),
        ],
      ),
    );
  }

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

                  // Eligibility banner (for tutors)
                  if (_isTutor && !_isCheckingApplication) ...[
                    _buildEligibilityBanner(context),
                    const SizedBox(height: 16),
                  ],

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
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildEligibilityBanner(BuildContext context) {
    if (_isApplied) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.withAlpha(80)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bạn đã đăng ký nhận lớp này. Admin sẽ xem xét và liên hệ sớm!',
                style: TextStyle(fontSize: 13, color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isEligible && _tutorType != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orange.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Lớp này yêu cầu ${classItem.tutorLevelRequirement.join(", ")}. '
                'Hồ sơ của bạn ($_tutorType) không đủ điều kiện.',
                style: const TextStyle(fontSize: 13, color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: _buildApplyButton(context),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    // Đang check application
    if (_isCheckingApplication && _isTutor) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const SizedBox(
          height: 20, width: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    // Đã apply
    if (_isApplied) {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text(
          'Đã Đăng Ký Nhận Lớp',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Không eligible (GS đã login nhưng sai loại)
    if (_isTutor && !_isEligible && _tutorType != null) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Không Đủ Điều Kiện',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Eligible hoặc chưa đăng nhập
    return FilledButton(
      onPressed: _isApplying ? null : () {
        showAuthGuard(
          context,
          onSuccess: _handleApply,
        );
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isApplying
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18, width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 10),
                Text('Đang xử lý...', style: TextStyle(fontSize: 16)),
              ],
            )
          : const Text(
              '📝 Nhận Lớp Ngay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

    return _buildFeeList(context, fees, _tutorType);
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
