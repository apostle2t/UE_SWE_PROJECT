import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

// App Colors
class AppColors {
  // Light Theme Colors
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color darkGreen = Color(0xFF1A4D3E);
  static const Color lightGreen = Color(0xFF3DD68C);
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1F2E);
  static const Color darkCard = Color(0xFF242B3E);
  static const Color darkSurface = Color(0xFF2D3548);

  // Gradient Colors
  static const Color pinkGradientStart = Color(0xFFEC407A);
  static const Color purpleGradientEnd = Color(0xFF9C27B0);
  static const Color blueGradientStart = Color(0xFF5C6BC0);
  static const Color blueGradientEnd = Color(0xFF7E57C2);
}

// Meal Model
class Meal {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;

  Meal({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.darkGreen,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryGreen,
          secondary: AppColors.lightGreen,
          surface: AppColors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryGreen,
          secondary: AppColors.lightGreen,
          surface: AppColors.darkCard,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NutriTrackHome(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class NutriTrackHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const NutriTrackHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<NutriTrackHome> createState() => _NutriTrackHomeState();
}

class _NutriTrackHomeState extends State<NutriTrackHome> {
  int _selectedTabIndex = 0;
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Sample meal data
  final List<Meal> _meals = [
    Meal(
      id: '1',
      name: 'Steak',
      date: DateTime(2026, 1, 14),
      time: const TimeOfDay(hour: 17, minute: 13),
    ),
    Meal(
      id: '2',
      name: 'Chicken',
      date: DateTime(2026, 1, 7),
      time: const TimeOfDay(hour: 17, minute: 23),
    ),
    Meal(
      id: '3',
      name: 'Chicken',
      date: DateTime(2026, 1, 7),
      time: const TimeOfDay(hour: 12, minute: 30),
    ),
    Meal(
      id: '4',
      name: 'Salad',
      date: DateTime(2026, 1, 5),
      time: const TimeOfDay(hour: 13, minute: 0),
    ),
    Meal(
      id: '5',
      name: 'Pasta',
      date: DateTime(2026, 1, 3),
      time: const TimeOfDay(hour: 19, minute: 45),
    ),
  ];

  void _logMeal() {
    if (_mealNameController.text.isNotEmpty) {
      setState(() {
        _meals.insert(
          0,
          Meal(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _mealNameController.text,
            date: _selectedDate,
            time: _selectedTime,
          ),
        );
        _mealNameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Meal logged successfully!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NutriTrack',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Track your daily meals',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white70 : Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Theme Toggle / Refresh Button
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
        return _buildLogTab();
      case 1:
        return _buildHistoryTab();
      case 2:
        return _buildStatsTab();
      default:
        return _buildLogTab();
    }
  }

  Widget _buildLogTab() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            widget.isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Log Your Meal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'What did you eat today?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Meal Name Label
            Text(
              'Meal Name',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Meal Name Input
            Container(
              decoration: BoxDecoration(
                color: widget.isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isDarkMode
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: TextField(
                controller: _mealNameController,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Chicken Salad',
                  hintStyle: TextStyle(
                    color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.auto_awesome,
                      color: widget.isDarkMode
                          ? Colors.white38
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Date and Time Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppColors.darkCard
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: widget.isDarkMode
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
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedDate.day.toString(),
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(_selectedDate),
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white70
                                      : Colors.grey,
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
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? AppColors.darkCard
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: widget.isDarkMode
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
                              Icon(
                                Icons.access_time,
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedTime.format(context),
                                style: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.access_time_outlined,
                                color: widget.isDarkMode
                                    ? Colors.white38
                                    : Colors.grey.shade400,
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
            ),
            const SizedBox(height: 32),
            // Log Meal Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    // Group meals by date
    Map<String, List<Meal>> groupedMeals = {};
    for (var meal in _meals) {
      String dateKey = DateFormat('MMM d').format(meal.date);
      if (!groupedMeals.containsKey(dateKey)) {
        groupedMeals[dateKey] = [];
      }
      groupedMeals[dateKey]!.add(meal);
    }

    // Filter meals based on search
    String searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      groupedMeals = Map.fromEntries(
        groupedMeals.entries.map((entry) {
          return MapEntry(
            entry.key,
            entry.value
                .where((meal) => meal.name.toLowerCase().contains(searchQuery))
                .toList(),
          );
        }).where((entry) => entry.value.isNotEmpty),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color:
            widget.isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.pinkGradientStart,
                        AppColors.purpleGradientEnd,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_meals.length} meals logged',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color:
                        widget.isDarkMode ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: widget.isDarkMode
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search your meals...',
                      hintStyle: TextStyle(
                        color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                      ),
                    ),
                  ),
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
                List<Meal> meals = groupedMeals[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryGreen,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateKey,
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Meal Cards
                    ...meals.map((meal) => _buildMealCard(meal)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.isDarkMode
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
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(meal.time),
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildStatsTab() {
    // Calculate stats
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    int mealsThisWeek = _meals
        .where((meal) =>
            meal.date.isAfter(startOfWeek.subtract(const Duration(days: 1))))
        .length;
    int mealsThisMonth = _meals
        .where((meal) =>
            meal.date.isAfter(startOfMonth.subtract(const Duration(days: 1))))
        .length;

    // Calculate day streak
    int dayStreak = _calculateDayStreak();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color:
            widget.isDarkMode ? AppColors.darkBackground : AppColors.lightGrey,
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.blueGradientStart,
                    AppColors.blueGradientEnd,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your meal tracking insights',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primaryGreen,
                    iconBgColor: AppColors.primaryGreen.withOpacity(0.1),
                    value: mealsThisWeek.toString(),
                    label: 'This Week',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    iconColor: Colors.purple,
                    iconBgColor: Colors.purple.withOpacity(0.1),
                    value: mealsThisMonth.toString(),
                    label: 'This Month',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department,
                    iconColor: Colors.orange,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                    value: dayStreak.toString(),
                    label: 'Day Streak',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.restaurant,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue.withOpacity(0.1),
                    value: _meals.length.toString(),
                    label: 'Total Meals',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Last 7 Days Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isDarkMode
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
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSimpleChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: widget.isDarkMode
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
              color:
                  widget.isDarkMode ? iconColor.withOpacity(0.2) : iconBgColor,
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
              color: widget.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white54 : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDayStreak() {
    if (_meals.isEmpty) return 0;

    // Sort meals by date
    List<DateTime> uniqueDates = _meals
        .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (uniqueDates.isEmpty) return 0;

    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Check if there's a meal today or yesterday
    if (uniqueDates.first.difference(today).inDays.abs() > 1) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < uniqueDates.length - 1; i++) {
      if (uniqueDates[i].difference(uniqueDates[i + 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Widget _buildSimpleChart() {
    // Get meals per day for last 7 days
    List<int> mealsPerDay = [];
    List<String> dayLabels = [];

    for (int i = 6; i >= 0; i--) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      int count = _meals
          .where((m) =>
              m.date.year == day.year &&
              m.date.month == day.month &&
              m.date.day == day.day)
          .length;
      mealsPerDay.add(count);
      dayLabels.add(DateFormat('E').format(day).substring(0, 1));
    }

    int maxMeals = mealsPerDay.reduce((a, b) => a > b ? a : b);
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
              Text(
                maxMeals.toString(),
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                (maxMeals ~/ 2).toString(),
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                '0',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white38 : Colors.grey,
                  fontSize: 12,
                ),
              ),
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
                        color: widget.isDarkMode ? Colors.white38 : Colors.grey,
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
}
