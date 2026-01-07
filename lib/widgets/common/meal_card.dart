import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/meal.dart';
import '../../utils/time_formatter.dart';

/// Card widget for displaying a meal entry
class MealCard extends StatelessWidget {
  final Meal meal;
  final bool isDarkMode;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MealCard({
    super.key,
    required this.meal,
    required this.isDarkMode,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: isDarkMode ? Colors.white38 : Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeFormatter.formatTime(meal.time),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white38 : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit button
          if (onEdit != null)
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
                size: 20,
              ),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: 'Edit meal',
            ),
          // Delete button
          if (onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              tooltip: 'Delete meal',
            ),
        ],
      ),
    );
  }
}
