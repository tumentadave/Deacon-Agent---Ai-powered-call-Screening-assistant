import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistoryItem extends StatelessWidget {
  final Map<String, dynamic> callData;
  final VoidCallback? onTap;
  final VoidCallback? onCallBack;
  final VoidCallback? onMessage;
  final VoidCallback? onAddContact;
  final VoidCallback? onDelete;
  final VoidCallback? onBlock;

  const CallHistoryItem({
    Key? key,
    required this.callData,
    this.onTap,
    this.onCallBack,
    this.onMessage,
    this.onAddContact,
    this.onDelete,
    this.onBlock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = callData['status'] as String;
    final String callerName = callData['callerName'] as String;
    final String phoneNumber = callData['phoneNumber'] as String;
    final String purpose = callData['purpose'] as String;
    final String timestamp = callData['timestamp'] as String;
    final String duration = callData['duration'] as String;
    final double confidenceScore =
        (callData['confidenceScore'] as num).toDouble();

    return Dismissible(
      key: Key(callData['id'].toString()),
      background: Container(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.successGreen,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Call Back',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.accentRed.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Block',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.accentRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'block',
              color: AppTheme.accentRed,
              size: 6.w,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onCallBack?.call();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _showBlockConfirmation(context);
        }
        return false;
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: _getStatusIcon(status),
                          color: _getStatusColor(status),
                          size: 6.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            callerName.isNotEmpty ? callerName : phoneNumber,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (callerName.isNotEmpty) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              phoneNumber,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timestamp,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (duration.isNotEmpty) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            duration,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.borderGray,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'psychology',
                            color: AppTheme.primaryOrange,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'AI Purpose Analysis',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getConfidenceColor(confidenceScore)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${(confidenceScore * 100).toInt()}%',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: _getConfidenceColor(confidenceScore),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        purpose,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return AppTheme.successGreen;
      case 'declined':
        return AppTheme.accentRed;
      case 'blocked':
        return AppTheme.errorOrangeRed;
      case 'missed':
        return AppTheme.warningAmber;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'call_received';
      case 'declined':
        return 'call_end';
      case 'blocked':
        return 'block';
      case 'missed':
        return 'call_missed';
      default:
        return 'phone';
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return AppTheme.successGreen;
    } else if (confidence >= 0.6) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.accentRed;
    }
  }

  Future<bool> _showBlockConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Block Number',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Text(
                'Are you sure you want to block this number? Future calls will be automatically declined.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onBlock?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                  ),
                  child: Text('Block'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
