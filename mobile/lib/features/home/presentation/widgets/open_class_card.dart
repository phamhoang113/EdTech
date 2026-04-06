import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../classes/domain/entities/open_class_entity.dart';

class OpenClassCard extends StatelessWidget {
  final OpenClassEntity classItem;
  final VoidCallback onTap;

  const OpenClassCard({
    super.key,
    required this.classItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final minFee = CurrencyFormatter.formatVND(classItem.minTutorFee);
    final maxFee = CurrencyFormatter.formatVND(classItem.maxTutorFee);
    final isRange = classItem.minTutorFee != classItem.maxTutorFee;
    final feeDisplay = isRange ? '$minFee - $maxFee' : minFee;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Stack(
            children: [
              // Left Border Decorator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
              ),

              // Fee Percentage Badge — top right corner
              Positioned(
                top: 10,
                right: 10,
                child: _buildFeePercentageBadge(context),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(right: 70),
                      child: Text(
                        classItem.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Fee
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${feeDisplay}đ',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ tháng',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    _buildInfoRow(context, Icons.school_outlined,
                        '${classItem.subject} - ${classItem.grade}'),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      Icons.location_on_outlined,
                      classItem.location == null
                          ? 'Chưa cập nhật'
                          : (classItem.location == 'Online'
                              ? 'Online (Trực tuyến)'
                              : classItem.location!),
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      Icons.calendar_today_outlined,
                      classItem.schedule.isEmpty || classItem.schedule == '[]'
                          ? 'Chưa rõ (Chưa xếp lịch)'
                          : classItem.schedule,
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      Icons.schedule_outlined,
                      classItem.timeFrame?.isEmpty ?? true
                          ? 'Chưa cập nhật'
                          : classItem.timeFrame!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeePercentageBadge(BuildContext context) {
    final percentage = classItem.feePercentage;
    final color = _getBadgeColor(percentage);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(80),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Màu badge phụ thuộc vào mức % nhận lớp
  Color _getBadgeColor(num percentage) {
    if (percentage <= 15) return const Color(0xFF22C55E); // Xanh lá — thấp, hấp dẫn
    if (percentage <= 25) return const Color(0xFF3B82F6); // Xanh dương — trung bình
    return const Color(0xFFEF4444); // Đỏ — cao
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary.withAlpha(200),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}
