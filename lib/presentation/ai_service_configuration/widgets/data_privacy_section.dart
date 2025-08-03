import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataPrivacySection extends StatelessWidget {
  const DataPrivacySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.primaryOrange,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Data Privacy & Security',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepSlate,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildPrivacyPoint(
            'Voice data is processed securely by your selected AI service provider',
            'mic',
          ),
          SizedBox(height: 1.5.h),
          _buildPrivacyPoint(
            'API keys are encrypted and stored locally on your device',
            'vpn_key',
          ),
          SizedBox(height: 1.5.h),
          _buildPrivacyPoint(
            'No call recordings are permanently stored by DEACON AI',
            'delete_forever',
          ),
          SizedBox(height: 1.5.h),
          _buildPrivacyPoint(
            'All processing complies with GDPR and regional privacy laws',
            'verified_user',
          ),
          SizedBox(height: 2.h),
          TextButton.icon(
            onPressed: () {
              // Open privacy policy
            },
            icon: CustomIconWidget(
              iconName: 'open_in_new',
              color: AppTheme.primaryOrange,
              size: 18,
            ),
            label: Text(
              'Read Full Privacy Policy',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPoint(String text, String iconName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.successGreen,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.deepSlate,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
