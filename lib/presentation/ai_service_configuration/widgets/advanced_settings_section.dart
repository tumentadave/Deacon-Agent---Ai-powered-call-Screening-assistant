import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsSection extends StatelessWidget {
  final double accuracyPreference;
  final int processingTimeout;
  final bool offlineFallback;
  final Function(double) onAccuracyChanged;
  final Function(int) onTimeoutChanged;
  final Function(bool) onOfflineFallbackChanged;

  const AdvancedSettingsSection({
    Key? key,
    required this.accuracyPreference,
    required this.processingTimeout,
    required this.offlineFallback,
    required this.onAccuracyChanged,
    required this.onTimeoutChanged,
    required this.onOfflineFallbackChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.primaryOrange,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Advanced Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Accuracy Preference
          Text(
            'Accuracy Preference',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Higher accuracy may increase processing time',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                'Fast',
                style: AppTheme.lightTheme.textTheme.labelSmall,
              ),
              Expanded(
                child: Slider(
                  value: accuracyPreference,
                  min: 0.0,
                  max: 1.0,
                  divisions: 2,
                  onChanged: onAccuracyChanged,
                  activeColor: AppTheme.primaryOrange,
                  inactiveColor: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              Text(
                'Accurate',
                style: AppTheme.lightTheme.textTheme.labelSmall,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Processing Timeout
          Text(
            'Processing Timeout',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Maximum time to wait for AI response',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: processingTimeout,
                isExpanded: true,
                items: [5, 10, 15, 20, 30].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('${value} seconds'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    onTimeoutChanged(newValue);
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Offline Fallback
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Fallback Mode',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Allow basic call screening when AI services are unavailable',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: offlineFallback,
                onChanged: onOfflineFallbackChanged,
                activeColor: AppTheme.primaryOrange,
              ),
            ],
          ),

          if (offlineFallback) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningAmber.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.warningAmber,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'In offline mode, calls will be screened using basic caller ID information only.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningAmber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
