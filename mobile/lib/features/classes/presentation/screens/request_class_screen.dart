import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/mapbox_address_field.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/class_filter_entity.dart';
import '../bloc/open_class_bloc.dart';
import '../bloc/open_class_event.dart';
import '../bloc/open_class_state.dart';

/// Native form đăng ký lớp học — synced với web RequestClassModal.
/// Delegates ALL networking to OpenClassBloc + ClassRepository.
class RequestClassScreen extends StatefulWidget {
  const RequestClassScreen({super.key});

  @override
  State<RequestClassScreen> createState() => _RequestClassScreenState();
}

class _RequestClassScreenState extends State<RequestClassScreen> {
  late final OpenClassBloc _bloc;

  // Form state
  String _subject = '';
  String _grade = '';
  String _mode = 'OFFLINE';
  final _addressController = TextEditingController();
  int _sessionsPerWeek = 2;
  int _sessionDurationMin = 90;
  String _genderRequirement = 'Không yêu cầu';
  final _descriptionController = TextEditingController();

  // Filter data — loaded from BLoC cache or API
  ClassFilterEntity _filters = ClassFilterEntity.empty;
  List<String> _tutorLevels = [];

  // Level fees
  final List<_LevelFeeRow> _levelFees = [];

  bool _filtersLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<OpenClassBloc>();

