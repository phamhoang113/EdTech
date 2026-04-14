import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/teaching_datasource.dart';
import '../../data/models/teaching_models.dart';
import '../widgets/material_list_widget.dart';
import '../widgets/assessment_list_widget.dart';
import '../screens/create_assessment_screen.dart';
import '../screens/upload_material_screen.dart';
import '../screens/assessment_detail_screen.dart';
import '../screens/student_progress_screen.dart';

/// Màn hình Giảng dạy/Học tập — Tab thay thế Blog.
/// 3 tab: Tài liệu | Bài tập | Kiểm tra
/// Tích hợp class selector dropdown ở header.
class TeachingScreen extends StatefulWidget {
  const TeachingScreen({super.key});

  @override
  State<TeachingScreen> createState() => _TeachingScreenState();
}

class _TeachingScreenState extends State<TeachingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dataSource = TeachingDataSource();

  // Class selector state
  List<Map<String, dynamic>> _classes = [];
  String? _selectedClassId;
  bool _isLoadingClasses = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadClasses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    final role = _getUserRole();
    if (role == null) {
      setState(() => _isLoadingClasses = false);
      return;
    }

    try {
      final classes = await _dataSource.getMyClassesForRole(role);
      if (mounted) {
        setState(() {
          _classes = classes;
          _isLoadingClasses = false;
          // Auto-select first class
          if (classes.isNotEmpty && _selectedClassId == null) {
            _selectedClassId = classes.first['id']?.toString();
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingClasses = false);
    }
  }

  String? _getUserRole() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) return state.user.role;
    return null;
  }

  String _getSelectedClassName() {
    final cls = _classes.firstWhere(
      (c) => c['id']?.toString() == _selectedClassId,
      orElse: () => {},
    );
    return cls['title']?.toString() ?? 'Lớp';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final role = _getUserRole();

    // Not logged in
    if (role == null) {
      return _buildLoginPrompt(theme);
    }

    return Column(
      children: [
        // ── Class Selector ──
        _buildClassSelector(theme, isDark),

        // ── PH: Nút xem tiến độ ──
        if (role == 'PARENT' && _selectedClassId != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => StudentProgressScreen(
                    classId: _selectedClassId!,
                    className: _getSelectedClassName(),
                  ),
                )),
                icon: const Icon(Icons.trending_up_rounded, size: 18),
                label: const Text('Xem tiến độ con em'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

        // ── Tab Bar ──
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: 'Tài liệu'),
              Tab(text: 'Bài tập'),
              Tab(text: 'Kiểm tra'),
            ],
          ),
        ),

        // ── Tab Content ──
        Expanded(
          child: _selectedClassId == null
              ? _buildNoClassSelected(theme)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _MaterialsTab(
                      classId: _selectedClassId!,
                      isTutor: role == 'TUTOR',
                    ),
                    _AssessmentsTab(
                      classId: _selectedClassId!,
                      type: 'HOMEWORK',
                      isTutor: role == 'TUTOR',
                    ),
                    _AssessmentsTab(
                      classId: _selectedClassId!,
                      type: 'EXAM',
                      isTutor: role == 'TUTOR',
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildClassSelector(ThemeData theme, bool isDark) {
    if (_isLoadingClasses) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    if (_classes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Bạn chưa có lớp học nào.',
                  style: TextStyle(color: Colors.amber.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
          ),
          boxShadow: isDark ? null : [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedClassId,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.primary),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            items: _classes.map((cls) {
              final id = cls['id']?.toString() ?? '';
              final title = cls['title']?.toString() ?? 'Lớp';
              final subject = cls['subject']?.toString() ?? '';
              return DropdownMenuItem(
                value: id,
                child: Row(
                  children: [
                    Icon(Icons.class_rounded, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('$title${subject.isNotEmpty ? ' • $subject' : ''}', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedClassId = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoClassSelected(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, size: 40, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text('Chọn lớp học', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Vui lòng chọn lớp ở dropdown phía trên.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_outline_rounded, size: 40, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text('Đăng nhập để xem', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Bạn cần đăng nhập để truy cập\ntài liệu và bài tập.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Inner tab widgets
// ══════════════════════════════════════════════

class _MaterialsTab extends StatefulWidget {
  final String classId;
  final bool isTutor;

  const _MaterialsTab({required this.classId, required this.isTutor});

  @override
  State<_MaterialsTab> createState() => _MaterialsTabState();
}

class _MaterialsTabState extends State<_MaterialsTab> with AutomaticKeepAliveClientMixin {
  final _dataSource = TeachingDataSource();
  List<MaterialModel>? _materials;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _MaterialsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classId != widget.classId) _load();
  }

  Future<void> _load() async {
    try {
      setState(() => _isLoading = true);
      final materials = await _dataSource.getMaterials(widget.classId);
      if (mounted) setState(() { _materials = materials; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _materials = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _load,
      child: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_materials?.isEmpty ?? true)
            _buildEmpty(theme, 'Chưa có tài liệu nào', Icons.folder_open_rounded)
          else
            MaterialListWidget(
              materials: _materials!,
              isTutor: widget.isTutor,
              onDelete: _deleteMaterial,
              onRefresh: _load,
            ),

          if (widget.isTutor)
            Positioned(
              right: 16, bottom: 80,
              child: FloatingActionButton.extended(
                heroTag: 'upload_material',
                onPressed: _navigateToUpload,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Upload'),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, String message, IconData icon) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Column(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ]),
        ),
      ],
    );
  }

  void _navigateToUpload() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => UploadMaterialScreen(classId: widget.classId)));
    if (result == true && mounted) _load();
  }

  Future<void> _deleteMaterial(String id) async {
    try {
      await _dataSource.deleteMaterial(id);
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể xóa tài liệu.')));
    }
  }
}

class _AssessmentsTab extends StatefulWidget {
  final String classId;
  final String type;
  final bool isTutor;

  const _AssessmentsTab({required this.classId, required this.type, required this.isTutor});

  @override
  State<_AssessmentsTab> createState() => _AssessmentsTabState();
}

class _AssessmentsTabState extends State<_AssessmentsTab> with AutomaticKeepAliveClientMixin {
  final _dataSource = TeachingDataSource();
  List<AssessmentModel>? _assessments;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _AssessmentsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.classId != widget.classId) _load();
  }

  Future<void> _load() async {
    try {
      setState(() => _isLoading = true);
      final list = await _dataSource.getAssessments(widget.classId, type: widget.type);
      if (mounted) setState(() { _assessments = list; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _assessments = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isHomework = widget.type == 'HOMEWORK';

    return RefreshIndicator(
      onRefresh: _load,
      child: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_assessments?.isEmpty ?? true)
            ListView(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Center(child: Column(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(isHomework ? Icons.assignment_rounded : Icons.quiz_rounded, size: 40, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text('Chưa có ${isHomework ? "bài tập" : "đề kiểm tra"} nào',
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
              ])),
            ])
          else
            AssessmentListWidget(
              assessments: _assessments!,
              isTutor: widget.isTutor,
              onRefresh: _load,
              onTap: (assessment) => _navigateToDetail(assessment.id),
            ),

          if (widget.isTutor)
            Positioned(
              right: 16, bottom: 80,
              child: FloatingActionButton.extended(
                heroTag: 'create_${widget.type.toLowerCase()}',
                onPressed: _navigateToCreate,
                icon: Icon(isHomework ? Icons.add_task_rounded : Icons.post_add_rounded),
                label: Text(isHomework ? 'Giao bài' : 'Tạo đề'),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToCreate() async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (_) => CreateAssessmentScreen(classId: widget.classId, type: widget.type),
    ));
    if (result == true && mounted) _load();
  }

  void _navigateToDetail(String assessmentId) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => AssessmentDetailScreen(assessmentId: assessmentId),
    ));
    if (mounted) _load();
  }
}
