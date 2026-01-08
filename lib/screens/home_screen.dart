import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../theme/app_colors.dart';
import '../repositories/meal_repository.dart';
import '../widgets/tabs/log_tab.dart';
import '../widgets/tabs/history_tab.dart';
import '../widgets/tabs/stats_tab.dart';
import '../widgets/tabs/help_tab.dart';

/// Main home screen of the NutriTrack app
class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Repository and meal data
  final MealRepository _mealRepository = MealRepository();
  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  /// Load all meals from the database
  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    try {
      final meals = await _mealRepository.getAllMeals();
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading meals: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logMeal() async {
    if (_mealNameController.text.isNotEmpty) {
      final meal = Meal(
        id: Meal.generateId(),
        name: _mealNameController.text,
        date: _selectedDate,
        time: _selectedTime,
      );

      try {
        await _mealRepository.insertMeal(meal);
        _mealNameController.clear();
        await _loadMeals(); // Refresh the list

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Meal logged successfully!'),
              backgroundColor: AppColors.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving meal: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _editMeal(Meal meal) {
    final TextEditingController editController =
        TextEditingController(text: meal.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              widget.isDarkMode ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Edit Meal',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: TextField(
            controller: editController,
            autofocus: true,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Meal name',
              hintStyle: TextStyle(
                color: widget.isDarkMode ? Colors.white38 : Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      widget.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryGreen,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            // Cancel and Save buttons
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  final updatedMeal = meal.copyWith(name: editController.text);
                  try {
                    await _mealRepository.updateMeal(updatedMeal);
                    Navigator.pop(context);
                    await _loadMeals(); // Refresh the list

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Meal updated successfully!'),
                          backgroundColor: AppColors.primaryGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating meal: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMeal(Meal meal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              widget.isDarkMode ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Meal',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${meal.name}"?',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _mealRepository.deleteMeal(meal.id);
                  Navigator.pop(context);
                  await _loadMeals(); // Refresh the list

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Meal deleted successfully!'),
                        backgroundColor: Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting meal: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDarkMode ? AppColors.darkCard : Colors.white,
              onSurface: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDarkMode ? AppColors.darkCard : Colors.white,
              onSurface: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.restaurant,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NutriTrack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Track your daily meals',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Theme Toggle Button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkCard
                  : AppColors.primaryGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.wb_sunny : Icons.refresh,
                color: widget.isDarkMode ? Colors.yellow : Colors.white,
                size: 22,
              ),
              onPressed: widget.onThemeToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkCard
            : AppColors.primaryGreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTab('Log', 0),
          _buildTab('History', 1),
          _buildTab('Stats', 2),
          _buildTab('Help', 3),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? AppColors.darkGreen
                  : (widget.isDarkMode ? Colors.white70 : Colors.white),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return LogTab(
          mealNameController: _mealNameController,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          isDarkMode: widget.isDarkMode,
          onSelectDate: _selectDate,
          onSelectTime: _selectTime,
          onLogMeal: _logMeal,
        );
      case 1:
        return HistoryTab(
          meals: _meals,
          searchController: _searchController,
          isDarkMode: widget.isDarkMode,
          onSearchChanged: (value) => setState(() {}),
          onEditMeal: _editMeal,
          onDeleteMeal: _deleteMeal,
        );
      case 2:
        return StatsTab(
          meals: _meals,
          isDarkMode: widget.isDarkMode,
        );
      case 3:
        return HelpTab(
          isDarkMode: widget.isDarkMode,
        );
      default:
        return LogTab(
          mealNameController: _mealNameController,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          isDarkMode: widget.isDarkMode,
          onSelectDate: _selectDate,
          onSelectTime: _selectTime,
          onLogMeal: _logMeal,
        );
    }
  }
}
