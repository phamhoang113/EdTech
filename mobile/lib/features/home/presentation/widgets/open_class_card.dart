import 'package:flutter/material.dart';
import '../../../../app/router.dart';
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
    // Format fee as range (minTutorFee - maxTutorFee) like web
    final minFee = _formatVND(classItem.minTutorFee);
    final maxFee = _formatVND(classItem.maxTutorFee);
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
                color: Theme.of(context).colorScheme.primary, // Using primary as success color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Title (Fixed height for 2 lines to ensure uniformity)
                SizedBox(
                  height: 48,
                  child: Text(
                    classItem.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
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
                
                const Spacer(),
                const Divider(height: 1),
                const SizedBox(height: 12),

                _buildInfoRow(context, Icons.school_outlined, '${classItem.subject} - ${classItem.grade}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.location_on_outlined, classItem.location == null ? 'Chưa cập nhật' : (classItem.location == 'Online' ? 'Online (Trực tuyến)' : classItem.location!)),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.calendar_today_outlined, classItem.schedule.isEmpty || classItem.schedule == '[]' ? 'Chưa rõ (Chưa xếp lịch)' : classItem.schedule),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.schedule_outlined, classItem.timeFrame?.isEmpty ?? true ? 'Chưa cập nhật' : classItem.timeFrame!),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
    );
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

  static String _formatVND(num value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
