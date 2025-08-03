import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallDetailModal extends StatelessWidget {
  final Map<String, dynamic> callData;

  const CallDetailModal({
    Key? key,
    required this.callData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String callerName = callData['callerName'] as String;
    final String phoneNumber = callData['phoneNumber'] as String;
    final String purpose = callData['purpose'] as String;
    final String fullTranscript = callData['fullTranscript'] as String;
    final String timestamp = callData['timestamp'] as String;
    final String duration = callData['duration'] as String;
    final String status = callData['status'] as String;
    final double confidenceScore =
        (callData['confidenceScore'] as num).toDouble();
    final List<dynamic> aiAnalysis = callData['aiAnalysis'] as List<dynamic>;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(callerName, phoneNumber, status),
                  SizedBox(height: 3.h),
                  _buildCallInfo(timestamp, duration),
                  SizedBox(height: 3.h),
                  _buildAIAnalysisSection(purpose, confidenceScore),
                  SizedBox(height: 3.h),
                  _buildTranscriptSection(fullTranscript),
                  SizedBox(height: 3.h),
                  _buildDetailedAnalysis(aiAnalysis),
                  SizedBox(height: 3.h),
                  _buildActionButtons(context, phoneNumber),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String callerName, String phoneNumber, String status) {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: _getStatusColor(status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7.5.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: _getStatusIcon(status),
              color: _getStatusColor(status),
              size: 8.w,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                callerName.isNotEmpty ? callerName : 'Unknown Caller',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                phoneNumber,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCallInfo(String timestamp, String duration) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderGray),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Call Time',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  timestamp,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color: AppTheme.borderGray,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'timer',
                        color: AppTheme.textSecondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Duration',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    duration.isNotEmpty ? duration : 'N/A',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisSection(String purpose, double confidenceScore) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.primaryOrange,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Purpose Analysis',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(confidenceScore)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'verified',
                      color: _getConfidenceColor(confidenceScore),
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${(confidenceScore * 100).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getConfidenceColor(confidenceScore),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            purpose,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptSection(String fullTranscript) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'transcribe',
              color: AppTheme.deepSlate,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Full Transcript',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderGray),
          ),
          child: Text(
            fullTranscript.isNotEmpty
                ? fullTranscript
                : 'No transcript available',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              fontStyle:
                  fullTranscript.isEmpty ? FontStyle.italic : FontStyle.normal,
              color: fullTranscript.isEmpty
                  ? AppTheme.textSecondary
                  : AppTheme.deepSlate,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedAnalysis(List<dynamic> aiAnalysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.deepSlate,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Detailed Analysis',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...aiAnalysis.map((analysis) {
          final Map<String, dynamic> item = analysis as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['category'] as String,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  item['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, String phoneNumber) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Implement call back functionality
            },
            icon: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.successGreen,
              size: 4.w,
            ),
            label: Text(
              'Call Back',
              style: TextStyle(color: AppTheme.successGreen),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.successGreen),
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Implement message functionality
            },
            icon: CustomIconWidget(
              iconName: 'message',
              color: AppTheme.primaryOrange,
              size: 4.w,
            ),
            label: Text('Message'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
      ],
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
}
