import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SliderSettingWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final double initialValue;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? valueFormatter;
  final bool showDivider;

  const SliderSettingWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.valueFormatter,
    this.showDivider = true,
  }) : super(key: key);

  @override
  State<SliderSettingWidget> createState() => _SliderSettingWidgetState();
}

class _SliderSettingWidgetState extends State<SliderSettingWidget> {
  late double _value;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.subtitle!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  widget.valueFormatter?.call(_value) ??
                      _value.toStringAsFixed(1),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: _value,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChanged: (double newValue) {
                  setState(() {
                    _value = newValue;
                  });
                  widget.onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
