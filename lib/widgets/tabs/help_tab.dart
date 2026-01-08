import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../common/header_card.dart';

/// Help tab widget with FAQ and quick start guide
class HelpTab extends StatefulWidget {
  final bool isDarkMode;

  const HelpTab({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  // Track which FAQ items are expanded
  final Map<int, bool> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
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
            // Help & FAQ Header Card
            HeaderCard.blue(
              title: 'Help & FAQ',
              subtitle: 'Quick guide to get started',
              icon: Icons.help_outline,
            ),
            const SizedBox(height: 24),

            // Quick Start Section
            _buildQuickStartSection(),
            const SizedBox(height: 20),

            // Pro Tips Section
            _buildProTipsSection(),
            const SizedBox(height: 20),

            // FAQ Section
            _buildFAQSection(),
            const SizedBox(height: 20),

            // About Section
            _buildAboutSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Quick Start',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Step 1
          _buildStep(
            number: '1',
            title: 'Log meals',
            description: 'in the "Log" tab with name, date, and time',
          ),
          const SizedBox(height: 12),

          // Step 2
          _buildStep(
            number: '2',
            title: 'View history',
            description: 'and search for past meals',
          ),
          const SizedBox(height: 12),

          // Step 3
          _buildStep(
            number: '3',
            title: 'Track stats',
            description: 'and maintain your daily streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 14,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$title ',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProTipsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Pro Tips',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tips list
          _buildTip('Log meals right after eating for accuracy'),
          const SizedBox(height: 8),
          _buildTip('Build a daily streak to stay motivated'),
          const SizedBox(height: 8),
          _buildTip('Use descriptive names for easier searching'),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqItems = [
      {
        'question': 'How do I log a meal?',
        'answer':
            "Go to the 'Log' tab, enter the name of your meal, select the date and time, then tap 'Log Meal'.",
      },
      {
        'question': 'Can I edit or delete a meal?',
        'answer':
            "Yes! Go to the 'History' tab, find the meal you want to modify, and tap the edit (pencil) or delete (trash) icon.",
      },
      {
        'question': 'What is the day streak?',
        'answer':
            "Your day streak counts consecutive days where you've logged at least one meal. It helps you build a habit of tracking your meals regularly.",
      },
      {
        'question': 'Where is my data stored?',
        'answer':
            "All your meal data is stored locally on your device using SQLite. Your data is private and never leaves your device.",
      },
      {
        'question': 'How do I use dark mode?',
        'answer':
            "Tap the sun/moon icon in the top-right corner of the app to toggle between light and dark mode.",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // FAQ Items
          ...faqItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildFAQItem(
              index: index,
              question: item['question']!,
              answer: item['answer']!,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final isExpanded = _expandedItems[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Question row (tappable)
          InkWell(
            onTap: () {
              setState(() {
                _expandedItems[index] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.isDarkMode ? Colors.white54 : Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Answer (shown when expanded)
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white60 : Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.accentTeal.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'About NutriTrack',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A simple meal tracking app to help you stay aware of your eating habits.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white60 : Colors.black54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Version 1.0 • University Project',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white38 : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
