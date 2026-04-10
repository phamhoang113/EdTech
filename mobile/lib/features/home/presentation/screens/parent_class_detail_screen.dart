import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../applicants/data/datasources/applicant_remote_datasource.dart';
import '../../../applicants/domain/entities/applicant_entity.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../domain/entities/my_class_entity.dart';
import '../../domain/entities/student_entity.dart';

class ParentClassDetailScreen extends StatefulWidget {
  final MyClassEntity classItem;

  const ParentClassDetailScreen({
    super.key,
    required this.classItem,
  });

  @override
  State<ParentClassDetailScreen> createState() => _ParentClassDetailScreenState();
}

class _ParentClassDetailScreenState extends State<ParentClassDetailScreen> {
  late MyClassEntity _currentClass;
  late Future<List<ApplicantEntity>> _applicantsFuture;
  bool _isLoadingStudents = false;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.classItem;
    _applicantsFuture = getIt<ApplicantDataSource>().getProposedTutors(_currentClass.id);
  }

  Future<void> _refresh() async {
    setState(() {
      _applicantsFuture = getIt<ApplicantDataSource>().getProposedTutors(_currentClass.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Very light blue/gray background
      appBar: AppBar(
        title: const Text('Chi tiết lớp học', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Info Card (Match Web UI)
              _buildBasicInfoCard(theme),
              const SizedBox(height: 24),

              // Applicants Section
              _buildApplicantsSection(theme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(ThemeData theme) {
    final statusColor = _resolveStatusColor(_currentClass.status);
    final statusLabelText = _resolveStatusLabel(_currentClass.status);
    
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    List<dynamic> levelFeeList = [];
    if (_currentClass.levelFees != null && _currentClass.levelFees!.isNotEmpty) {
      try {
        levelFeeList = jsonDecode(_currentClass.levelFees!);
      } catch (e) {
        // ignore
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SUBJECT & STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentClass.subject.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabelText,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // TITLE & CODE
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(
                _currentClass.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), fontSize: 20),
              ),
              if (_currentClass.classCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withAlpha(15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${_currentClass.classCode}',
                    style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // STUDENT ASSIGN ALERT
          _buildMissingStudentAlert(theme),
          const SizedBox(height: 20),

          // CHIPS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildModernChip(Icons.menu_book_rounded, _currentClass.grade, const Color(0xFF8B5CF6)),
              if (_currentClass.mode != null)
                _buildModernChip(
                  _currentClass.mode == 'ONLINE' ? Icons.wifi : Icons.store_outlined, 
                  _currentClass.mode == 'ONLINE' ? 'Online' : 'Trực tiếp', 
                  const Color(0xFF6366F1)
                ),
              if (_currentClass.sessionsPerWeek != null || _currentClass.sessionDurationMin != null)
                _buildModernChip(
                  Icons.access_time_rounded,
                  [
                    if (_currentClass.sessionsPerWeek != null) '${_currentClass.sessionsPerWeek} buổi/tuần',
                    if (_currentClass.sessionDurationMin != null) '${_currentClass.sessionDurationMin} phút',
                  ].join(' • '),
                  const Color(0xFF6366F1)
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            children: [
               _buildModernChip(Icons.person_search_rounded, 'GS Không yêu cầu', const Color(0xFF8B5CF6)),
            ],
          ),

          const SizedBox(height: 16),

          // PRICING DETAILS
          if (_currentClass.parentFee != null || levelFeeList.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.workspace_premium_outlined, size: 18, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentClass.parentFee != null && levelFeeList.isEmpty)
                         _buildPriceChip('Học phí', _currentClass.parentFee!, currencyFormat),
                         
                      ...levelFeeList.map((fee) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildPriceChip(
                            _translateTutorLevel(fee['level']),
                            ((fee['tutorFee'] as num?) ?? (fee['tutor_fee'] as num?) ?? 0).toDouble(),
                            currencyFormat
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMissingStudentAlert(ThemeData theme) {
    final hasNoStudents = _currentClass.studentIds.isEmpty;

    if (hasNoStudents) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lớp này chưa có Học sinh', style: TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      const Text('Vui lòng gán học sinh vào để bắt đầu quá trình học.', style: TextStyle(color: Color(0xFF991B1B), fontSize: 13, height: 1.3)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    minimumSize: const Size(0, 36),
                  ),
                  onPressed: _isLoadingStudents ? null : _showAssignStudentsBottomSheet,
                  child: _isLoadingStudents
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Gán ngay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFA7F3D0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Đã gán ${_currentClass.studentIds.length} học sinh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF065F46))),
                  const SizedBox(height: 2),
                  const Text('Sẵn sàng cho các phiên học', style: TextStyle(fontSize: 13, color: Color(0xFF047857))),
                ],
              ),
            ),
            TextButton(
              onPressed: _isLoadingStudents ? null : _showAssignStudentsBottomSheet,
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF059669)),
              child: const Text('Thay đổi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildModernChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildPriceChip(String label, double amount, NumberFormat format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withAlpha(40)),
      ),
      child: Text(
        '$label: ${format.format(amount)}',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
      ),
    );
  }

  String _translateTutorLevel(String? level) {
    if (level == 'STUDENT') return 'Sinh viên';
    if (level == 'GRADUATE') return 'Gia sư Tốt nghiệp';
    if (level == 'TEACHER') return 'Giáo viên';
    return level ?? 'Mức phí';
  }

  Widget _buildApplicantsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('👩‍🏫', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text('GIA SƯ ỨNG TUYỂN', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<ApplicantEntity>>(
          future: _applicantsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi tải danh sách gia sư: ${snapshot.error}', style: TextStyle(color: theme.colorScheme.error, fontSize: 13)));
            }

            final applicants = snapshot.data ?? [];
            if (applicants.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(50)),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.search, size: 40, color: theme.colorScheme.onSurfaceVariant.withAlpha(127)),
                    const SizedBox(height: 12),
                    Text('Chưa có gia sư nào được đề xuất', style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(50)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: applicants.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant.withAlpha(50)),
                itemBuilder: (context, index) {
                  final applicant = applicants[index];
                  return _ApplicantCard(
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
      ],
    );
  }

  Future<void> _showAssignStudentsBottomSheet() async {
    setState(() => _isLoadingStudents = true);
    try {
      final children = await getIt<HomeRemoteDataSource>().getMyChildren();
      setState(() => _isLoadingStudents = false);

      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _AssignStudentsBottomSheet(
          classId: _currentClass.id,
          allChildren: children,
          initialSelectedIds: _currentClass.studentIds.toSet(),
          onAssigned: (newClassItem) {
            setState(() {
              _currentClass = newClassItem;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật học sinh cho lớp thành công!', style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFF10B981)));
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStudents = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _showTutorProfileBottomSheet(BuildContext context, ApplicantEntity applicant, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TutorProfileBottomSheet(
        applicant: applicant,
        onSelect: () {
            Navigator.pop(context);
        },
      ),
    );
  }

  Color _resolveStatusColor(String status) {
    switch (status) {
      case 'PENDING_APPROVAL':
        return const Color(0xFFF59E0B);
      case 'OPEN':
        return const Color(0xFF10B981);
      case 'ASSIGNED':
      case 'COMPLETED':
        return const Color(0xFF3B82F6);
      case 'ACTIVE':
        return const Color(0xFF6366F1);
      default:
        return Colors.grey;
    }
  }

  String _resolveStatusLabel(String status) {
    switch (status) {
      case 'PENDING_APPROVAL':
        return 'Chờ duyệt';
      case 'OPEN':
        return 'Đang mở';
      case 'ASSIGNED':
        return 'Đã có GS';
      case 'ACTIVE':
        return 'Đang học';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'SUSPENDED':
        return 'Tạm hoãn';
      case 'REJECTED':
      case 'CANCELLED':
        return 'Đã huỷ';
      default:
        return 'Không rõ';
    }
  }
}

class _ApplicantCard extends StatelessWidget {
  final ApplicantEntity applicant;
  final VoidCallback onSelect;

  const _ApplicantCard({required this.applicant, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = applicant.status == 'SELECTED';

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF6366F1).withAlpha(15),
              child: Text(
                applicant.tutorName?.isNotEmpty == true ? applicant.tutorName![0].toUpperCase() : '?',
                style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(applicant.tutorName ?? 'Gia sư', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (applicant.tutorType != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            children: [
                              const Icon(Icons.card_travel, size: 10, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(applicant.tutorType!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
               Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: Color(0xFF94A3B8), shape: BoxShape.circle),
                   ),
                   const SizedBox(height: 4),
                   const Text('APPROVED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                 ],
               )
            else
               const Icon(Icons.chevron_right, size: 18, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }
}

class _AssignStudentsBottomSheet extends StatefulWidget {
  final String classId;
  final List<StudentEntity> allChildren;
  final Set<String> initialSelectedIds;
  final Function(MyClassEntity) onAssigned;

  const _AssignStudentsBottomSheet({
    required this.classId,
    required this.allChildren,
    required this.initialSelectedIds,
    required this.onAssigned,
  });

  @override
  State<_AssignStudentsBottomSheet> createState() => _AssignStudentsBottomSheetState();
}

class _AssignStudentsBottomSheetState extends State<_AssignStudentsBottomSheet> {
  late Set<String> _selectedIds;
  late List<StudentEntity> _localChildren;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.initialSelectedIds);
    _localChildren = List.from(widget.allChildren);
  }

  void _toggleStudent(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _showAddStudentForm() async {
    final newStudent = await showModalBottomSheet<StudentEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddStudentBottomSheet(),
    );

    if (newStudent != null) {
      setState(() {
        _localChildren.add(newStudent);
        _selectedIds.add(newStudent.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm hồ sơ học sinh thành công!'), backgroundColor: Color(0xFF10B981)));
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ít nhất 1 học sinh')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final newClass = await getIt<HomeRemoteDataSource>().updateClassStudents(widget.classId, _selectedIds.toList());
      if (!mounted) return;
      Navigator.pop(context);
      widget.onAssigned(newClass);
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(color: theme.colorScheme.outline.withAlpha(50), borderRadius: BorderRadius.circular(3)),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Gán học sinh vào lớp', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('Chọn các học sinh sẽ tham gia vào lớp học này', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: _localChildren.isEmpty 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.face, size: 48, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
                        const SizedBox(height: 16),
                        Text('Bạn chưa có hồ sơ học sinh nào', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shrinkWrap: true,
              itemCount: _localChildren.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final student = _localChildren[index];
                final isSelected = _selectedIds.contains(student.id);

                return InkWell(
                  onTap: () => _toggleStudent(student.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? const Color(0xFF6366F1) : theme.colorScheme.outlineVariant.withAlpha(100)),
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected ? const Color(0xFF6366F1).withAlpha(10) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFCBD5E1), width: 1.5),
                            color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                          ),
                          child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? const Color(0xFF4338CA) : const Color(0xFF1E293B))),
                              const SizedBox(height: 4),
                              if (student.school != null) Text(student.school!, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: _showAddStudentForm,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Thêm học sinh mới', style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: const Color(0xFF6366F1),
                side: const BorderSide(color: Color(0xFF6366F1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Lưu thay đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddStudentBottomSheet extends StatefulWidget {
  const _AddStudentBottomSheet();

  @override
  State<_AddStudentBottomSheet> createState() => _AddStudentBottomSheetState();
}

class _AddStudentBottomSheetState extends State<_AddStudentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _dobController = TextEditingController();
  String _gender = 'MALE';
  bool _isSubmitting = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final body = {
        "fullName": _nameController.text.trim(),
        "gender": _gender,
        if (_schoolController.text.trim().isNotEmpty) "school": _schoolController.text.trim(),
        if (_dobController.text.trim().isNotEmpty) "dateOfBirth": _dobController.text.trim(),
      };
      final newStudent = await getIt<HomeRemoteDataSource>().addChild(body);
      if (!mounted) return;
      Navigator.pop(context, newStudent);
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      padding: EdgeInsets.only(bottom: bottomInsets),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48, height: 5,
                  decoration: BoxDecoration(color: theme.colorScheme.outline.withAlpha(50), borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Thêm học sinh mới', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Họ và tên học sinh *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: 'Giới tính *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: 'MALE', child: Text('Nam')),
                  DropdownMenuItem(value: 'FEMALE', child: Text('Nữ')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Khác')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _gender = val);
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh (Tùy chọn)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _schoolController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Trường học (Tùy chọn)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.school_outlined),
                ),
              ),
              const SizedBox(height: 32),
              
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Thêm học sinh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

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
    final initials = applicant.tutorName != null && applicant.tutorName!.isNotEmpty
        ? applicant.tutorName!
            .split(' ')
            .where((w) => w.isNotEmpty)
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

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
          applicant.tutorName ?? 'Gia sư',
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
