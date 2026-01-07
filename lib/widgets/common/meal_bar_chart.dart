import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

/// Bar chart widget for displaying meals per day
class MealBarChart extends StatelessWidget {
  final List<int> mealsPerDay;
  final bool isDarkMode;

  const MealBarChart({
    super.key,
    required this.mealsPerDay,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Generate day labels
    List<String> dayLabels = [];
    for (int i = 6; i >= 0; i--) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      dayLabels.add(DateFormat('E').format(day).substring(0, 1));
    }

    int maxMeals =
        mealsPerDay.isEmpty ? 4 : mealsPerDay.reduce((a, b) => a > b ? a : b);
    if (maxMeals == 0) maxMeals = 4;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y-axis labels
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAxisLabel(maxMeals.toString()),
              _buildAxisLabel((maxMeals ~/ 2).toString()),
              _buildAxisLabel('0'),
            ],
          ),
          const SizedBox(width: 12),
          // Chart bars
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                double barHeight =
                    maxMeals > 0 ? (mealsPerDay[index] / maxMeals) * 100 : 0;
                if (barHeight < 4 && mealsPerDay[index] > 0) barHeight = 4;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dayLabels[index],
                      style: TextStyle(
                        color: isDarkMode ? Colors.white38 : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: isDarkMode ? Colors.white38 : Colors.grey,
        fontSize: 12,
      ),
    );
  }
}
