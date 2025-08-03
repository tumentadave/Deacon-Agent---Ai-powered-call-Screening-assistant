import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistoryFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Map<String, int> filterCounts;

  const CallHistoryFilterChips({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filterCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {
        'key': 'all',
        'label': 'All',
        'icon': 'list',
        'count': filterCounts['all'] ?? 0,
      },
      {
        'key': 'accepted',
        'label': 'Accepted',
        'icon': 'call_received',
        'count': filterCounts['accepted'] ?? 0,
      },
      {
        'key': 'declined',
        'label': 'Declined',
        'icon': 'call_end',
        'count': filterCounts['declined'] ?? 0,
      },
      {
        'key': 'blocked',
        'label': 'Blocked',
        'icon': 'block',
        'count': filterCounts['blocked'] ?? 0,
      },
    ];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['key'];

          return GestureDetector(
            onTap: () => onFilterChanged(filter['key'] as String),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryOrange : AppTheme.borderGray,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filter['icon'] as String,
                    color: isSelected
                        ? AppTheme.pureWhite
                        : AppTheme.textSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    filter['label'] as String,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color:
                          isSelected ? AppTheme.pureWhite : AppTheme.deepSlate,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (filter['count'] as int > 0) ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.pureWhite.withValues(alpha: 0.2)
                            : AppTheme.primaryOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${filter['count']}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.pureWhite
                              : AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
