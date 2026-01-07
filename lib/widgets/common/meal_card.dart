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
          // DEBUG: Testing with simple text instead of buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.green,
            child: const Text(
              'EDIT',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.red,
            child: const Text(
              'DEL',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
