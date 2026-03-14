import 'package:flutter/material.dart';

class OpenClass {
  final String id;
  final String title;
  final String subject;
  final String grade;
  final String location;
  final String schedule;
  final double fee;
  final String timeFrame;

  const OpenClass({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.location,
    required this.schedule,
    required this.fee,
    required this.timeFrame,
  });
}

class OpenClassCard extends StatelessWidget {
  final OpenClass classItem;
  final VoidCallback onApplyClass;

  const OpenClassCard({
    super.key,
    required this.classItem,
    required this.onApplyClass,
  });

  @override
  Widget build(BuildContext context) {
    // Format fee into currency string (e.g. 2.000.000 ₫)
    final feeString = classItem.fee.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  classItem.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Fee
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$feeString ₫',
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
                
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Details (Subject, Location, etc.)
                _buildInfoRow(context, Icons.school_outlined, '${classItem.subject} - ${classItem.grade}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.location_on_outlined, classItem.location),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.calendar_today_outlined, classItem.schedule),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.schedule_outlined, classItem.timeFrame),
                
                const Spacer(),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: onApplyClass,
                    child: const Text('Nhận Lớp Ngay'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ),
      ],
    );
  }
}
