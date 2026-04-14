import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/teaching_datasource.dart';

/// Màn hình tạo bài tập (HOMEWORK) hoặc đề kiểm tra (EXAM).
class CreateAssessmentScreen extends StatefulWidget {
  final String classId;
  final String type; // 'HOMEWORK' | 'EXAM'

  const CreateAssessmentScreen({
    super.key,
    required this.classId,
    required this.type,
  });

  @override
  State<CreateAssessmentScreen> createState() => _CreateAssessmentScreenState();
}

class _CreateAssessmentScreenState extends State<CreateAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController(text: '45');
  final _dataSource = TeachingDataSource();

  DateTime? _closesAt; // Deadline (cả HOMEWORK và EXAM)
  DateTime? _opensAt;  // EXAM only
  String? _filePath;
  String? _fileName;
  bool _isCreating = false;

  bool get _isExam => widget.type == 'EXAM';
  String get _typeLabel => _isExam ? 'Kiểm tra' : 'Bài tập';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path!;
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickDateTime({required bool isOpensAt}) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (time == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      if (isOpensAt) {
        _opensAt = dateTime;
      } else {
        _closesAt = dateTime;
      }
    });
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    if (_closesAt == null) {
      _showError('Vui lòng chọn ${_isExam ? "thời gian kết thúc" : "deadline"}.');
      return;
    }

    if (_isExam && _opensAt == null) {
      _showError('Vui lòng chọn thời gian bắt đầu kiểm tra.');
      return;
    }

    setState(() => _isCreating = true);

    try {
      final durationMin = _isExam ? int.tryParse(_durationController.text.trim()) : null;

      await _dataSource.createAssessment(
        classId: widget.classId,
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        type: widget.type,
        opensAt: _opensAt,
        closesAt: _closesAt,
        durationMin: durationMin,
        filePath: _filePath,
        fileName: _fileName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo $_typeLabel thành công!'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        _showError('Lỗi tạo $_typeLabel: $e');
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo $_typeLabel'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề *',
                  prefixIcon: Icon(_isExam ? Icons.quiz_rounded : Icons.assignment_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tiêu đề' : null,
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả / Yêu cầu',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.notes_rounded),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 20),

              // ── Time section ──
              Text(
                'Thời gian',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              // EXAM: opens_at
              if (_isExam) ...[
                _DateTimePickerTile(
                  label: 'Bắt đầu *',
                  icon: Icons.play_circle_outline_rounded,
                  value: _opensAt != null ? dateFormat.format(_opensAt!) : null,
                  onTap: () => _pickDateTime(isOpensAt: true),
                ),
                const SizedBox(height: 10),
              ],

              // Deadline / closes_at
              _DateTimePickerTile(
                label: _isExam ? 'Kết thúc *' : 'Deadline *',
                icon: Icons.event_rounded,
                value: _closesAt != null ? dateFormat.format(_closesAt!) : null,
                onTap: () => _pickDateTime(isOpensAt: false),
              ),

              // EXAM: duration
              if (_isExam) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Thời lượng (phút) *',
                    prefixIcon: const Icon(Icons.timer_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) {
                    final num = int.tryParse(v ?? '');
                    if (num == null || num <= 0) return 'Nhập thời lượng > 0';
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 20),

              // File đính kèm (đề bài)
              Text(
                'File đề',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : theme.colorScheme.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _filePath != null
                          ? theme.colorScheme.primary
                          : isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _filePath != null ? Icons.attach_file_rounded : Icons.upload_file_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _filePath != null ? _fileName! : 'Chọn file đề (PDF, Word, Ảnh)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _filePath != null ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            fontWeight: _filePath != null ? FontWeight.w600 : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit
              FilledButton.icon(
                onPressed: _isCreating ? null : _create,
                icon: _isCreating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send_rounded),
                label: Text(_isCreating ? 'Đang tạo...' : 'Tạo $_typeLabel'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTimePickerTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final VoidCallback onTap;

  const _DateTimePickerTile({
    required this.label,
    required this.icon,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value != null
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant, fontSize: 11,
                )),
                const SizedBox(height: 2),
                Text(
                  value ?? 'Chọn...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                    color: value != null ? null : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