    // Reuse cached filters if available, otherwise fetch
    if (_bloc.cachedFilters != ClassFilterEntity.empty) {
      _applyFilters(_bloc.cachedFilters);
    } else {
      _bloc.add(FetchOpenClassesRequested());
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _applyFilters(ClassFilterEntity filters) {
    setState(() {
      _filters = filters;
      _tutorLevels = filters.tutorLevels;
      if (filters.subjects.isNotEmpty) _subject = filters.subjects.first;
      if (filters.levels.isNotEmpty) _grade = filters.levels.first;
      _filtersLoaded = true;
    });
  }

  String _buildTitle() {
    if (_subject.isEmpty || _grade.isEmpty) return '';
    return 'Lớp $_subject $_grade';
  }

  void _handleSubmit() {
    // Validation
    if (_subject.isEmpty) {
      setState(() => _error = 'Vui lòng chọn môn học.');
      return;
    }
    if (_grade.isEmpty) {
      setState(() => _error = 'Vui lòng chọn khối/lớp.');
      return;
    }
    if (_mode == 'OFFLINE' && _addressController.text.trim().isEmpty) {
      setState(() => _error = 'Vui lòng nhập địa chỉ học.');
      return;
    }

    setState(() => _error = null);

    // Build levelFees JSON
    String? levelFeesJson;
    if (_levelFees.isNotEmpty) {
      final feesData = _levelFees.map((r) => {'level': r.level, 'fee': r.fee}).toList();
      levelFeesJson = jsonEncode(feesData);
    }

    // Compute parent fee from lowest levelFee
    final parentFee = _levelFees.isNotEmpty
        ? _levelFees.map((r) => r.fee).reduce((a, b) => a < b ? a : b)
        : 0;

    // Determine API endpoint based on role
    final authState = context.read<AuthBloc>().state;
    final role = (authState is AuthAuthenticated) ? authState.user.role : 'PARENT';
    final endpoint = role == 'STUDENT'
        ? '/api/v1/student/classes'
        : '/api/v1/parent/classes';

    _bloc.add(CreateClassRequested({
      '_endpoint': endpoint,
      'title': _buildTitle(),
      'subject': _subject,
      'grade': _grade,
      'mode': _mode,
      if (_mode == 'OFFLINE') 'address': _addressController.text.trim(),
      'schedule': '[]',
      'sessionsPerWeek': _sessionsPerWeek,
      'sessionDurationMin': _sessionDurationMin,
      'parentFee': parentFee,
      'genderRequirement': _genderRequirement != 'Không yêu cầu' ? _genderRequirement : null,
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      if (levelFeesJson != null) 'levelFees': levelFeesJson,
    }));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<OpenClassBloc, OpenClassState>(
        listener: (context, state) {
          if (state is OpenClassLoaded && !_filtersLoaded) {
            _applyFilters(state.filters);
          }
          if (state is ClassCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🎉 Đã gửi yêu cầu mở lớp! Admin sẽ xem xét sớm.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            context.pop();
          }
          if (state is OpenClassError) {
            setState(() => _error = state.message);
          }
        },
        child: BlocBuilder<OpenClassBloc, OpenClassState>(
          builder: (context, state) {
            if (!_filtersLoaded && state is! OpenClassError) {
              return Scaffold(
                appBar: AppBar(title: const Text('Đăng ký lớp mới')),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            final isSubmitting = state is ClassCreating;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Đăng ký lớp mới'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) _buildError(theme),

                    _buildSectionHeader(theme, '📚', 'Thông tin lớp học'),
                    const SizedBox(height: 12),
                    _buildDropdown(label: 'Môn học *', value: _subject, items: _filters.subjects, onChanged: (v) => setState(() => _subject = v ?? '')),
                    const SizedBox(height: 12),
                    _buildDropdown(label: 'Khối / Lớp *', value: _grade, items: _filters.levels, onChanged: (v) => setState(() => _grade = v ?? '')),
                    const SizedBox(height: 20),

                    _buildSectionHeader(theme, '📍', 'Hình thức & Địa điểm'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ModeChip(label: 'Offline', icon: Icons.location_on, isSelected: _mode == 'OFFLINE', onTap: () => setState(() => _mode = 'OFFLINE')),
                        const SizedBox(width: 12),
                        _ModeChip(label: 'Online', icon: Icons.videocam, isSelected: _mode == 'ONLINE', onTap: () => setState(() => _mode = 'ONLINE')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_mode == 'OFFLINE')
                      MapboxAddressField(
                        value: _addressController.text,
                        onChanged: (v) => _addressController.text = v,
                      ),
                    const SizedBox(height: 20),

                    _buildSectionHeader(theme, '📅', 'Lịch học'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildNumberField(label: 'Buổi / tuần', value: _sessionsPerWeek, min: 1, max: 7, onChanged: (v) => setState(() => _sessionsPerWeek = v))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDropdown(
                          label: 'Thời lượng', value: '$_sessionDurationMin',
                          items: ['60', '90', '120', '150'], displayLabels: ['60 phút', '90 phút', '120 phút', '150 phút'],
                          onChanged: (v) => setState(() => _sessionDurationMin = int.parse(v ?? '90')),
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildSectionHeader(theme, '🎓', 'Yêu cầu gia sư'),
                    const SizedBox(height: 12),
                    _buildDropdown(label: 'Giới tính', value: _genderRequirement, items: ['Không yêu cầu', ..._filters.genders], onChanged: (v) => setState(() => _genderRequirement = v ?? 'Không yêu cầu')),
                    const SizedBox(height: 12),
                    _buildLevelFees(theme),
                    const SizedBox(height: 20),

                    _buildSectionHeader(theme, '📝', 'Ghi chú'),
                    const SizedBox(height: 12),
                    TextField(controller: _descriptionController, decoration: InputDecoration(hintText: 'Yêu cầu thêm cho gia sư...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), maxLines: 3),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                        child: isSubmitting
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Gửi yêu cầu mở lớp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── UI helpers (unchanged) ──

  Widget _buildSectionHeader(ThemeData theme, String emoji, String title) => Row(children: [Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8), Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))]);

  Widget _buildError(ThemeData theme) => Container(
    margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: theme.colorScheme.error.withAlpha(15), borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.colorScheme.error.withAlpha(40))),
    child: Row(children: [Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error), const SizedBox(width: 8), Expanded(child: Text(_error!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13)))]),
  );

  Widget _buildDropdown({required String label, required String value, required List<String> items, List<String>? displayLabels, required ValueChanged<String?> onChanged}) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null, isExpanded: true,
          items: items.asMap().entries.map((e) => DropdownMenuItem(value: e.value, child: Text(displayLabels != null ? displayLabels[e.key] : e.value))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNumberField({required String label, required int value, required int min, required int max, required ValueChanged<int> onChanged}) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline, size: 22), onPressed: value > min ? () => onChanged(value - 1) : null),
        Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline, size: 22), onPressed: value < max ? () => onChanged(value + 1) : null),
      ]),
    );
  }

  Widget _buildLevelFees(ThemeData theme) {
    final usedLevels = _levelFees.map((r) => r.level).toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Loại gia sư & học phí', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(_buildFeeHint(), style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        ..._levelFees.asMap().entries.map((entry) {
          final idx = entry.key;
          final row = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Expanded(flex: 2, child: DropdownButtonFormField<String>(
                value: row.level,
                decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                items: _tutorLevels.map((l) => DropdownMenuItem(value: l, enabled: !usedLevels.contains(l) || l == row.level, child: Text(l, style: TextStyle(fontSize: 13, color: usedLevels.contains(l) && l != row.level ? Colors.grey : null)))).toList(),
                onChanged: (v) { if (v != null) setState(() => _levelFees[idx] = _LevelFeeRow(v, _getDefaultFee(v))); },
              )),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: TextFormField(
                key: ValueKey('fee_${row.level}'),
                initialValue: _formatVnd(row.fee), keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(isDense: true, suffixText: 'đ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                onChanged: (v) { final fee = int.tryParse(v.replaceAll('.', '')) ?? row.fee; setState(() => _levelFees[idx] = _LevelFeeRow(row.level, fee)); },
              )),
              const SizedBox(width: 4),
              IconButton(icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error), onPressed: () => setState(() => _levelFees.removeAt(idx))),
            ]),
          );
        }),
        if (_levelFees.length < _tutorLevels.length)
          TextButton.icon(
            onPressed: () {
              final next = _tutorLevels.firstWhere((l) => !usedLevels.contains(l), orElse: () => '');
              if (next.isEmpty) return;
              setState(() => _levelFees.add(_LevelFeeRow(next, _getDefaultFee(next))));
            },
            icon: const Icon(Icons.add, size: 16), label: const Text('Thêm loại gia sư'),
          ),
        if (_levelFees.isNotEmpty) _buildFeeEstimation(theme),
      ],
    );
  }

  int _getDefaultFee(String level) {
    final lower = level.toLowerCase();
    if (lower.contains('sinh viên') || lower.contains('sv')) return 1600000;
    if (lower.contains('giáo viên') || lower.contains('gv')) return 2800000;
    return 2200000;
  }

  String _formatVnd(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  Widget _buildFeeEstimation(ThemeData theme) {
    const weeksPerMonth = 4;
    final sessionsPerMonth = _sessionsPerWeek * weeksPerMonth;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Ước tính ($_sessionsPerWeek buổi/tuần × $weeksPerMonth tuần)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          ..._levelFees.map((lf) {
            final feePerSession = (lf.fee / sessionsPerMonth).round();
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lf.level, style: const TextStyle(fontSize: 13)),
                  Text(
                    '${_formatVnd(feePerSession)}đ/buổi → ${_formatVnd(lf.fee)}đ/tháng',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          Text(
            '※ 1 tháng tính cứng = 4 tuần. Học phí PH trả theo số buổi thực tế.',
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  String _buildFeeHint() {
    final levels = _tutorLevels;
    if (levels.isEmpty) return 'SV ~1.600.000đ · GSTN ~2.200.000đ · GV ~2.800.000đ';
    return levels.map((l) {
      final shortName = l.length > 4 ? l.substring(0, 4) : l;
      return '$shortName ~${_formatVnd(_getDefaultFee(l))}đ';
    }).join(' · ');
  }
}

class _LevelFeeRow {
  final String level;
  final int fee;
  const _LevelFeeRow(this.level, this.fee);
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withAlpha(15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline, width: isSelected ? 2 : 1),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 20, color: color), const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ]),
          ),
        ),
      ),
    );
  }
}
