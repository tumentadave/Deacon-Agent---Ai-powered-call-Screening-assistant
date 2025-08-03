import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AiProcessingStatus extends StatefulWidget {
  final bool isListening;
  final String statusText;

  const AiProcessingStatus({
    Key? key,
    required this.isListening,
    required this.statusText,
  }) : super(key: key);

  @override
  State<AiProcessingStatus> createState() => _AiProcessingStatusState();
}

class _AiProcessingStatusState extends State<AiProcessingStatus>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(AiProcessingStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _pulseController.repeat(reverse: true);
        _rotationController.repeat();
      } else {
        _pulseController.stop();
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated Microphone Icon
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isListening ? _pulseAnimation.value : 1.0,
              child: Transform.rotate(
                angle:
                    widget.isListening ? _rotationAnimation.value * 0.1 : 0.0,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: widget.isListening
                        ? AppTheme.primaryOrange.withValues(alpha: 0.2)
                        : AppTheme.textSecondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: widget.isListening ? 'mic' : 'mic_off',
                    color: widget.isListening
                        ? AppTheme.primaryOrange
                        : AppTheme.textSecondary,
                    size: 8.w,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),

        // Status Text
        Text(
          widget.statusText,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: widget.isListening
                ? AppTheme.primaryOrange
                : AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        // Processing Dots Animation
        if (widget.isListening) ...[
          SizedBox(height: 1.h),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final delay = index * 0.3;
                  final animationValue = (_pulseController.value + delay) % 1.0;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(
                        alpha: 0.3 + (animationValue * 0.7),
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ],
    );
  }
}
