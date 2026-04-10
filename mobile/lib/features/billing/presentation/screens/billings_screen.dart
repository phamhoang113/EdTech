import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection.dart';
import '../../data/datasources/billing_remote_datasource.dart';
import '../../domain/entities/billing_detail_entity.dart';

/// Màn hình hóa đơn học phí — PH xem & xác nhận chuyển khoản.
class BillingsScreen extends StatefulWidget {
  const BillingsScreen({super.key});

  @override
  State<BillingsScreen> createState() => _BillingsScreenState();
}

class _BillingsScreenState extends State<BillingsScreen> {
  late Future<List<BillingDetailEntity>> _future;
  _BillingFilter _filter = _BillingFilter.unpaid;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _future = getIt<BillingDataSource>().getBillings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hóa đơn học phí',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // ── Filter chips ──
          _buildFilterBar(theme),

          // ── List ──
          Expanded(
            child: FutureBuilder<List<BillingDetailEntity>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _buildError(theme, snapshot.error.toString());
                }

                final allBillings = snapshot.data ?? [];
                final filtered = _applyFilter(allBillings);

                if (filtered.isEmpty) {
                  return _buildEmpty(theme);
                }

                final totalUnpaid = allBillings
                    .where((b) => b.isUnpaid)
                    .fold<double>(0, (sum, b) => sum + b.amount);

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() => _loadData());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filtered.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildSummary(theme, allBillings, totalUnpaid);
                      }
                      final billing = filtered[index - 1];
                      return _BillingCard(
                        billing: billing,
                        isExpanded: _expandedIndex == index - 1,
                        onToggle: () {
                          setState(() {
                            _expandedIndex =
                                _expandedIndex == index - 1 ? null : index - 1;
                          });
                        },
                        onConfirm: billing.isUnpaid
                            ? () => _confirmTransfer(billing)
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: _BillingFilter.values.map((filter) {
          final isSelected = _filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (_) =>
                  setState(() {
                    _filter = filter;
                    _expandedIndex = null;
                  }),
              selectedColor: const Color(0xFF6366F1).withAlpha(20),
              checkmarkColor: const Color(0xFF6366F1),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummary(
      ThemeData theme, List<BillingDetailEntity> all, double totalUnpaid) {
    if (totalUnpaid <= 0) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFF97316)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.account_balance_wallet, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng chưa thanh toán',
                    style: TextStyle(
                        color: Colors.white.withAlpha(220), fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(totalUnpaid),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
          const SizedBox(height: 12),
          Text(
            _filter == _BillingFilter.all
                ? 'Chưa có hóa đơn nào'
                : 'Không có hóa đơn ${_filter.label.toLowerCase()}',
            style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600),
          ),
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
            Text('Lỗi tải hóa đơn', style: theme.textTheme.titleMedium),
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

  List<BillingDetailEntity> _applyFilter(List<BillingDetailEntity> all) {
    switch (_filter) {
      case _BillingFilter.unpaid:
        return all.where((b) => b.isUnpaid || b.isPending).toList();
      case _BillingFilter.paid:
        return all.where((b) => b.isPaid).toList();
      case _BillingFilter.all:
        return all;
    }
  }

  void _confirmTransfer(BillingDetailEntity billing) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận chuyển khoản'),
        content: Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Xác nhận đã chuyển khoản '),
            TextSpan(
                text: _formatCurrency(billing.amount),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' cho hóa đơn ${billing.classTitle}?\n\n'),
            const TextSpan(
                text: 'Admin sẽ đối soát và xác nhận thanh toán của bạn.',
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
              _doConfirmTransfer(billing);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Future<void> _doConfirmTransfer(BillingDetailEntity billing) async {
    try {
      await getIt<BillingDataSource>().confirmTransfer(billing.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xác nhận chuyển khoản! Chờ đối soát. ✅'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      setState(() => _loadData());
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

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '${formatted}đ';
  }
}

// ═══════════════════════════════════════════════════════════
// FILTER ENUM
// ═══════════════════════════════════════════════════════════
enum _BillingFilter {
  unpaid('Chưa TT'),
  paid('Đã TT'),
  all('Tất cả');

  final String label;
  const _BillingFilter(this.label);
}

// ═══════════════════════════════════════════════════════════
// BILLING CARD — expandable
// ═══════════════════════════════════════════════════════════
class _BillingCard extends StatelessWidget {
  final BillingDetailEntity billing;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onConfirm;

  const _BillingCard({
    required this.billing,
    required this.isExpanded,
    required this.onToggle,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _resolveStatusColor(billing.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded
                ? statusColor.withAlpha(50)
                : theme.colorScheme.outline.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _resolveStatusIcon(billing.status),
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              billing.classTitle,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'T${billing.month}/${billing.year} • ${billing.transactionCode}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatCurrency(billing.amount),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: statusColor),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              billing.statusLabel,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ── Expanded detail ──
                  if (isExpanded) ...[
                    const SizedBox(height: 14),
                    Container(
                        height: 1,
                        color: theme.colorScheme.outline.withAlpha(30)),
                    const SizedBox(height: 14),
                    _buildExpandedInfo(theme),
                    if (billing.isUnpaid && onConfirm != null) ...[
                      const SizedBox(height: 16),
                      _buildConfirmButton(),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedInfo(ThemeData theme) {
    return Column(
      children: [
        _buildInfoRow(theme, 'Học sinh', billing.studentNames ?? '—'),
        if (billing.totalSessions != null)
          _buildInfoRow(theme, 'Số buổi', '${billing.totalSessions} buổi'),
        _buildInfoRow(theme, 'Mã lớp', billing.classCode),

        // Bank info
        if (billing.beneficiaryBank != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💳 Thông tin chuyển khoản',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _buildBankRow(theme, 'Ngân hàng', billing.beneficiaryBank!),
                _buildBankRow(
                    theme, 'Số TK', billing.beneficiaryAccount ?? '—',
                    canCopy: true),
                _buildBankRow(
                    theme, 'Tên TK', billing.beneficiaryName ?? '—'),
                _buildBankRow(
                    theme, 'Nội dung CK', billing.transactionCode,
                    canCopy: true),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildBankRow(ThemeData theme, String label, String value,
      {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: TextStyle(
                    fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
              },
              child: Icon(Icons.copy,
                  size: 14, color: theme.colorScheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onConfirm,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Xác nhận đã chuyển khoản',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveStatusColor(String status) {
    const colors = {
      'DRAFT': Color(0xFF6B7280),
      'UNPAID': Color(0xFFEF4444),
      'PENDING_VERIFICATION': Color(0xFFF59E0B),
      'PAID': Color(0xFF10B981),
    };
    return colors[status] ?? const Color(0xFF6B7280);
  }

  IconData _resolveStatusIcon(String status) {
    const icons = {
      'DRAFT': Icons.edit_note,
      'UNPAID': Icons.payment,
      'PENDING_VERIFICATION': Icons.hourglass_top,
      'PAID': Icons.check_circle,
    };
    return icons[status] ?? Icons.receipt;
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '${formatted}đ';
  }
}
