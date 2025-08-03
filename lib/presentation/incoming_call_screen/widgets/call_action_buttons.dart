import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CallActionButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onVoicemail;

  const CallActionButtons({
    Key? key,
    required this.onAccept,
    required this.onDecline,
    required this.onVoicemail,
  }) : super(key: key);

  void _handleButtonPress(VoidCallback action) {
    // Haptic feedback for button press
    HapticFeedback.mediumImpact();
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Decline Call Button
          _ActionButton(
            onPressed: () => _handleButtonPress(onDecline),
            backgroundColor: AppTheme.accentRed,
            icon: Icons.call_end,
            label: 'Decline',
            width: 25.w,
          ),

          // Send to Voicemail Button
          _ActionButton(
            onPressed: () => _handleButtonPress(onVoicemail),
            backgroundColor: AppTheme.textSecondary,
            icon: Icons.voicemail,
            label: 'Voicemail',
            width: 25.w,
          ),

          // Accept Call Button
          _ActionButton(
            onPressed: () => _handleButtonPress(onAccept),
            backgroundColor: AppTheme.successGreen,
            icon: Icons.call,
            label: 'Accept',
            width: 25.w,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final double width;

  const _ActionButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.width,
  }) : super(key: key);

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: 15.h,
              decoration: BoxDecoration(
                color: _isPressed
                    ? widget.backgroundColor.withValues(alpha: 0.8)
                    : widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withValues(alpha: 0.3),
                    blurRadius: _isPressed ? 4 : 8,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: widget.icon.codePoint.toString(),
                    color: AppTheme.pureWhite,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.label,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
