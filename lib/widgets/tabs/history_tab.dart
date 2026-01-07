import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/meal.dart';
import '../../theme/app_colors.dart';
import '../common/header_card.dart';
import '../common/custom_text_field.dart';
import '../common/meal_card.dart';

/// History tab widget for viewing meal history
class HistoryTab extends StatelessWidget {
  final List<Meal> meals;
  final TextEditingController searchController;
  final bool isDarkMode;
  final ValueChanged<String> onSearchChanged;
  final void Function(Meal meal) onEditMeal;
  final void Function(Meal meal) onDeleteMeal;

  const HistoryTab({
    super.key,
    required this.meals,
    required this.searchController,
    required this.isDarkMode,
    required this.onSearchChanged,
    required this.onEditMeal,
    required this.onDeleteMeal,
  });

  @override
  Widget build(BuildContext context) {
    // Group meals by date
    Map<String, List<Meal>> groupedMeals = _groupMealsByDate();

    // Filter meals based on search
    String searchQuery = searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      groupedMeals = _filterMeals(groupedMeals, searchQuery);
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Your Journey Card
                HeaderCard.pinkPurple(
                  title: 'Your Journey',
                  subtitle: '${meals.length} meals logged',
                  icon: Icons.history,
                ),
                const SizedBox(height: 20),
                // Search Bar
                CustomTextField(
                  controller: searchController,
                  hintText: 'Search your meals...',
                  isDarkMode: isDarkMode,
                  prefixIcon: Icons.search,
                  onChanged: onSearchChanged,
                ),
              ],
            ),
          ),
          // Meal List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: groupedMeals.length,
              itemBuilder: (context, index) {
                String dateKey = groupedMeals.keys.elementAt(index);
                List<Meal> dateMeals = groupedMeals[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    _buildDateHeader(dateKey),
                    // Meal Cards
                    ...dateMeals.map((meal) => MealCard(
                          meal: meal,
                          isDarkMode: isDarkMode,
                          onEdit: () => onEditMeal(meal),
                          onDelete: () => onDeleteMeal(meal),
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Meal>> _groupMealsByDate() {
    Map<String, List<Meal>> groupedMeals = {};
    for (var meal in meals) {
      String dateKey = DateFormat('MMM d').format(meal.date);
      if (!groupedMeals.containsKey(dateKey)) {
        groupedMeals[dateKey] = [];
      }
      groupedMeals[dateKey]!.add(meal);
    }
    return groupedMeals;
  }

  Map<String, List<Meal>> _filterMeals(
      Map<String, List<Meal>> groupedMeals, String query) {
    return Map.fromEntries(
      groupedMeals.entries.map((entry) {
        return MapEntry(
          entry.key,
          entry.value
              .where((meal) => meal.name.toLowerCase().contains(query))
              .toList(),
        );
      }).where((entry) => entry.value.isNotEmpty),
    );
  }

  Widget _buildDateHeader(String dateKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppColors.primaryGreen,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            dateKey,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
