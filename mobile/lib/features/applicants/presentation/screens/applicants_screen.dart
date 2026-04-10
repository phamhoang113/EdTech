import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../data/datasources/applicant_remote_datasource.dart';
import '../../domain/entities/applicant_entity.dart';

/// Màn hình danh sách gia sư ứng tuyển cho 1 lớp.
/// PH xem profile GS → chọn GS phù hợp.
class ApplicantsScreen extends StatefulWidget {
  final String classId;
  final String? classTitle;
  final String? classCode;

  const ApplicantsScreen({
    super.key,
    required this.classId,
    this.classTitle,
    this.classCode,
  });

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  late Future<List<ApplicantEntity>> _future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _future = getIt<ApplicantDataSource>().getProposedTutors(widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.classTitle ?? 'Gia sư ứng tuyển',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (widget.classCode != null && widget.classCode!.isNotEmpty)
              Text(
                'Mã lớp: ${widget.classCode}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: theme.colorScheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
      body: FutureBuilder<List<ApplicantEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildError(theme, snapshot.error.toString());
          }

          final applicants = snapshot.data ?? [];
          if (applicants.isEmpty) {
            return _buildEmpty(theme);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _loadData());
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: applicants.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader(theme, applicants.length);
                final applicant = applicants[index - 1];
                return _TutorCard(
                  applicant: applicant,
                  onSelect: () {
                    _showTutorProfileBottomSheet(context, applicant, theme);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withAlpha(15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_alt_rounded,
                color: Color(0xFF6366F1), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count gia sư được đề xuất',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Xem profile và chọn gia sư phù hợp',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_outlined,
              size: 56, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
          const SizedBox(height: 12),
          Text('Chưa có gia sư nào được đề xuất',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Admin sẽ duyệt và đề xuất GS sớm',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildError(ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 12),
            Text('Lỗi tải dữ liệu', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(error,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() => _loadData()),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSelectTutor(ApplicantEntity applicant) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận chọn gia sư'),
        content: Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Bạn muốn chọn '),
            TextSpan(
                text: applicant.tutorName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: ' làm gia sư cho lớp này?\n\n'),
            const TextSpan(
                text: 'Lớp sẽ chuyển sang trạng thái "Đang học" và '
                    'các gia sư khác sẽ bị từ chối.',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _doSelectTutor(applicant);
            },
            child: const Text('Chọn gia sư'),
          ),
        ],
      ),
    );
  }

  Future<void> _doSelectTutor(ApplicantEntity applicant) async {
    try {
      await getIt<ApplicantDataSource>()
          .selectTutor(applicant.applicationId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã chọn ${applicant.tutorName}! 🎉'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context, true); // pop back to home with refresh signal
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  void _showTutorProfileBottomSheet(BuildContext context, ApplicantEntity applicant, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TutorProfileBottomSheet(
        applicant: applicant,
        onSelect: () {
          Navigator.pop(ctx);
          _confirmSelectTutor(applicant);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// TUTOR CARD — expandable
// ═══════════════════════════════════════════════════════════
class _TutorCard extends StatelessWidget {
  final ApplicantEntity applicant;
  final VoidCallback onSelect;

  const _TutorCard({
    required this.applicant,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(40),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildAvatar(theme),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTutorInfo(theme)),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final initials = applicant.tutorName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTutorInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          applicant.tutorName,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (applicant.tutorType != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  applicant.tutorType!,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6)),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (applicant.rating != null && applicant.rating! > 0) ...[
              const Icon(Icons.star_rounded,
                  size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 2),
              Text(
                '${applicant.rating!.toStringAsFixed(1)} (${applicant.ratingCount ?? 0})',
                style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ],
    );
  }





  String _formatDob() {
    if (applicant.dateOfBirth == null) return '';
    final parts = applicant.dateOfBirth!.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return applicant.dateOfBirth!;
  }
}

// ═══════════════════════════════════════════════════════════
// TUTOR PROFILE BOTTOM SHEET
// ═══════════════════════════════════════════════════════════
class _TutorProfileBottomSheet extends StatelessWidget {
  final ApplicantEntity applicant;
  final VoidCallback onSelect;

  const _TutorProfileBottomSheet({
    required this.applicant,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withAlpha(50),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(child: _buildTutorInfo(theme)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: theme.colorScheme.outline.withAlpha(30),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection(theme),
                  if (applicant.certBase64s != null && applicant.certBase64s!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Bằng cấp & Chứng chỉ', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildCertificatesList(context),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSelectButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = applicant.tutorName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildTutorInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          applicant.tutorName,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (applicant.tutorType != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  applicant.tutorType!,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6)),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (applicant.rating != null && applicant.rating! > 0) ...[
              const Icon(Icons.star_rounded,
                  size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              Text(
                '${applicant.rating!.toStringAsFixed(1)} (${applicant.ratingCount ?? 0})',
                style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDetailSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (applicant.achievements != null &&
            applicant.achievements!.isNotEmpty) ...[
          _buildDetailRow(theme, Icons.school_outlined, 'Kinh nghiệm',
              applicant.achievements!),
          const SizedBox(height: 12),
        ],
        if (applicant.dateOfBirth != null) ...[
          _buildDetailRow(
              theme, Icons.cake_outlined, 'Năm sinh', _formatDob()),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: _buildStatChip(
                theme,
                Icons.class_outlined,
                '${applicant.tutorActiveClassesCount} lớp đang dạy',
                const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatChip(
                theme,
                Icons.pending_actions,
                '${applicant.tutorPendingApplicationsCount} đơn chờ',
                const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        if (applicant.note != null && applicant.note!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    applicant.note!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(
      ThemeData theme, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCertificatesList(BuildContext context) {
    final validCerts = applicant.certBase64s!
        .where((b64) => b64.trim().isNotEmpty && b64.length > 50)
        .toList();

    if (validCerts.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: validCerts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final b64 = validCerts[index];
          var cleanB64 = b64;
          // Handle 'data:image/jpeg;base64' (with or without comma, case insensitive)
          cleanB64 = cleanB64.replaceFirst(RegExp(r'^data:image\/[^;]+;base64,?', caseSensitive: false), '');
          // Remove any whitespaces/newlines just in case
          cleanB64 = cleanB64.replaceAll(RegExp(r'\s+'), '');
          // Add padding if missing
          while (cleanB64.length % 4 != 0) {
            cleanB64 += '=';
          }
          
          return GestureDetector(
            onTap: () => _showFullscreenImage(context, cleanB64),
            child: Container(
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withAlpha(50)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.memory(
                base64Decode(cleanB64),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullscreenImage(BuildContext context, String base64Str) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.memory(
                base64Decode(base64Str),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelect,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Chọn gia sư này',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDob() {
    if (applicant.dateOfBirth == null) return '';
    final parts = applicant.dateOfBirth!.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return applicant.dateOfBirth!;
  }
}
