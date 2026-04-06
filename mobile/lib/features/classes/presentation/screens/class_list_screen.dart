import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/province_entity.dart';
import '../../domain/entities/ward_entity.dart';
import '../../domain/entities/open_class_entity.dart';
import '../bloc/open_class_bloc.dart';
import '../bloc/open_class_event.dart';
import '../bloc/open_class_state.dart';
import 'package:go_router/go_router.dart';

/// ClassListScreen — synced with web filter UI.
/// Filters: search + Môn học + Hình thức + Cấp độ + Tỉnh/TP + Quận/Huyện + Giới tính + Trình độ GS
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
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _subjectFilter;
  String? _levelFilter;
  String? _locationFilter;
  String? _genderFilter;
  String? _tutorLevelFilter;

  // Province/Ward — real API data
  ProvinceEntity? _selectedProvince;
  WardEntity? _selectedWard;
  List<WardEntity> _wards = [];
  bool _loadingWards = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onProvinceSelected(ProvinceEntity province) async {
    setState(() {
      _selectedProvince = province;
      _selectedWard = null;
      _wards = [];
      _loadingWards = true;
    });

    // Load wards for this province
    final bloc = context.read<OpenClassBloc>();
    bloc.add(LoadWardsRequested(province.code));

    // Wait a bit for the bloc to process, then grab cached wards
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _wards = bloc.currentWards;
      _loadingWards = false;
    });
  }

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
              // Search
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm lớp học...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
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

              // Filter chips — all horizontal scroll
              BlocBuilder<OpenClassBloc, OpenClassState>(
                builder: (context, state) {
                  if (state is! OpenClassLoaded) return const SizedBox.shrink();
                  final filters = state.filters;
                  final provinces = state.provinces;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Môn học
                        _FilterChip(
                          label: _subjectFilter ?? 'Môn học',
                          isSelected: _subjectFilter != null,
                          onTap: () => _showFilterSheet(
                            title: 'Chọn môn học',
                            options: filters.subjects,
                            selected: _subjectFilter,
                            onSelected: (v) => setState(() => _subjectFilter = v),
                          ),
                          onClear: _subjectFilter != null ? () => setState(() => _subjectFilter = null) : null,
                        ),
                        const SizedBox(width: 8),

                        // Hình thức
                        _FilterChip(
                          label: _locationFilter ?? 'Hình thức',
                          isSelected: _locationFilter != null,
                          onTap: () => _showFilterSheet(
                            title: 'Chọn hình thức',
                            options: const ['Online', 'Offline'],
                            selected: _locationFilter,
                            onSelected: (v) => setState(() => _locationFilter = v),
                          ),
                          onClear: _locationFilter != null ? () => setState(() => _locationFilter = null) : null,
                        ),
                        const SizedBox(width: 8),

                        // Cấp độ
                        if (filters.levels.isNotEmpty) ...[
                          _FilterChip(
                            label: _levelFilter ?? 'Cấp độ',
                            isSelected: _levelFilter != null,
                            onTap: () => _showFilterSheet(
                              title: 'Chọn cấp độ',
                              options: filters.levels,
                              selected: _levelFilter,
                              onSelected: (v) => setState(() => _levelFilter = v),
                            ),
                            onClear: _levelFilter != null ? () => setState(() => _levelFilter = null) : null,
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Tỉnh / Thành phố — real API
                        if (provinces.isNotEmpty) ...[
                          _FilterChip(
                            label: _selectedProvince?.name ?? 'Tỉnh/TP',
                            isSelected: _selectedProvince != null,
                            onTap: () => _showProvinceSheet(provinces),
                            onClear: _selectedProvince != null
                                ? () => setState(() {
                                    _selectedProvince = null;
                                    _selectedWard = null;
                                    _wards = [];
                                  })
                                : null,
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Quận / Huyện — loads after province selected
                        if (_selectedProvince != null) ...[
                          _FilterChip(
                            label: _selectedWard?.name ?? (_loadingWards ? 'Đang tải...' : 'Quận/Huyện'),
                            isSelected: _selectedWard != null,
                            onTap: _loadingWards || _wards.isEmpty
                                ? () {}
                                : () => _showWardSheet(),
                            onClear: _selectedWard != null ? () => setState(() => _selectedWard = null) : null,
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Giới tính
                        if (filters.genders.isNotEmpty) ...[
                          _FilterChip(
                            label: _genderFilter ?? 'Giới tính',
                            isSelected: _genderFilter != null,
                            onTap: () => _showFilterSheet(
                              title: 'Yêu cầu giới tính',
                              options: filters.genders,
                              selected: _genderFilter,
                              onSelected: (v) => setState(() => _genderFilter = v),
                            ),
                            onClear: _genderFilter != null ? () => setState(() => _genderFilter = null) : null,
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Trình độ gia sư
                        if (filters.tutorLevels.isNotEmpty)
                          _FilterChip(
                            label: _tutorLevelFilter ?? 'Trình độ GS',
                            isSelected: _tutorLevelFilter != null,
                            onTap: () => _showFilterSheet(
                              title: 'Trình độ gia sư',
                              options: filters.tutorLevels,
                              selected: _tutorLevelFilter,
                              onSelected: (v) => setState(() => _tutorLevelFilter = v),
                            ),
                            onClear: _tutorLevelFilter != null ? () => setState(() => _tutorLevelFilter = null) : null,
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
                return _buildErrorState(theme, state.message);
              }
              if (state is OpenClassLoaded) {
                final filtered = _applyFilters(state.classes);
                if (filtered.isEmpty) return _buildEmptyState(theme);

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<OpenClassBloc>().add(FetchOpenClassesRequested());
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ClassCard(
                        classItem: filtered[index],
                        onTap: () => context.push('/class-detail', extra: filtered[index]),
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

  // ── Filtering Logic (synced with web) ──
  List<OpenClassEntity> _applyFilters(List<OpenClassEntity> classes) {
    var result = classes;

    if (_searchQuery.isNotEmpty) {
      result = result.where((c) {
        return c.title.toLowerCase().contains(_searchQuery) ||
            c.subject.toLowerCase().contains(_searchQuery) ||
            c.grade.toLowerCase().contains(_searchQuery) ||
            c.classCode.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (_subjectFilter != null) {
      result = result.where((c) => c.subject == _subjectFilter).toList();
    }

    if (_levelFilter != null) {
      result = result.where((c) => c.grade == _levelFilter).toList();
    }

    if (_locationFilter != null) {
      if (_locationFilter == 'Online') {
        result = result.where((c) => c.location == 'Online').toList();
      } else {
        result = result.where((c) => c.location != null && c.location != 'Online').toList();
      }
    }

    // Province filter — match province name in location string (same logic as web)
    if (_selectedProvince != null) {
      final provinceName = _normalizeLocation(_selectedProvince!.name);
      result = result.where((c) {
        if (c.location == null || c.location == 'Online') return false;
        return _normalizeLocation(c.location!).contains(provinceName);
      }).toList();
    }

    // Ward filter — match ward name in location string
    if (_selectedWard != null) {
      final wardName = _normalizeLocation(_selectedWard!.name);
      result = result.where((c) {
        if (c.location == null) return false;
        return _normalizeLocation(c.location!).contains(wardName);
      }).toList();
    }

    if (_genderFilter != null) {
      result = result.where((c) =>
          c.genderRequirement == _genderFilter ||
          c.genderRequirement == 'Không yêu cầu',
      ).toList();
    }

    if (_tutorLevelFilter != null) {
      result = result.where((c) =>
          c.tutorLevelRequirement.contains(_tutorLevelFilter),
      ).toList();
    }

    return result;
  }

  /// Normalize Vietnamese location strings for fuzzy matching (same as web)
  String _normalizeLocation(String str) {
    return str
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ── Province Sheet ──
  void _showProvinceSheet(List<ProvinceEntity> provinces) {
    _showSearchableSheet(
      title: 'Chọn Tỉnh / Thành phố',
      items: provinces,
      labelBuilder: (p) => p.name,
      selected: _selectedProvince,
      onSelected: (province) => _onProvinceSelected(province),
    );
  }

  // ── Ward Sheet ──
  void _showWardSheet() {
    _showSearchableSheet(
      title: 'Chọn Quận / Huyện / Xã',
      items: _wards,
      labelBuilder: (w) => w.name,
      selected: _selectedWard,
      onSelected: (ward) => setState(() => _selectedWard = ward),
    );
  }

  // ── Generic searchable bottom sheet ──
  void _showSearchableSheet<T>({
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    T? selected,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return _SearchableSheetContent<T>(
          title: title,
          items: items,
          labelBuilder: labelBuilder,
          selected: selected,
          onSelected: (item) {
            onSelected(item);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  // ── Simple filter sheet (for string options) ──
  void _showFilterSheet({
    required String title,
    required List<String> options,
    String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.6;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (_, i) {
                      final opt = options[i];
                      return ListTile(
                        title: Text(opt),
                        trailing: selected == opt
                            ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                            : null,
                        onTap: () {
                          onSelected(opt);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.read<OpenClassBloc>().add(FetchOpenClassesRequested()),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
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
}

/// ── Searchable Bottom Sheet Content (for provinces/wards) ──
class _SearchableSheetContent<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) labelBuilder;
  final T? selected;
  final ValueChanged<T> onSelected;

  const _SearchableSheetContent({
    required this.title,
    required this.items,
    required this.labelBuilder,
    this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  State<_SearchableSheetContent<T>> createState() => _SearchableSheetContentState<T>();
}

class _SearchableSheetContentState<T> extends State<_SearchableSheetContent<T>> {
  String _query = '';

  List<T> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items.where((item) => widget.labelBuilder(item).toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            ),
            // Search within list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final item = _filtered[i];
                  final label = widget.labelBuilder(item);
                  final isSelected = widget.selected != null && widget.labelBuilder(widget.selected as T) == label;

                  return ListTile(
                    title: Text(label),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () => widget.onSelected(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Sheet Handle Bar ──
class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// ── Filter Chip Widget ──
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// ── Class Card ──
class _ClassCard extends StatelessWidget {
  final OpenClassEntity classItem;
  final VoidCallback onTap;

  const _ClassCard({required this.classItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(80)),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withAlpha(30) : Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Code Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tag, size: 13, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      classItem.classCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Title + Fee
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.title,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${classItem.subject} • ${classItem.grade}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _buildFeeDisplay(),
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
              const SizedBox(height: 8),

              // Location
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: _resolveLocationText(),
                color: theme.colorScheme.primary.withAlpha(180),
                theme: theme,
              ),
              const SizedBox(height: 4),

              // Schedule
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: _resolveScheduleText(),
                color: theme.colorScheme.primary.withAlpha(180),
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildFeeDisplay() {
    final minFee = CurrencyFormatter.formatVND(classItem.minTutorFee);
    final maxFee = CurrencyFormatter.formatVND(classItem.maxTutorFee);
    final isRange = classItem.minTutorFee != classItem.maxTutorFee;
    return isRange ? '$minFee - ${maxFee}đ' : '${minFee}đ';
  }

  String _resolveLocationText() {
    if (classItem.location == null) return 'Chưa cập nhật';
    if (classItem.location == 'Online') return 'Online (Trực tuyến)';
    return classItem.location!;
  }

  String _resolveScheduleText() {
    if (classItem.schedule.isEmpty || classItem.schedule == '[]') {
      return 'Chưa rõ (Chưa xếp lịch)';
    }
    return classItem.schedule;
  }

}

/// ── Reusable icon + text row ──
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
