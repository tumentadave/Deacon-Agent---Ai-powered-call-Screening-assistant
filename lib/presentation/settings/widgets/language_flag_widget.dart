import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LanguageFlagWidget extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final bool isSelected;

  const LanguageFlagWidget({
    Key? key,
    required this.languageCode,
    required this.languageName,
    this.isSelected = false,
  }) : super(key: key);

  String _getFlagEmoji(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return '🇺🇸';
      case 'tr':
        return '🇹🇷';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      default:
        return '🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryOrange.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: AppTheme.primaryOrange, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFlagEmoji(languageCode),
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(width: 2.w),
          Text(
            languageName,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppTheme.primaryOrange : AppTheme.deepSlate,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
