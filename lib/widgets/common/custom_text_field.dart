import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Custom text input field with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isDarkMode;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isDarkMode,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white38 : Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: isDarkMode ? Colors.white38 : Colors.grey,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    suffixIcon,
                    color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
