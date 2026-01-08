import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Header card widget with gradient background
class HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  const HeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  /// Factory constructor for green themed card
  factory HeaderCard.green({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return HeaderCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: const [AppColors.primaryGreen, AppColors.primaryGreen],
    );
  }

  /// Factory constructor for pink/purple gradient card
  factory HeaderCard.pinkPurple({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return HeaderCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: const [
        AppColors.pinkGradientStart,
        AppColors.purpleGradientEnd,
      ],
    );
  }

  /// Factory constructor for blue/purple gradient card
  factory HeaderCard.bluePurple({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return HeaderCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: const [
        AppColors.blueGradientStart,
        AppColors.blueGradientEnd,
      ],
    );
  }

  /// Factory constructor for teal/blue gradient card (for Help)
  factory HeaderCard.blue({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return HeaderCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: const [
        AppColors.accentTeal,
        AppColors.blueGradientStart,
      ],
    );
  }
}
