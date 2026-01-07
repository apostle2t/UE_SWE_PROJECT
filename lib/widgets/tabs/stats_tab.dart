import 'package:flutter/material.dart';
import '../../models/meal.dart';
import '../../theme/app_colors.dart';
import '../../utils/stats_calculator.dart';
import '../common/header_card.dart';
import '../common/stat_card.dart';
import '../common/meal_bar_chart.dart';

/// Stats tab widget for viewing meal statistics
class StatsTab extends StatelessWidget {
  final List<Meal> meals;
  final bool isDarkMode;

  const StatsTab({
    super.key,
    required this.meals,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    int mealsThisWeek = StatsCalculator.getMealsThisWeek(meals);
    int mealsThisMonth = StatsCalculator.getMealsThisMonth(meals);
    int dayStreak = StatsCalculator.calculateDayStreak(meals);
    List<int> mealsPerDay = StatsCalculator.getMealsPerDayLastWeek(meals);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Statistics Header Card
            HeaderCard.bluePurple(
              title: 'Statistics',
              subtitle: 'Your meal tracking insights',
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 20),
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primaryGreen,
                    value: mealsThisWeek.toString(),
                    label: 'This Week',
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    icon: Icons.trending_up,
                    iconColor: Colors.purple,
                    value: mealsThisMonth.toString(),
                    label: 'This Month',
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    value: dayStreak.toString(),
                    label: 'Day Streak',
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    icon: Icons.restaurant,
                    iconColor: Colors.blue,
                    value: meals.length.toString(),
                    label: 'Total Meals',
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Last 7 Days Chart
            _buildChartContainer(mealsPerDay),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(List<int> mealsPerDay) {
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
          Text(
            'Last 7 Days',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          MealBarChart(
            mealsPerDay: mealsPerDay,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}
