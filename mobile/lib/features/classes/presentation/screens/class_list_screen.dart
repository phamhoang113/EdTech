import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/open_class_entity.dart';
import '../bloc/open_class_bloc.dart';
import '../bloc/open_class_event.dart';
import '../bloc/open_class_state.dart';
import '../widgets/class_details_dialog.dart';

/// ClassListScreen — Full list of open classes with search & filter.
class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OpenClassBloc>()..add(FetchOpenClassesRequested()),
      child: const _ClassListBody(),
    );
  }
}

class _ClassListBody extends StatefulWidget {
  const _ClassListBody();

  @override
  State<_ClassListBody> createState() => _ClassListBodyState();
}

class _ClassListBodyState extends State<_ClassListBody> {
  String _searchQuery = '';
  String? _subjectFilter;
  String? _locationFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Search & Filter Bar ──
        Container(
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              // Search field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm lớp học...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: theme.scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  isDense: true,
                ),
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              ),
              const SizedBox(height: 8),
              // Filter chips
              BlocBuilder<OpenClassBloc, OpenClassState>(
                builder: (context, state) {
                  if (state is! OpenClassLoaded) return const SizedBox.shrink();
                  final subjects = state.classes.map((c) => c.subject).toSet().toList()..sort();
                  final locations = ['Online', 'Offline'];

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: _subjectFilter ?? 'Môn học',
                          isSelected: _subjectFilter != null,
                          onTap: () => _showFilterDialog(
                            title: 'Chọn môn học',
                            options: subjects,
                            selected: _subjectFilter,
                            onSelected: (v) => setState(() => _subjectFilter = v),
                          ),
                          onClear: _subjectFilter != null ? () => setState(() => _subjectFilter = null) : null,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: _locationFilter ?? 'Hình thức',
                          isSelected: _locationFilter != null,
                          onTap: () => _showFilterDialog(
                            title: 'Chọn hình thức',
                            options: locations,
                            selected: _locationFilter,
                            onSelected: (v) => setState(() => _locationFilter = v),
                          ),
                          onClear: _locationFilter != null ? () => setState(() => _locationFilter = null) : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // ── Class List ──
        Expanded(
          child: BlocBuilder<OpenClassBloc, OpenClassState>(
            builder: (context, state) {
              if (state is OpenClassLoading || state is OpenClassInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is OpenClassError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 8),
                      Text(state.message),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => context.read<OpenClassBloc>().add(FetchOpenClassesRequested()),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }
              if (state is OpenClassLoaded) {
                final filtered = _applyFilters(state.classes);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: theme.colorScheme.outline),
                        const SizedBox(height: 8),
                        const Text('Không tìm thấy lớp học phù hợp.'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<OpenClassBloc>().add(FetchOpenClassesRequested());
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _ClassListTile(
                        classItem: item,
                        onTap: () => ClassDetailsDialog.show(context, item),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  List<OpenClassEntity> _applyFilters(List<OpenClassEntity> classes) {
    var result = classes;
    if (_searchQuery.isNotEmpty) {
      result = result.where((c) {
        return c.title.toLowerCase().contains(_searchQuery) ||
            c.subject.toLowerCase().contains(_searchQuery) ||
            c.grade.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    if (_subjectFilter != null) {
      result = result.where((c) => c.subject == _subjectFilter).toList();
    }
    if (_locationFilter != null) {
      if (_locationFilter == 'Online') {
        result = result.where((c) => c.location == 'Online').toList();
      } else {
        result = result.where((c) => c.location != null && c.location != 'Online').toList();
      }
    }
    return result;
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withAlpha(20) : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 14, color: theme.colorScheme.primary),
              ),
            ] else ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog({
    required String title,
    required List<String> options,
    String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
              ),
              const Divider(height: 1),
              ...options.map((opt) => ListTile(
                    title: Text(opt),
                    trailing: selected == opt ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary) : null,
                    onTap: () {
                      onSelected(opt);
                      Navigator.pop(ctx);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/// A single class row in list view.
class _ClassListTile extends StatelessWidget {
  final OpenClassEntity classItem;
  final VoidCallback onTap;

  const _ClassListTile({required this.classItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minFee = _formatVND(classItem.minTutorFee);
    final maxFee = _formatVND(classItem.maxTutorFee);
    final isRange = classItem.minTutorFee != classItem.maxTutorFee;
    final feeDisplay = isRange ? '$minFee - $maxFee' : minFee;
    final locationText = classItem.location == null
        ? 'Chưa cập nhật'
        : (classItem.location == 'Online' ? 'Online (Trực tuyến)' : classItem.location!);
    final scheduleText = classItem.schedule.isEmpty || classItem.schedule == '[]'
        ? 'Chưa rõ (Chưa xếp lịch)'
        : classItem.schedule;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classItem.title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${classItem.subject} • ${classItem.grade}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.colorScheme.primary.withAlpha(180)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationText,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: theme.colorScheme.primary.withAlpha(180)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            scheduleText,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Fee badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${feeDisplay}đ',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '/ tháng',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatVND(num value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
