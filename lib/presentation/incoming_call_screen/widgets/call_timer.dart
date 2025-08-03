import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CallTimer extends StatefulWidget {
  final DateTime callStartTime;
  final DateTime? aiProcessingStartTime;

  const CallTimer({
    Key? key,
    required this.callStartTime,
    this.aiProcessingStartTime,
  }) : super(key: key);

  @override
  State<CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<CallTimer> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final currentTime = snapshot.data!;
        final callDuration = currentTime.difference(widget.callStartTime);
        final aiProcessingDuration = widget.aiProcessingStartTime != null
            ? currentTime.difference(widget.aiProcessingStartTime!)
            : null;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.borderGray.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Call Duration
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.textSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _formatDuration(callDuration),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),

              // Separator and AI Processing Time
              if (aiProcessingDuration != null) ...[
                SizedBox(width: 3.w),
                Container(
                  width: 1,
                  height: 4.w,
                  color: AppTheme.borderGray,
                ),
                SizedBox(width: 3.w),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.primaryOrange,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatDuration(aiProcessingDuration),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
