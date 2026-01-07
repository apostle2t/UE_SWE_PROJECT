import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../common/header_card.dart';
import '../common/custom_text_field.dart';

/// Log tab widget for adding new meals
class LogTab extends StatelessWidget {
  final TextEditingController mealNameController;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final bool isDarkMode;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final VoidCallback onLogMeal;

  const LogTab({
    super.key,
    required this.mealNameController,
    required this.selectedDate,
    required this.selectedTime,
    required this.isDarkMode,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onLogMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Log Your Meal Card
            HeaderCard.green(
              title: 'Log Your Meal',
              subtitle: 'What did you eat today?',
              icon: Icons.restaurant_menu,
            ),
            const SizedBox(height: 24),
            // Meal Name Label
            Text(
              'Meal Name',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Meal Name Input
            CustomTextField(
              controller: mealNameController,
              hintText: 'e.g., Chicken Salad',
              isDarkMode: isDarkMode,
              suffixIcon: Icons.auto_awesome,
            ),
            const SizedBox(height: 24),
            // Date and Time Row
            _buildDateTimeRow(context),
            const SizedBox(height: 32),
            // Log Meal Button
            _buildLogMealButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onSelectDate,
                child: Container(
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
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryGreen,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedDate.day.toString(),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(selectedDate),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onSelectTime,
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primaryGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedTime.format(context),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.access_time_outlined,
                        color:
                            isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogMealButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onLogMeal,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 22),
            SizedBox(width: 8),
            Text(
              'Log Meal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
