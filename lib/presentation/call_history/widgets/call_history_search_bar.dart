import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistorySearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onVoiceSearch;
  final String hintText;

  const CallHistorySearchBar({
    Key? key,
    required this.onSearchChanged,
    this.onVoiceSearch,
    this.hintText = 'Search calls, numbers, or purposes...',
  }) : super(key: key);

  @override
  State<CallHistorySearchBar> createState() => _CallHistorySearchBarState();
}

class _CallHistorySearchBarState extends State<CallHistorySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchActive ? AppTheme.primaryOrange : AppTheme.borderGray,
          width: _isSearchActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: _isSearchActive
                  ? AppTheme.primaryOrange
                  : AppTheme.textSecondary,
              size: 5.w,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                widget.onSearchChanged(value);
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });
              },
              onTap: () {
                setState(() {
                  _isSearchActive = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                _searchController.clear();
                widget.onSearchChanged('');
                setState(() {
                  _isSearchActive = false;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
          ],
          if (widget.onVoiceSearch != null) ...[
            Container(
              height: 6.h,
              width: 1,
              color: AppTheme.borderGray,
              margin: EdgeInsets.symmetric(vertical: 1.h),
            ),
            GestureDetector(
              onTap: widget.onVoiceSearch,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomIconWidget(
                  iconName: 'mic',
                  color: AppTheme.primaryOrange,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
