import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContinueButtonWidget extends StatelessWidget {
  final String selectedLanguageCode;
  final VoidCallback onPressed;
  final bool isEnabled;

  const ContinueButtonWidget({
    Key? key,
    required this.selectedLanguageCode,
    required this.onPressed,
    required this.isEnabled,
  }) : super(key: key);

  String _getButtonText() {
    switch (selectedLanguageCode) {
      case 'en':
        return 'Continue';
      case 'tr':
        return 'Devam Et';
      case 'fr':
        return 'Continuer';
      case 'de':
        return 'Weiter';
      default:
        return 'Continue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.primaryOrange
              : AppTheme.lightTheme.colorScheme.outline,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isEnabled ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getButtonText(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
