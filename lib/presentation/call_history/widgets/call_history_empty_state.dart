import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistoryEmptyState extends StatelessWidget {
  final VoidCallback? onSetupTap;

  const CallHistoryEmptyState({
    Key? key,
    this.onSetupTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'call_missed_outgoing',
                  color: AppTheme.primaryOrange,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Call History',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.deepSlate,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your AI-screened calls will appear here once you start receiving calls. Make sure DEACON AI is properly configured.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (onSetupTap != null) ...[
              ElevatedButton.icon(
                onPressed: onSetupTap,
                icon: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.pureWhite,
                  size: 5.w,
                ),
                label: Text('Verify Setup'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/permission-setup');
                },
                child: Text('Check Permissions'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
