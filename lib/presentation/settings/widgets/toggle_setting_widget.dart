import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ToggleSettingWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Widget? leading;
  final bool showDivider;

  const ToggleSettingWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.onChanged,
    this.leading,
    this.showDivider = true,
  }) : super(key: key);

  @override
  State<ToggleSettingWidget> createState() => _ToggleSettingWidgetState();
}

class _ToggleSettingWidgetState extends State<ToggleSettingWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: widget.showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.borderGray.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.subtitle!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: _value,
              onChanged: (bool newValue) {
                setState(() {
                  _value = newValue;
                });
                widget.onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
