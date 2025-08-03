import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PurposeCard extends StatelessWidget {
  final String purpose;
  final double confidenceLevel;
  final String category;

  const PurposeCard({
    Key? key,
    required this.purpose,
    required this.confidenceLevel,
    required this.category,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'business':
        return AppTheme.successGreen;
      case 'personal':
        return AppTheme.primaryOrange;
      case 'spam':
        return AppTheme.accentRed;
      case 'telemarketing':
        return AppTheme.warningAmber;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'business':
        return Icons.business;
      case 'personal':
        return Icons.person;
      case 'spam':
        return Icons.block;
      case 'telemarketing':
        return Icons.campaign;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Container(
      width: 85.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Category
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getCategoryIcon().codePoint.toString(),
                  color: categoryColor,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Call Purpose Identified',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      category.toUpperCase(),
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Purpose Text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.softOffWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              purpose,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 2.h),

          // Confidence Indicator
          Row(
            children: [
              Text(
                'AI Confidence:',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: LinearProgressIndicator(
                  value: confidenceLevel / 100,
                  backgroundColor: AppTheme.borderGray,
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                  minHeight: 1.h,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '${confidenceLevel.toInt()}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
