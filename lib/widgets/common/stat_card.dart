import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Stat card widget for displaying statistics
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDarkMode;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? iconColor.withOpacity(0.2)
                  : iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white54 : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
